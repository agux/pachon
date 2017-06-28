package getd

import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/carusyte/stock/model"
	"github.com/carusyte/stock/util"
	"log"
	"strconv"
	"strings"
	"sync"
	"github.com/carusyte/stock/global"
)

type KLType string

const (
	DAY   KLType = "kline_d"
	DAY_N        = "kline_d_n"
	WEEK         = "kline_w"
	MONTH        = "kline_m"
)

func GetKlines(stks []*model.Stock, kltype ... KLType) {
	log.Println("begin to fetch kline data")
	var wg sync.WaitGroup
	wf := make(chan int, MAX_CONCURRENCY)
	for _, stk := range stks {
		wg.Add(1)
		wf <- 1
		go getKline(stk, kltype, &wg, &wf)
	}
	wg.Wait()
	log.Printf("%s data updated.", strings.Join(kt2strs(kltype), ", "))
}

//convert slice of KLType to slice of string
func kt2strs(kltype []KLType) (s []string) {
	s = make([]string, len(kltype))
	for i, e := range kltype {
		s[i] = string(e)
	}
	return
}

func getKline(stk *model.Stock, kltype []KLType, wg *sync.WaitGroup, wf *chan int) {
	defer func() {
		wg.Done()
		<-*wf
	}()
	xdxr := latestUFRXdxr(stk.Code)
	for _, t := range kltype {
		switch t {
		case DAY, DAY_N:
			getDailyKlines(stk.Code, t, xdxr == nil)
		case WEEK, MONTH:
			getLongKlines(stk.Code, t, xdxr == nil)
		default:
			log.Panicf("unhandled kltype: %s", t)
		}
	}
	if xdxr != nil {
		//update xpriced flag in xdxr to mark that all price data has been reinstated
		dbmap.Exec("update xdxr set xprice = 'Y' where code = ? and idx = ?", xdxr.Code, xdxr.Idx)
	}
}

func getDailyKlines(code string, klt KLType, incr bool) (kldy []*model.Quote) {
	RETRIES := 5
	var (
		klast  model.Klast
		ktoday model.Ktoday
		ldate  string
		lklid  int
		body   []byte
		e      error
		mode   string
	)
	//mode:
	// 00-no reinstatement
	// 01-forward reinstatement
	// 02-backward reinstatement
	switch klt {
	case DAY:
		mode = "01"
	case DAY_N:
		mode = "00"
	default:
		log.Panicf("unhandled kltype: %s", klt)
	}
RETRY:
	for rt := 0; rt < RETRIES; rt++ {
		url_today := fmt.Sprintf("http://d.10jqka.com.cn/v2/line/hs_%s/%s/today.js", code, mode)
		body, e = util.HttpGetBytes(url_today)
		if e != nil {
			log.Printf("stop retrying to get today kline for %s", code)
			return
		}
		ktoday = model.Ktoday{}
		e = json.Unmarshal(strip(body), &ktoday)
		if e != nil {
			if rt < RETRIES {
				log.Printf("retrying to parse kline json for %s [%d]: %+v\n%s", code, rt+1, e,
					string(body))
				continue
			} else {
				log.Printf("stop retrying to parse kline json for %s [%d]: %+v\n%s", code, rt+1,
					e, string(body))
				return
			}
		}
		if ktoday.Code != "" {
			kldy = append(kldy, &ktoday.Quote)
		} else {
			log.Printf("kline today skipped: %s", url_today)
		}

		//get last kline data
		url_last := fmt.Sprintf("http://d.10jqka.com.cn/v2/line/hs_%s/%s/last.js", code, mode)
		body, e = util.HttpGetBytes(url_last)
		if e != nil {
			log.Printf("stop retrying to get last kline for %s", code)
			return []*model.Quote{}
		}
		klast = model.Klast{}
		e = json.Unmarshal(strip(body), &klast)
		if e != nil {
			if rt < RETRIES {
				log.Printf("retrying to parse last kline json for %s [%d]: %+v\n%s\n%s", code, rt+1, e,
					url_last, string(body))
				continue
			} else {
				log.Printf("stop retrying to parse last kline json for %s [%d]: %+v\n%s\n%s", code,
					rt+1, e, url_last, string(body))
				return []*model.Quote{}
			}
		}

		if klast.Data == "" {
			log.Printf("%s last data may not be ready yet", code)
			return []*model.Quote{}
		}

		ldate = ""
		lklid = -1
		if incr {
			ldy := getLatestKl(code, klt, 3)
			if ldy != nil {
				ldate = ldy.Date
				lklid = ldy.Klid
			}
		}

		kls, more := parseKlines(code, klast.Data, ldate, "")
		if len(kls) > 0 {
			if ktoday.Date == kls[0].Date {
				kldy = append(kldy, kls[1:]...)
			} else {
				kldy = append(kldy, kls...)
			}
		} else {
			break
		}
		if more {
			//get hist kline data
			yr, e := strconv.ParseInt(kls[0].Date[:4], 10, 32)
			if e != nil {
				log.Printf("failed to parse year for %+v, stop processing. error: %+v",
					code, e)
				return []*model.Quote{}
			}
			start, e := strconv.ParseInt(klast.Start[:4], 10, 32)
			if e != nil {
				log.Printf("failed to parse json start year for %+v, stop processing. "+
					"string:%s, error: %+v", code, klast.Start, e)
				return []*model.Quote{}
			}
			for more {
				yr--
				if yr < start {
					break
				}
				// test if yr is in klast.Year map
				if _, in := klast.Year[strconv.FormatInt(yr, 10)]; !in {
					continue
				}
				url_hist := fmt.Sprintf("http://d.10jqka.com.cn/v2/line/hs_%s/%s/%d.js", code, mode,
					yr)
				body, e = util.HttpGetBytes(url_hist)
				if e != nil {
					if rt < RETRIES {
						log.Printf("retrying to get hist daily quotes for %s, %d [%d]: %+v",
							code, yr, rt+1, e)
						continue RETRY
					} else {
						log.Printf("stop retrying to get hist daily quotes for %s, %d [%d]: %+v",
							code, yr, rt+1, e)
						return []*model.Quote{}
					}
				}
				khist := model.Khist{}
				e = json.Unmarshal(strip(body), &khist)
				if e != nil {
					if rt < RETRIES {
						log.Printf("retrying to parse hist kline json for %s, %d [%d]: %+v", code,
							yr, rt+1, e)
						continue RETRY
					} else {
						log.Printf("stop retrying to parse hist kline json for %s, %d [%d]: %+v",
							code, yr, rt+1, e)
						return []*model.Quote{}
					}
				}
				kls, more = parseKlines(code, khist.Data, ldate, kldy[len(kldy)-1].Date)
				if len(kls) > 0 {
					kldy = append(kldy, kls...)
				}
			}
		}
		break
	}
	assignKlid(kldy, lklid)
	binsert(kldy, string(klt))
	return
}

func getToday(code string, typ string) (q *model.Quote, ok, retry bool) {
	url_today := fmt.Sprintf("http://d.10jqka.com.cn/v2/line/hs_%s/%s/today.js", code, typ)
	body, e := util.HttpGetBytes(url_today)
	if e != nil {
		return nil, false, false
	}

	ktoday := &model.Ktoday{}
	e = json.Unmarshal(strip(body), ktoday)
	if e != nil {
		return nil, false, true
	}
	return &ktoday.Quote, true, false
}

func getLongKlines(code string, klt KLType, incr bool) (quotes []*model.Quote) {
	urlt := "http://d.10jqka.com.cn/v2/line/hs_%s/%s/last.js"
	var typ string
	switch klt {
	case WEEK:
		typ = "11"
	case MONTH:
		typ = "21"
	default:
		log.Panicf("unhandled kltype: %s", klt)
	}
	ldate := ""
	lklid := -1
	if incr {
		latest := getLatestKl(code, klt, 2)
		if latest != nil {
			ldate = latest.Date
			lklid = latest.Klid
		}
	}
	RETRIES := 5
	url := fmt.Sprintf(urlt, code, typ)
	for rt := 0; rt < RETRIES; rt++ {
		ktoday, ok, retry := getToday(code, typ)
		if !ok {
			if retry {
				log.Printf("retrying to parse %s json for %s [%d]", klt, code, rt+1)
				continue
			} else {
				log.Printf("stop retrying to parse %s json for %s [%d]", klt, code, rt+1)
				return
			}
		}
		body, e := util.HttpGetBytes(url)
		if e != nil {
			log.Printf("can't get %s for %s. please try again later.", klt, code)
			return
		}
		khist := model.Khist{}
		e = json.Unmarshal(strip(body), &khist)
		if e != nil {
			if rt < RETRIES {
				log.Printf("retrying to parse %s json for %s, [%d]: %+v", klt, code, rt+1, e)
				continue
			} else {
				log.Printf("stop retrying to parse %s json for %s, [%d]: %+v", klt, code, rt+1, e)
				return
			}
		}
		if khist.Data == "" {
			log.Printf("%s %s data may not be ready yet", code, klt)
			return
		}
		kls, _ := parseKlines(code, khist.Data, ldate, "")
		quotes = append(quotes, ktoday)
		if len(kls) > 0 {
			//always remove the last/latest one from /last.js
			//substitute by that from /today.js
			quotes = append(quotes, kls[1:]...)
		}
		break
	}
	assignKlid(quotes, lklid)
	binsert(quotes, string(klt))
	return
}

func assignKlid(klines []*model.Quote, start int) {
	for i := len(klines) - 1; i >= 0; i-- {
		start++
		klines[i].Klid = start
	}
}

func binsert(quotes []*model.Quote, table string) (c int) {
	if len(quotes) > 0 {
		valueStrings := make([]string, 0, len(quotes))
		valueArgs := make([]interface{}, 0, len(quotes)*10)
		var code string
		for _, q := range quotes {
			valueStrings = append(valueStrings, "(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
			valueArgs = append(valueArgs, q.Code)
			valueArgs = append(valueArgs, q.Date)
			valueArgs = append(valueArgs, q.Klid)
			valueArgs = append(valueArgs, q.Open)
			valueArgs = append(valueArgs, q.High)
			valueArgs = append(valueArgs, q.Close)
			valueArgs = append(valueArgs, q.Low)
			valueArgs = append(valueArgs, q.Volume)
			valueArgs = append(valueArgs, q.Amount)
			valueArgs = append(valueArgs, q.Xrate)
			code = q.Code
		}
		stmt := fmt.Sprintf("INSERT INTO %s (code,date,klid,open,high,close,low,"+
			"volume,amount,xrate) VALUES %s on duplicate key update date=values(date),"+
			"open=values(open),high=values(high),close=values(close),low=values(low),"+
			"volume=values(volume),amount=values(amount),xrate=values(xrate)",
			table, strings.Join(valueStrings, ","))
		_, err := dbmap.Exec(stmt, valueArgs...)
		if !util.CheckErr(err, code+" failed to bulk insert "+table) {
			c = len(quotes)
		}
	}
	return
}

//parse semi-colon separated string to quotes, with latest in the head (reverse order of the string data).
func parseKlines(code, data, ldate, skipto string) (kls []*model.Quote, more bool) {
	defer func() {
		if r := recover(); r != nil {
			if e, ok := r.(error); ok {
				log.Println(e)
			}
			log.Printf("data:\n%s", data)
			kls = []*model.Quote{}
			more = false
		}
	}()
	more = true
	dates := strings.Split(data, ";")
DATES:
	for i := len(dates) - 1; i >= 0; i-- {
		// latest in the last
		es := strings.Split(strings.TrimSpace(dates[i]), ",")
		kl := &model.Quote{}
		for j, e := range es {
			e := strings.TrimSpace(e)
			//20170505,27.68,27.99,27.55,27.98,27457397,763643920.00,0.249
			//date, open, high, low, close, volume, amount, exchange
			switch j {
			case 0:
				kl.Date = e[:4] + "-" + e[4:6] + "-" + e[6:]
				if ldate != "" && kl.Date <= ldate {
					more = false
					break DATES
				} else if skipto != "" && kl.Date >= skipto {
					continue DATES
				}
			case 1:
				kl.Open = util.Str2F64(e)
			case 2:
				kl.High = util.Str2F64(e)
			case 3:
				kl.Low = util.Str2F64(e)
			case 4:
				kl.Close = util.Str2F64(e)
			case 5:
				kl.Volume = util.Str2F64(e)
			case 6:
				kl.Amount = util.Str2F64(e)
			case 7:
				kl.Xrate = util.Str2Fnull(e)
			default:
				//skip
			}
		}
		kl.Code = code
		kls = append(kls, kl)
	}
	return
}

func getLatestKl(code string, klt KLType, offset int) (q *model.Quote) {
	dbmap.SelectOne(&q, "select * from ? where code = ? order by date desc limit 1 offset ?",
		klt, code, offset)
	return
}

// checks whether the historical kline data is yet to be forward-reinstatement
func latestUFRXdxr(code string) (x *model.Xdxr) {
	sql, e := global.Dot.Raw("latestUFRXdxr")
	util.CheckErr(e, "unable to get sql: latestUFRXdxr")
	e = dbmap.SelectOne(&x, sql, code, code)
	util.CheckErr(e, "failed to run sql: "+sql)
	return x
}

func strip(data []byte) []byte {
	s := bytes.IndexByte(data, 40)     // first occurrence of '('
	e := bytes.LastIndexByte(data, 41) // last occurrence of ')'
	if s >= 0 && e >= 0 {
		return data[s+1:e]
	} else {
		return data
	}
}