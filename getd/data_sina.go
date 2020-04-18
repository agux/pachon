package getd

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"reflect"
	"regexp"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/pkg/errors"
	"github.com/ssgreg/repeat"

	"github.com/agux/pachon/conf"
	"github.com/agux/pachon/model"
	"github.com/agux/pachon/util"
	"github.com/agux/pachon/util/chrome"
	"github.com/chromedp/chromedp"
)

func init() {
	registerKlineFetcher(model.Sina, &SinaKlineFetcher{})
}

//SinaKlineFetcher fetches kline from sina
type SinaKlineFetcher struct {
	completedRequest map[string][]FetchRequest
	crLock           sync.RWMutex
}

func (s *SinaKlineFetcher) fetchIndexList() (list []*model.IdxLst, e error) {
	var (
		urlt = `http://gu.sina.cn/hq/api/openapi.php/` +
			`StockV2Service.getNodeList?sort=percent&asc=0&page=%d&num=600&node=hs_s&dpc=1`
		cont = true
		px   *util.Proxy
		ua   string
		res  *http.Response
		data []byte
		ok   bool
		mp   map[string]interface{}
		arit []interface{}
	)
	for i := 1; cont; i++ {
		if px, e = util.RandomProxy(conf.Args.DataSource.Sina.DirectProxyWeight); e != nil {
			e = repeat.HintTemporary(e)
			return
		}
		if ua, e = util.PickUserAgent(); e != nil {
			e = repeat.HintTemporary(e)
			return
		}
		hd := map[string]string{
			"User-Agent": ua,
		}
		link := fmt.Sprintf(urlt, i)
		if res, e = util.HTTPGet(link, hd, px); e != nil {
			e = repeat.HintTemporary(e)
			return
		}
		defer res.Body.Close()
		data, e = ioutil.ReadAll(res.Body)
		if e != nil {
			util.UpdateProxyScore(px, false)
			e = repeat.HintTemporary(e)
			log.Errorf("failed to read response body: %+v", e)
			return
		}
		util.UpdateProxyScore(px, true)
		if len(data) == 0 {
			log.Errorf("no data returned from %s", link)
			e = repeat.HintTemporary(e)
			return
		}

		if e = json.Unmarshal(data, &mp); e != nil {
			log.Errorf("failed to unmarshal json. response string: %+v", string(data))
			e = repeat.HintTemporary(e)
			return
		}
		if mp, ok = mp["result"].(map[string]interface{}); !ok {
			e = errors.Errorf("cannot get 'result' from root map: %+v", mp)
			e = repeat.HintTemporary(e)
			log.Error(e)
			return
		}
		if mp, ok = mp["data"].(map[string]interface{}); !ok {
			e = errors.Errorf("cannot get 'data' from 'result' map: %+v", mp)
			e = repeat.HintTemporary(e)
			log.Error(e)
			return
		}

		pgNum, pgCur := 0., 0.
		if pgNum, ok = mp["pageNum"].(float64); !ok {
			e = errors.Errorf("cannot get 'pageNum' from 'data' map: %+v, %+v",
				mp["pageNum"], reflect.TypeOf(mp["pageNum"]))
			e = repeat.HintTemporary(e)
			log.Error(e)
			return
		}
		if pgCur, ok = mp["pageCur"].(float64); !ok {
			e = errors.Errorf("cannot get 'pageCur' from 'data' map: %+v, %+v",
				mp["pageCur"], reflect.TypeOf(mp["pageCur"]))
			e = repeat.HintTemporary(e)
			log.Error(e)
			return
		}
		if pgNum == pgCur {
			cont = false
		}

		if arit, ok = mp["data"].([]interface{}); !ok {
			e = errors.Errorf("cannot get 'data' array from 'data' map: %+v", mp)
			e = repeat.HintTemporary(e)
			log.Error(e)
			return
		}

		var symbol, name string
		var m, ext map[string]interface{}
		for i, itf := range arit {
			if m, ok = itf.(map[string]interface{}); !ok {
				e = errors.Errorf("cannot convert #%d 'data' element to map: %+v", i, arit)
				e = repeat.HintTemporary(e)
				log.Error(e)
				return
			}
			if ext, ok = m["ext"].(map[string]interface{}); !ok {
				e = errors.Errorf("cannot get 'ext' from #%d 'data' element: %+v", i, arit)
				e = repeat.HintTemporary(e)
				log.Error(e)
				return
			}
			if symbol, ok = ext["symbol"].(string); !ok {
				e = errors.Errorf("cannot get 'symbol' from 'data[%d].ext': %+v", i, arit)
				e = repeat.HintTemporary(e)
				log.Error(e)
				return
			}
			if name, ok = ext["name"].(string); !ok {
				e = errors.Errorf("cannot get 'name' from 'data[%d].ext': %+v", i, arit)
				e = repeat.HintTemporary(e)
				log.Error(e)
				return
			}
			list = append(list, &model.IdxLst{
				Src:    string(model.Sina),
				Market: strings.ToUpper(symbol[:2]),
				Code:   symbol[2:],
				Name:   name,
			})
		}
	}
	return
}

func (s *SinaKlineFetcher) hasCompleted(code string, fr FetchRequest) bool {
	s.crLock.Lock()
	defer s.crLock.Unlock()
	if s.completedRequest == nil {
		return false
	}
	if creqs := s.completedRequest[code]; len(creqs) > 0 {
		for _, creq := range creqs {
			if creq == fr {
				return true
			}
		}
	}
	return false
}

func (s *SinaKlineFetcher) markComplete(code string, fr ...FetchRequest) {
	s.crLock.Lock()
	defer s.crLock.Unlock()
	if s.completedRequest == nil {
		s.completedRequest = make(map[string][]FetchRequest)
	}
	s.completedRequest[code] = fr
}

//fetches day, week, and month kline data all in one go
func (s *SinaKlineFetcher) getExtraRequests(frIn []FetchRequest) (frOut []FetchRequest) {
	// derives corresponding cycles for each reinstate type
	rtm := make(map[model.Rtype]map[model.CYTP]FetchRequest)
	var cym map[model.CYTP]FetchRequest
	var fr, cfr FetchRequest
	var ok bool
	for _, fr = range frIn {
		if cym, ok = rtm[fr.Reinstate]; !ok {
			cym = make(map[model.CYTP]FetchRequest)
			rtm[fr.Reinstate] = cym
		}
		cym[fr.Cycle] = fr
	}
	cycles := []model.CYTP{model.DAY, model.WEEK, model.MONTH}
	for _, cym = range rtm {
		var mis []model.CYTP
		for _, c := range cycles {
			if cfr, ok = cym[c]; ok {
				fr = cfr
			} else {
				mis = append(mis, c)
			}
		}
		for _, mc := range mis {
			fr.Cycle = mc
			frOut = append(frOut, fr)
		}
	}
	return
}

func (s *SinaKlineFetcher) cleanup() {
	s.completedRequest = make(map[string][]FetchRequest)
}

func (s *SinaKlineFetcher) chrome(stk *model.Stock, fr FetchRequest) (data interface{}, e error) {
	var px *util.Proxy
	if px, e = util.RandomProxy(conf.Args.DataSource.Sina.DirectProxyWeight); e != nil {
		e = errors.Wrapf(e, "failed to get random proxy")
		e = repeat.HintTemporary(e)
		return
	}

	// create parent context
	ctx, c := context.WithTimeout(context.Background(), time.Duration(conf.Args.DataSource.Sina.Timeout)*time.Second)
	defer c()
	o := chrome.AllocatorOptions(px)
	ctx, c = chromedp.NewExecAllocator(ctx, o...)
	defer c()
	ctx, c = chromedp.NewContext(ctx)
	defer c()

	url := fmt.Sprintf(`https://quotes.sina.cn/hs/company/quotes/view/%s%s`,
		strings.ToLower(stk.Market.String),
		stk.Code)
	chartID := `#hq_chart`
	symbol := strings.ToLower(stk.Market.String) + stk.Code
	switch stk.Market.String {
	case model.MarketUS:
		url = fmt.Sprintf(`https://gu.sina.cn/us/hq/quotes.php?code=%s`, stk.Code)
		symbol = `gb_$` + stk.Code
	case model.MarketHK:
		url = fmt.Sprintf(`https://quotes.sina.cn/hk/company/quotes/view/%s`, stk.Code)
		chartID = `#hChart`
		symbol = `rt_hk` + stk.Code
	}

	if e = chromedp.Run(ctx,
		chromedp.Navigate(url),
		chromedp.WaitReady(chartID)); e != nil {
		util.UpdateProxyScore(px, false)
		e = errors.Wrapf(e, "failed to navigate %s", url)
		e = repeat.HintTemporary(e)
		return
	}
	util.UpdateProxyScore(px, true)

	//execute javascript to get data
	jsParam := func(symbol string) string {
		return fmt.Sprintf(`var tparam = {symbol: "%s", newthour: "09:00", ssl: true}; tparam;`, symbol)
	}
	jsGetData := `
		window.globala = false;
		KKE.api("datas.k.get", tparam, function(a){window.globala=a;});
		window.globala;
	`
	var rt interface{}
	if e = chromedp.Run(ctx,
		chromedp.Evaluate(jsParam(symbol), &rt),
		chromedp.Evaluate(jsGetData, &data),
	); e != nil {
		e = errors.Wrapf(e, "failed to execute javascripts to call js API")
		e = repeat.HintTemporary(e)
		return
	}

	for true {
		if _, ok := data.(bool); !ok {
			break
		}
		if e = chromedp.Run(ctx,
			chromedp.Evaluate(`window.globala;`, &data),
		); e != nil {
			e = errors.Wrapf(e, "failed to execute javascripts to poll data")
			e = repeat.HintTemporary(e)
			return
		}
		time.Sleep(200 * time.Millisecond)
	}

	return
}

func (s *SinaKlineFetcher) parse(code string, fr FetchRequest, data interface{}) (tdmap map[FetchRequest]*model.TradeData, e error) {
	cycles := []model.CYTP{model.DAY, model.WEEK, model.MONTH}
	var (
		ok  bool
		frs []FetchRequest
		m   map[string]interface{}
		a   []interface{}
	)
	if m, ok = data.(map[string]interface{}); !ok {
		e = errors.New("unable to convert payload to map[string]interface{}")
		e = repeat.HintTemporary(e)
		return
	}
	if m, ok = m["data"].(map[string]interface{}); !ok {
		e = errors.New("unable to convert 'data' field to map[string]interface{}")
		e = repeat.HintTemporary(e)
		return
	}

	map2trdat := func(a []interface{}, req FetchRequest) (trdat *model.TradeData, e error) {
		trdat = &model.TradeData{
			Code:          code,
			Source:        req.LocalSource,
			Cycle:         req.Cycle,
			Reinstatement: req.Reinstate,
		}
		var m map[string]interface{}
		var ok bool
		for i, el := range a {
			if m, ok = el.(map[string]interface{}); !ok {
				e = errors.Errorf("unable to convert #%d element to map. found: %+v", i, el)
				return
			}
			b := &model.TradeDataBasic{
				Code: code,
				Klid: i,
			}
			trdat.Base = append(trdat.Base, b)
			if d, ok := m["day"].(string); ok {
				b.Date = strings.ReplaceAll(d, "/", "-")
			} else {
				e = errors.Errorf("unable to convert #%d element 'day' to string. found: %+v", i, el)
				return
			}
			if b.Open, ok = m["open"].(float64); !ok {
				e = errors.Errorf("unable to convert #%d element 'open' to float64. found: %+v", i, el)
				return
			}
			if b.Close, ok = m["close"].(float64); !ok {
				e = errors.Errorf("unable to convert #%d element 'close' to float64. found: %+v", i, el)
				return
			}
			if b.High, ok = m["high"].(float64); !ok {
				e = errors.Errorf("unable to convert #%d element 'high' to float64. found: %+v", i, el)
				return
			}
			if b.Low, ok = m["low"].(float64); !ok {
				e = errors.Errorf("unable to convert #%d element 'low' to float64. found: %+v", i, el)
				return
			}
			if f, ok := m["volume"].(float64); ok {
				b.Volume = sql.NullFloat64{Float64: f, Valid: true}
			} else {
				e = errors.Errorf("unable to convert #%d element 'volume' to float64. found: %+v", i, el)
				return
			}
		}
		return
	}

	tdmap = make(map[FetchRequest]*model.TradeData)
	for _, c := range cycles {
		newFr := FetchRequest{
			RemoteSource: fr.RemoteSource,
			LocalSource:  fr.LocalSource,
			Cycle:        c,
			Reinstate:    fr.Reinstate,
		}
		frs = append(frs, newFr)
		var field string
		switch c {
		case model.DAY:
			field = "day"
		case model.WEEK:
			field = "week"
		case model.MONTH:
			field = "month"
		}
		if a, ok = m[field].([]interface{}); !ok {
			e = errors.Errorf("unable to convert '%s' field to []interface{}", field)
			e = repeat.HintTemporary(e)
			return
		}
		if tdmap[newFr], e = map2trdat(a, newFr); e != nil {
			e = errors.Errorf("error during '%s' field element conversion to trade data", field)
			e = repeat.HintTemporary(e)
			return
		}
	}

	s.markComplete(code, frs...)
	return
}

//Handle forward/backward reinstate scenarios.
//Load non-reinstate data from local database.
//The process will fail if if non-reinstate kline has not yet been fed to database.
//Otherwise, it loads reinstate factors from remote,
//then calculates reinstate kline based on non-reinstate kline and reinstatement factors.
func (s *SinaKlineFetcher) reinstate(stk *model.Stock, fr FetchRequest) (
	tdmap map[FetchRequest]*model.TradeData, suc, retry bool) {

	code := stk.Code

	//load non-reinstate data from db
	trdat := GetTrDataDB(
		code,
		TrDataQry{
			LocalSource: fr.LocalSource,
			Cycle:       fr.Cycle,
			Reinstate:   model.None,
			Basic:       true,
		},
		0,
		true)
	if trdat.Empty() {
		log.Warnf("%s no non-reinstate data, skipping", code)
		return tdmap, true, false
	}

	var px *util.Proxy
	var e error
	if px, e = util.RandomProxy(conf.Args.DataSource.Sina.DirectProxyWeight); e != nil {
		log.Errorf("%s failed to get random proxy: %+v", code, e)
		return tdmap, false, true
	}

	var ua string
	if ua, e = util.PickUserAgent(); e != nil {
		log.Errorf("%s failed to get user agent: %+v", code, e)
		return tdmap, false, true
	}
	hd := map[string]string{
		"User-Agent": ua,
	}
	symbol := strings.ToLower(stk.Market.String) + stk.Code
	rtype := "hfq"
	if model.Forward == fr.Reinstate {
		rtype = "qfq"
	}
	url := fmt.Sprintf(`https://finance.sina.com.cn/realstock/company/%s/%s.js`, symbol, rtype)

	var res *http.Response
	if res, e = util.HTTPGet(url, hd, px); e != nil {
		log.Errorf("%s failed to get http response from %s: %+v", code, url, e)
		return tdmap, false, true
	}
	defer res.Body.Close()
	data, e := ioutil.ReadAll(res.Body)
	if e != nil {
		log.Errorf("%s failed to read http response body from %s: %+v", code, url, e)
		util.UpdateProxyScore(px, false)
		return tdmap, false, true
	}
	util.UpdateProxyScore(px, true)
	if len(data) == 0 {
		log.Errorf("%s no data returned from %s", code, url)
		return tdmap, false, true
	}

	retString := string(data)
	pattern := `.*(\{[^\/]*\})`
	r := regexp.MustCompile(pattern).FindStringSubmatch(retString)
	var jsonStr string
	if len(r) > 0 {
		jsonStr = r[len(r)-1]
	} else {
		log.Errorf("%s failed to extract json string from %s response body: %s", code, url, retString)
		return tdmap, false, true
	}

	rs := &struct {
		Total int
		Data  []struct {
			D string  //date 2016-06-24
			F float64 //factor
		}
	}{}
	if e = json.Unmarshal([]byte(jsonStr), rs); e != nil {
		log.Errorf("%s failed to parse json string from %s: %s", code, url, jsonStr)
		return tdmap, false, true
	}
	if rs.Total != len(rs.Data) {
		log.Errorf("%s total[%d] != data len[%d] from %s: %s", code, rs.Total, len(rs.Data), url, jsonStr)
		return tdmap, false, true
	} else if rs.Total == 0 {
		log.Infof("%s no reinstate data for %v", code, fr.Cycle)
		return tdmap, true, false
	}
	var dates []string
	fmap := make(map[string]float64)
	for _, el := range rs.Data {
		dates = append(dates, el.D)
		fmap[el.D] = el.F
	}

	//sort dates, calculate reinstated trade data and return.
	sort.Sort(sort.Reverse(sort.StringSlice(dates)))

	i := 0
	pop := func() (d string, f float64) {
		if i < len(dates) {
			d = dates[i]
			f = fmap[d]
			i++
		}
		return
	}

	backward := func() {
		d, f := pop()
		for _, b := range trdat.Base {
			for len(d) > 0 && b.Date < d {
				d, f = pop()
			}
			if len(d) > 0 {
				b.Open *= f
				b.High *= f
				b.Low *= f
				b.Close *= f
			}
			b.Varate.Valid = false
			b.VarateHigh.Valid = false
			b.VarateLow.Valid = false
			b.VarateOpen.Valid = false
		}
	}

	forward := func() {
		d, f := pop()
		for _, b := range trdat.Base {
			for len(d) > 0 && b.Date < d {
				d, f = pop()
			}
			if len(d) > 0 {
				b.Open /= f
				b.High /= f
				b.Low /= f
				b.Close /= f
			}
			b.Varate.Valid = false
			b.VarateHigh.Valid = false
			b.VarateLow.Valid = false
			b.VarateOpen.Valid = false
		}
	}

	switch fr.Reinstate {
	case model.Backward:
		backward()
	case model.Forward:
		forward()
	}
	trdat.Source = fr.RemoteSource
	trdat.Reinstatement = fr.Reinstate
	tdmap[fr] = trdat

	return tdmap, true, false
}

//fetchKline from specific data source for the given stock.
func (s *SinaKlineFetcher) fetchKline(stk *model.Stock, fr FetchRequest, incr bool) (
	tdmap map[FetchRequest]*model.TradeData, suc, retry bool) {
	//if the fetch request has been completed previously, return immediately
	if s.hasCompleted(stk.Code, fr) {
		return tdmap, true, false
	}

	switch fr.Reinstate {
	case model.Backward, model.Forward:
		return s.reinstate(stk, fr)
	}

	var data interface{}
	var e error
	if data, e = s.chrome(stk, fr); e != nil {
		log.Error(e)
		if repeat.IsTemporary(e) {
			retry = true
		}
		return
	}

	// extract kline data to tdmap, and all types of Cycle will be populated automatically
	if tdmap, e = s.parse(stk.Code, fr, data); e != nil {
		log.Error(e)
		if repeat.IsTemporary(e) {
			retry = true
		}
		return
	}

	suc = true

	return
}
