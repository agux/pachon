package getd

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"strings"
	"time"

	"github.com/carusyte/stock/conf"
	"github.com/carusyte/stock/model"
	"github.com/carusyte/stock/util"
	"github.com/sirupsen/logrus"
)

var (
	idxList []*model.IdxLst
)

func getKlineWht(stk *model.Stock, kltype []model.DBTab, persist bool) (
	qmap map[model.DBTab][]*model.Quote, lkmap map[model.DBTab]int, suc bool) {

	RETRIES := 20
	qmap = make(map[model.DBTab][]*model.Quote)
	lkmap = make(map[model.DBTab]int)
	code := stk.Code
	xdxr := latestUFRXdxr(stk.Code)
	var alts []model.DBTab
	for _, klt := range kltype {
		switch klt {
		// TODO waiting support for backward re-instatement
		case model.KLINE_DAY_B, model.KLINE_WEEK_B, model.KLINE_MONTH_B:
			alts = append(alts, klt)
		}
		for rt := 0; rt < RETRIES; rt++ {
			quotes, lklid, suc, retry := whtKline(stk, klt, xdxr, persist)
			if suc {
				logrus.Infof("%s %v fetched: %d", code, klt, len(quotes))
				qmap[klt] = quotes
				lkmap[klt] = lklid
				break
			} else {
				if retry && rt+1 < RETRIES {
					log.Printf("%s retrying [%d]", code, rt+1)
					time.Sleep(time.Millisecond * 2500)
					continue
				} else {
					log.Printf("%s failed", code)
					return qmap, lkmap, false
				}
			}
		}
	}
	if len(alts) > 0 {
		altmap, altklid, suc := getKlineTc(stk, alts)
		if suc {
			for klt, qs := range altmap {
				qmap[klt] = qs
				lkmap[klt] = altklid[klt]
			}
		}
	}
	return qmap, lkmap, true
}

func whtKline(stk *model.Stock, tab model.DBTab, xdxr *model.Xdxr, persist bool) (
	quotes []*model.Quote, lklid int, suc, retry bool) {
	url := conf.Args.DataSource.WhtURL + "/hq/hiskline"
	klt := ""
	xdrType := "none"
	switch tab {
	case model.KLINE_DAY, model.KLINE_DAY_NR, model.KLINE_DAY_B:
		klt = "day"
	case model.KLINE_WEEK, model.KLINE_WEEK_NR, model.KLINE_WEEK_B:
		klt = "week"
	case model.KLINE_MONTH, model.KLINE_MONTH_NR, model.KLINE_MONTH_B:
		klt = "month"
	}
	switch tab {
	case model.KLINE_DAY, model.KLINE_WEEK, model.KLINE_MONTH:
		xdrType = "pre"
	}
	mkt := strings.ToLower(stk.Market.String)
	stkCode := mkt + stk.Code
	codeid := stk.Code
	if isIndex(stkCode) {
		codeid = stkCode
	}
	incr := true
	switch tab {
	case model.KLINE_DAY, model.KLINE_WEEK, model.KLINE_MONTH:
		incr = xdxr == nil
	}
	lklid = -1
	ldate := ""
	if incr {
		ldy := getLatestKl(codeid, tab, 5+1) //plus one offset for pre-close, varate calculation
		if ldy != nil {
			ldate = ldy.Date
			lklid = ldy.Klid
		} else {
			log.Printf("%s latest %s data not found, will be fully refreshed", codeid, tab)
		}
	} else {
		log.Printf("%s %s data will be fully refreshed", codeid, tab)
	}
	num := "0"
	if lklid != -1 {
		ltime, e := time.Parse("2006-01-02", ldate)
		if e != nil {
			log.Printf("%s %+v failed to parse date value '%s': %+v", stk.Code, tab, ldate, e)
			return nil, lklid, false, false
		}
		num = fmt.Sprintf("%d", int(time.Since(ltime).Hours()/24)+1)
	}
	form := map[string]string{
		"stkCode": stkCode,
		// "market":    mkt,
		"xdrType":   xdrType,
		"kLineType": klt,
		"num":       num, // 0: fetch all
	}
	body, e := util.HTTPPostJSON(url, nil, form)
	if e != nil {
		log.Printf("%s failed to get %v from %s: %+v", stk.Code, tab, url, e)
		return nil, lklid, false, true
	}
	data := make([]map[string]interface{}, 0, 16)
	e = json.Unmarshal(body, &data)
	if e != nil {
		log.Printf("%s failed to parse json for %v from %s: %+v\return value:%+v", stk.Code, tab, url, e, string(body))
		return nil, lklid, false, true
	}
	logrus.Debugf("return from wht: %+v", string(body))
	//extract quotes
	quotes = parseWhtJSONMaps(codeid, ldate, data)
	return quotes, lklid, true, false
}

func parseWhtJSONMaps(codeid, ldate string, data []map[string]interface{}) (quotes []*model.Quote) {
	quotes = make([]*model.Quote, 0, 16)
	for _, m := range data {
		date := m["date"].(string)[:8]
		date = date[:4] + "-" + date[4:6] + "-" + date[6:]
		if date <= ldate {
			continue
		}
		q := new(model.Quote)
		q.Code = codeid
		q.Date = date
		q.Open = m["open"].(float64)
		q.Close = m["close"].(float64)
		q.High = m["high"].(float64)
		q.Low = m["low"].(float64)
		q.Volume = sql.NullFloat64{Float64: m["vol"].(float64), Valid: true}
		q.Amount = sql.NullFloat64{Float64: m["amt"].(float64), Valid: true}
		q.Ma5 = sql.NullFloat64{Float64: m["avg5"].(float64), Valid: true}
		q.Ma10 = sql.NullFloat64{Float64: m["avg10"].(float64), Valid: true}
		q.Ma20 = sql.NullFloat64{Float64: m["avg20"].(float64), Valid: true}
		q.Ma30 = sql.NullFloat64{Float64: m["avg30"].(float64), Valid: true}
		q.Ma60 = sql.NullFloat64{Float64: m["avg60"].(float64), Valid: true}
		q.Ma120 = sql.NullFloat64{Float64: m["avg120"].(float64), Valid: true}
		q.Ma250 = sql.NullFloat64{Float64: m["avg250"].(float64), Valid: true}
		q.Vol5 = sql.NullFloat64{Float64: m["vol5"].(float64), Valid: true}
		q.Vol10 = sql.NullFloat64{Float64: m["vol10"].(float64), Valid: true}
		q.Vol20 = sql.NullFloat64{Float64: m["vol20"].(float64), Valid: true}
		q.Vol30 = sql.NullFloat64{Float64: m["vol30"].(float64), Valid: true}
		q.Vol60 = sql.NullFloat64{Float64: m["vol60"].(float64), Valid: true}
		q.Vol120 = sql.NullFloat64{Float64: m["vol120"].(float64), Valid: true}
		q.Vol250 = sql.NullFloat64{Float64: m["vol250"].(float64), Valid: true}
		if turnover, ok := m["turnover"].(float64); ok {
			q.Xrate = sql.NullFloat64{Float64: turnover, Valid: true}
		}
		// special case treated as non-trading date and should be skipped
		preClose := m["preClose"].(float64)
		if preClose == q.Close &&
			q.Close == q.Open &&
			q.Close == q.High &&
			q.Close == q.Low &&
			q.Volume.Float64 == 0 &&
			q.Amount.Float64 == 0 {
			logrus.Debugf("%s skipping dummy data:%+v", q.Code, m)
			continue
		}
		quotes = append(quotes, q)
	}
	return
}

//isIndex returns true if the specified code is a member of the indices
func isIndex(code string) bool {
	if idxList == nil {
		var e error
		idxList, e = GetIdxLst()
		if e != nil {
			panic(e)
		}
	}
	for _, index := range idxList {
		if index.Code == code {
			return true
		}
	}
	return false
}

// recover volume, amount and xrate related values in backward reinstated table
func whtPostProcessKline(stks *model.Stocks) (rstks *model.Stocks) {
	//FIXME: resolve inconsistency
	rstks = new(model.Stocks)
	tabs := []model.DBTab{model.KLINE_DAY_B, model.KLINE_WEEK_B, model.KLINE_MONTH_B}
	stabs := []model.DBTab{model.KLINE_DAY, model.KLINE_WEEK, model.KLINE_MONTH}
	log.Printf("post processing klines: %+v", tabs)
	for code, s := range stks.Map {
		suc := true
		for i, tab := range tabs {
			usql := fmt.Sprintf("update %v t inner join %v s using(code, date) set "+
				"t.volume = s.volume, t.amount = s.amount, t.xrate = s.xrate, t.lr_vol = s.lr_vol, "+
				"t.lr_amt = s.lr_amt, t.lr_xr = s.lr_xr where t.code = ? and "+
				"(t.volume is null or t.amount is null or t.xrate is null or "+
				"t.lr_vol is null or t.lr_amt is null or t.lr_xr is null)", tab, stabs[i])
			_, e := dbmap.Exec(usql, code)
			if e != nil {
				log.Printf("%v failed to post process %v:%+v", code, tab, e)
				suc = false
			}
		}
		if suc {
			rstks.Add(s)
		}
	}
	return
}
