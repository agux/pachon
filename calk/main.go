//
// Calculates week and month kline based on daily kline data.
//
package main

import (
	"flag"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/carusyte/stock/db"
	"github.com/carusyte/stock/model"
	"github.com/carusyte/stock/util"
	"github.com/gchaincl/dotsql"
	"github.com/sirupsen/logrus"
	"gopkg.in/gorp.v2"
)

const APP_VERSION = "0.1"

// The flag package provides a default help printer via -h switch
var versionFlag *bool = flag.Bool("v", false, "Print the version number.")
var pall *bool = flag.Bool("pall", false, "Purge all stale calculated data before processing")
var dot *dotsql.DotSql
var dbmap *gorp.DbMap

func init() {
	// logFile, err := os.OpenFile("calk.log", os.O_CREATE|os.O_RDWR, 0666)
	// util.CheckErr(err, "failed to open log file")
	// mw := io.MultiWriter(os.Stdout, logFile)
	// logrus.SetOutput(mw)
	dbmap = db.Get(true, *pall)
}

func main() {
	start := time.Now()
	defer func() {
		ss := start.Format("2006-01-02 15:04:05")
		end := time.Now().Format("2006-01-02 15:04:05")
		dur := time.Since(start).Seconds()
		dbmap.Exec("insert into stats (code, start, end, dur) values (?, ?, ?, ?)"+
			" on duplicate key update start=?, end=?, dur=?", "CALK_TOTAL", ss, end, dur, ss, end, dur)
		logrus.Printf("Complete. Time Elapsed: %f sec", time.Since(start).Seconds())
	}()

	flag.Parse() // Scan the arguments list

	if *versionFlag {
		fmt.Println("Version:", APP_VERSION)
		return
	}

	var err error
	// initialize the DbMap
	dot, err = dotsql.LoadFromFile("/Users/jx/ProgramData/go/src/github.com/carusyte/stock/ask/sql.txt")
	util.CheckErr(err, "failed to init dotsql")

	cal()
}

func getStocks() []model.Stock {
	var stocks []model.Stock
	_, err := dbmap.Select(&stocks, "select * from basics order by code")
	checkErr(err, "Select failed")
	logrus.Printf("number of stock: %d\n", len(stocks))
	return stocks
}

func checkErr(err error, msg string) {
	if err != nil {
		logrus.Fatalf("%s\n %+v\n", msg, err)
	}
}

func cal() {
	purgeOld()
	stocks := getStocks()

	var wg sync.WaitGroup
	wg.Add(len(stocks))
	for _, s := range stocks {
		go caljob(&wg, s)
		//time.Sleep(1 * time.Second)
	}
	wg.Wait()
}

func supplementKlid(code string) {
	panic("this operation is not supported anymore.")

	supKlid, err := dot.Raw("supKlid")
	supKlid = strings.Replace(supKlid, "?", fmt.Sprintf("'%s'", code), 1)
	checkErr(err, "failed to get supKlid query")
	mysql := db.Get(false, false)
	// defer func() {
	// 	e := mysql.Release()
	// 	util.CheckErrNop(e, code+" failed to release mysql connection")
	// }()
	res, err := mysql.Query(supKlid)
	defer func() {
		res.Close()
	}()
	checkErr(err, code+" failed to supplement klid")
}

func caljob(wg *sync.WaitGroup, s model.Stock) {
	start := time.Now()
	defer func() {
		wg.Done()
		ss := start.Format("2006-01-02 15:04:05")
		end := time.Now().Format("2006-01-02 15:04:05")
		dur := time.Since(start).Seconds()
		dbmap.Exec("insert into stats (code, start, end, dur) values (?, ?, ?, ?)"+
			" on duplicate key update start=?, end=?, dur=?", s.Code, ss, end, dur, ss, end, dur)
	}()
	// supplementKlid(s.Code)
	klines, mxw, mxm := getKlines(s)
	q := make([]*model.Quote, len(klines))
	var qw []*model.Quote
	var qm []*model.Quote
	var klinesw []*model.KlineW
	var klinesm []*model.KlineM

	klw := newKlinew()
	klm := newKlinem()
	var lastWeekDay, lastMonth int = 7, 0
	var klid_w, klid_m int = 0, 0
	if mxw != nil {
		klid_w = mxw.Klid + 1
	}
	if mxm != nil {
		klid_m = mxm.Klid + 1
	}
	for i, k := range klines {
		q[i] = &k.Quote
		t, err := time.Parse("2006-01-02T00:00:00-07:00", k.Date)
		checkErr(err, "failed to parse date from kline_d "+k.Date)
		tw, err := time.Parse("2006-01-02", klw.Date)
		checkErr(err, "failed to parse date in KlineW "+klw.Date)

		if (int(t.Weekday()) <= lastWeekDay || t.Add(-1*time.Duration(7)*time.Hour*24).After(tw)) &&
			((mxw != nil && k.Date[:10] > mxw.Date) || mxw == nil) {

			klw = newKlinew()
			klinesw = append(klinesw, klw)
			klw.Code = k.Code

			klw.Klid = klid_w
			klid_w++

			klw.Open = k.Open
			klw.Low = k.Low
			lastWeekDay = int(t.Weekday())

			qw = append(qw, &klw.Quote)
		}

		if int(t.Month()) != lastMonth && ((mxm != nil && k.Date[:10] > mxm.Date) || mxm == nil) {
			klm = newKlinem()
			klinesm = append(klinesm, klm)
			klm.Code = k.Code

			klm.Klid = klid_m
			klid_m++

			klm.Open = k.Open
			klm.Low = k.Low
			lastMonth = int(t.Month())

			qm = append(qm, &klm.Quote)
		}

		klw.Date, klm.Date = k.Date[:10], k.Date[:10]

		klw.Amount.Float64 += k.Amount.Float64
		klm.Amount.Float64 += k.Amount.Float64
		klw.Volume.Float64 += k.Volume.Float64
		klm.Volume.Float64 += k.Volume.Float64
		if klw.High < k.High {
			klw.High = k.High
		}
		if klm.High < k.High {
			klm.High = k.High
		}
		if klw.Low > k.Low {
			klw.Low = k.Low
		}
		if klm.Low > k.Low {
			klm.Low = k.Low
		}
		klw.Close, klm.Close = k.Close, k.Close
	}

	//TODO refactor due to model structure update
	// mxid, mxiw, mxim := getMaxIdcDates(s.Code)

	// kdj := subidc(indc.DeftKDJ(q), mxid)
	// kdjw := subidcw(indc.DeftKDJ_W(qw), mxiw)
	// kdjm := subidcm(indc.DeftKDJ_M(qm), mxim)

	// batchInsert(s.Code, klinesw, klinesm, kdj, kdjw, kdjm)

	logrus.Printf("%s complete in %f s: dy: %d, wk: %d, mo: %d\n", s.Code, time.Since(start).Seconds(),
		len(klines), len(klinesw), len(klinesm))
}

func getMaxIdcDates(code string) (mxid, mxiw, mxim int) {
	mxid, mxiw, mxim = -1, -1, -1
	mxidn, err := dbmap.SelectNullInt("select max(klid) from indicator_d where code=?", code)
	checkErr(err, "failed to query max klid in indicator_d for "+code)
	mxiwn, err := dbmap.SelectNullInt("select max(klid) from indicator_w where code=?", code)
	checkErr(err, "failed to query max klid in indicator_w for "+code)
	mximn, err := dbmap.SelectNullInt("select max(klid) from indicator_m where code=?", code)
	checkErr(err, "failed to query max klid in indicator_m for "+code)
	if mxidn.Valid {
		mxid = int(mxidn.Int64)
	}
	if mxiwn.Valid {
		mxiw = int(mxiwn.Int64)
	}
	if mximn.Valid {
		mxim = int(mximn.Int64)
	}
	return
}

func subidc(q []*model.Indicator, klid int) (ret []*model.Indicator) {
	ret = make([]*model.Indicator, 0)
	for i, qe := range q {
		if qe.Klid > klid {
			ret = q[i:]
			return
		}
	}
	return
}

func subidcw(q []*model.IndicatorW, klid int) (ret []*model.IndicatorW) {
	ret = make([]*model.IndicatorW, 0)
	for i, qe := range q {
		if qe.Klid > klid {
			ret = q[i:]
			return
		}
	}
	return
}

func subidcm(q []*model.IndicatorM, klid int) (ret []*model.IndicatorM) {
	ret = make([]*model.IndicatorM, 0)
	for i, qe := range q {
		if qe.Klid > klid {
			ret = q[i:]
			return
		}
	}
	return
}

// Fetch all klines, latest kline_w and kline_m. Nil will be return if there's no such record.
func getKlines(s model.Stock) ([]*model.Kline, *model.KlineW, *model.KlineM) {
	mxw, mxm := getMaxDates(s.Code)
	var klines []*model.Kline
	_, err := dbmap.Select(&klines, "select * from kline_d where code = ? order by date", s.Code)
	checkErr(err, "Failed to query kline_d for "+s.Code)
	return klines, mxw, mxm
}

func getMaxDates(stock string) (daw *model.KlineW, dam *model.KlineM) {
	dbmap.SelectOne(&daw, "select * from kline_w where code = ? order by date desc limit 1", stock)
	dbmap.SelectOne(&dam, "select * from kline_m where code = ? order by date desc limit 1", stock)
	return
}

func purgeOld() {
	lastNTD, err := dot.Raw("lastNTD")
	checkErr(err, "failed to fetch lastNTD from sql file")
	lst7, err := dbmap.SelectStr(lastNTD, 7)
	checkErr(err, "failed to query last 7 trade date")
	_, err = dbmap.Exec("delete from kline_w where date >= ?", lst7)
	checkErr(err, "failed to purge kline_w")
	_, err = dbmap.Exec("delete from indicator_d where date >= ?", lst7)
	checkErr(err, "failed to purge indicator_d")
	_, err = dbmap.Exec("delete from indicator_w where date >= ?", lst7)
	checkErr(err, "failed to purge indicator_w")

	lstm, err := dbmap.SelectStr(lastNTD, 32)
	checkErr(err, "failed to query last 32 trade date")
	_, err = dbmap.Exec("delete from kline_m where date >= ?", lstm)
	checkErr(err, "failed to purge kline_m")
	_, err = dbmap.Exec("delete from indicator_m where date >= ?", lstm)
	checkErr(err, "failed to purge indicator_m")
}

func newKlinew() *model.KlineW {
	klw := &model.KlineW{}
	klw.Klid = -1
	klw.Date = "1900-01-01"
	return klw
}

func newKlinem() *model.KlineM {
	klm := &model.KlineM{}
	klm.Klid = -1
	klm.Date = "1900-01-01"
	return klm
}

func batchInsert(code string, klinesw []*model.KlineW, klinesm []*model.KlineM,
	indc []*model.Indicator, indcw []*model.IndicatorW, indcm []*model.IndicatorM) {
	// cklw := binsKlw(klinesw)
	// cklm := binsKlm(klinesm)
	// cindc := getd.binsIndc(kdjw, "indicator_d")
	// cindw := getd.binsIndc(kdjw, "indicator_w")
	// cindm := getd.binsIndc(kdjw, "indicator_m")
	// logrus.Printf("%s saved to database, wk[%d], mo[%d], ind[%d], indw[%d], indm[%d]", code, cklw, cklm,
	// 	cindc, cindw, cindm)
}

func binsKlm(klinesm []*model.KlineM) (c int) {
	if len(klinesm) > 0 {
		valueStrings := make([]string, 0, len(klinesm))
		valueArgs := make([]interface{}, 0, len(klinesm)*9)
		var code string
		for _, klm := range klinesm {
			valueStrings = append(valueStrings, "(?, ?, ?, ?, ?, ?, ?, ?, ?)")
			valueArgs = append(valueArgs, klm.Code)
			valueArgs = append(valueArgs, klm.Date)
			valueArgs = append(valueArgs, klm.Klid)
			valueArgs = append(valueArgs, klm.Open)
			valueArgs = append(valueArgs, klm.High)
			valueArgs = append(valueArgs, klm.Close)
			valueArgs = append(valueArgs, klm.Low)
			valueArgs = append(valueArgs, klm.Volume)
			valueArgs = append(valueArgs, klm.Amount)
			code = klm.Code
		}
		stmt := fmt.Sprintf("INSERT INTO kline_m (code,date,klid,open,high,close,low,"+
			"volume,amount) VALUES %s", strings.Join(valueStrings, ","))
		_, err := dbmap.Exec(stmt, valueArgs...)
		if !util.CheckErr(err, code+" failed to bulk insert kline_m") {
			c = len(klinesm)
		}
	}
	return
}

func binsKlw(klws []*model.KlineW) (c int) {
	if len(klws) > 0 {
		valueStrings := make([]string, 0, len(klws))
		valueArgs := make([]interface{}, 0, len(klws)*9)
		var code string
		for _, klw := range klws {
			valueStrings = append(valueStrings, "(?, ?, ?, ?, ?, ?, ?, ?, ?)")
			valueArgs = append(valueArgs, klw.Code)
			valueArgs = append(valueArgs, klw.Date)
			valueArgs = append(valueArgs, klw.Klid)
			valueArgs = append(valueArgs, klw.Open)
			valueArgs = append(valueArgs, klw.High)
			valueArgs = append(valueArgs, klw.Close)
			valueArgs = append(valueArgs, klw.Low)
			valueArgs = append(valueArgs, klw.Volume)
			valueArgs = append(valueArgs, klw.Amount)
			code = klw.Code
		}
		stmt := fmt.Sprintf("INSERT INTO kline_w (code,date,klid,open,high,close,low,"+
			"volume,amount) VALUES %s", strings.Join(valueStrings, ","))
		_, err := dbmap.Exec(stmt, valueArgs...)
		if !util.CheckErr(err, code+" failed to bulk insert kline_w") {
			c = len(klws)
		}
	}
	return
}
