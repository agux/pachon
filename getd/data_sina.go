package getd

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/agux/pachon/conf"
	"github.com/agux/pachon/model"
	"github.com/agux/pachon/util"
	"github.com/agux/pachon/util/chrome"
	"github.com/chromedp/chromedp"
)

//SinaKlineFetcher fetches kline from sina
type SinaKlineFetcher struct{}

//fetchKline from specific data source for the given stock.
func (s *SinaKlineFetcher) fetchKline(stk *model.Stock, fr FetchRequest, incr bool) (
	tdmap map[FetchRequest]*model.TradeData, suc, retry bool) {

	px, e := util.RandomProxy(conf.Args.DataSource.Sina.DirectProxyWeight)
	if e != nil {
		log.Errorf("failed to get random proxy: %+v", e)
		return tdmap, false, true
	}

	// create parent context
	ctx, c := context.WithTimeout(context.Background(), time.Duration(conf.Args.DataSource.Sina.Timeout)*time.Second)
	defer c()
	o := chrome.AllocatorOptions(px)
	ctx, c = chromedp.NewExecAllocator(ctx, o...)
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
		chromedp.WaitVisible(chartID)); e != nil {
		util.UpdateProxyScore(px, false)
		//TODO maybe it will not timeout when using a bad proxy, and shows chrome error page instead
		log.Errorf("failed to navigate %s: %+v", url, e)
		return tdmap, false, true
	}
	util.UpdateProxyScore(px, true)

	//execute javascript to get data
	rt := false
	jsParam := func(symbol string) string {
		return fmt.Sprintf(`var tparam = {symbol: "%s", newthour: "09:00", ssl: true};return true;`, symbol)
	}
	jsGetData := `
	window.globala = null;
	KKE.api("datas.k.get", tparam, function(a){window.globala=a;});
	while (window.globala == null) {
		await new Promise(r => setTimeout(r, 200));
	}
	window.globala;
	`
	var data interface{}
	if e = chromedp.Run(ctx,
		chromedp.Evaluate(jsParam(symbol), &rt),
		chromedp.Evaluate(jsGetData, &data),
	); e != nil {
		log.Errorf("failed to execute javascripts: %+v", e)
		return tdmap, false, true
	}

	log.Debugf("%+v", data)

	//TODO extract kline data to tdmap, and cater for Cycle and Reinstate?

	return
}
