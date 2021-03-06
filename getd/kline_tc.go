package getd

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"strings"
	"time"

	"github.com/agux/pachon/global"
	"github.com/agux/pachon/model"
	"github.com/agux/pachon/util"
)

func getKlineTc(stk *model.Stock, tabs []model.DBTab) (
	tdmap map[model.DBTab]*model.TradeData, lkmap map[model.DBTab]int, suc bool) {
	RETRIES := 20
	tdmap = make(map[model.DBTab]*model.TradeData)
	lkmap = make(map[model.DBTab]int)
	code := stk.Code
	incr := latestUFRXdxr(stk.Code) == nil
	for _, klt := range tabs {
		for rt := 0; rt < RETRIES; rt++ {
			trdat, lklid, ok, retry := tryKlineTc(stk, klt, incr)
			if ok {
				log.Infof("%s %v fetched: %d", code, klt, len(trdat.Base))
				tdmap[klt] = trdat
				lkmap[klt] = lklid
				break
			} else {
				if retry && rt+1 < RETRIES {
					log.Printf("%s retrying [%d]", code, rt+1)
					time.Sleep(time.Millisecond * 2500)
					continue
				} else {
					log.Printf("%s failed", code)
					return tdmap, lkmap, false
				}
			}
		}
	}

	return tdmap, lkmap, true
}

func tryKlineTc(stock *model.Stock, tab model.DBTab, incr bool) (trdat *model.TradeData, sklid int, ok, retry bool) {
	var (
		code  = stock.Code
		cycle model.CYTP
		rtype model.Rtype
		body  []byte
		e     error
		url   string
		sDate = ""
		eDate = ""
		nrec  = 800 // for non-index, reinstated data, at most 800 records at a time
	)
	trdat = new(model.TradeData)
	qj := &model.QQJson{}
	switch tab {
	case model.KLINE_DAY_F, model.KLINE_DAY_NR, model.KLINE_DAY_B, model.KLINE_DAY_VLD:
		qj.Period = "day"
		cycle = model.DAY
	case model.KLINE_WEEK_F, model.KLINE_WEEK_NR, model.KLINE_WEEK_B, model.KLINE_WEEK_VLD:
		qj.Period = "week"
		cycle = model.WEEK
	case model.KLINE_MONTH_F, model.KLINE_MONTH_NR, model.KLINE_MONTH_B, model.KLINE_MONTH_VLD:
		qj.Period = "month"
		cycle = model.MONTH
	default:
		log.Errorf("unhandled kline type: %v", tab)
		return
	}
	switch tab {
	case model.KLINE_DAY_B, model.KLINE_WEEK_B, model.KLINE_MONTH_B:
		qj.Reinstate = "hfq"
		rtype = model.Backward
	case model.KLINE_DAY_NR, model.KLINE_WEEK_NR, model.KLINE_MONTH_NR:
		qj.Reinstate = ""
		rtype = model.None
	default:
		qj.Reinstate = "qfq"
		rtype = model.Forward
	}

	sklid = -1
	if incr {
		ldy := getLatestTradeDataBasic(code, model.KlineMaster, cycle, rtype, 5+1) // plus one for varate calculation
		if ldy != nil {
			sDate = ldy.Date
			sklid = ldy.Klid
			sTime, e := time.Parse(global.DateFormat, sDate)
			if e != nil {
				log.Errorf("failed to parse date: %+v", ldy)
				return
			}
			nrec = int(time.Since(sTime).Hours()/24) + 1
		} else {
			log.Printf("%s latest %s data not found, will be fully refreshed", code, tab)
		}
	} else {
		log.Printf("%s %s data will be fully refreshed", code, tab)
	}

	if tab == model.KLINE_DAY_NR || tab == model.KLINE_WEEK_NR || tab == model.KLINE_MONTH_NR || isIndex(stock.Code) {
		nrec = 7000 + rand.Intn(2000)
	}

	qj.Code = code
	qj.Fcode = strings.ToLower(stock.Market.String) + stock.Code
	// [1]: reinstatement-fqkline/get, no reinstatement-kline/kline
	// [2]: lower case market id + stock code, e.g. sz000001
	// [3]: cycle type: day, week, month, year
	// [4]: start date
	// [5]: end date
	// [6]: number of records to return
	// [7]: for forward reinstatement, use 'qfq', for backward reinstatement, use 'hfq'
	urlt := `http://web.ifzq.gtimg.cn/appstock/app/%[1]s?param=%[2]s,%[3]s,%[4]s,%[5]s,%[6]d,%[7]s`
	eDate = time.Now().Format(global.DateFormat)
	action := ""

	trdat.Code = code
	trdat.Cycle = cycle
	trdat.Reinstatement = rtype

	for {
		switch tab {
		case model.KLINE_DAY_NR, model.KLINE_WEEK_NR, model.KLINE_MONTH_NR:
			action = "kline/kline"
		default:
			action = "fqkline/get"
		}
		url = fmt.Sprintf(urlt, action, qj.Fcode, qj.Period, "", eDate, nrec, qj.Reinstate)
		//get kline data
		body, e = util.HttpGetBytes(url)
		if e != nil {
			log.Printf("%s error visiting %s: \n%+v", code, url, e)
			return trdat, sklid, false, true
		}
		e = json.Unmarshal(body, qj)
		if e != nil {
			log.Printf("failed to parse json from %s\n%+v", url, e)
			return trdat, sklid, false, true
		}
		fin := false
		if len(qj.TradeData.Base) > 0 {
			//extract data backward till sDate (excluded)
			for i := len(qj.TradeData.Base) - 1; i >= 0; i-- {
				q := qj.TradeData.Base[i]
				if q.Date == sDate {
					fin = true
					break
				}
				trdat.Base = append(trdat.Base, q)
			}
		} else {
			break
		}
		if fin || len(trdat.Base) < nrec {
			break
		}
		// need to fetch more
		first := qj.TradeData.Base[0]
		iDate, e := time.Parse(global.DateFormat, first.Date)
		if e != nil {
			log.Printf("invalid date format in %+v", first)
		}
		eDate = iDate.AddDate(0, 0, -1).Format(global.DateFormat)
	}
	//reverse, into ascending order
	for i, j := 0, len(trdat.Base)-1; i < j; i, j = i+1, j-1 {
		trdat.Base[i], trdat.Base[j] = trdat.Base[j], trdat.Base[i]
	}
	return trdat, sklid, true, false
}
