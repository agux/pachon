package score

import (
	"github.com/carusyte/stock/model"
	"math"
	"github.com/carusyte/stock/getd"
	"fmt"
	"github.com/carusyte/stock/util"
	"time"
	"reflect"
	"errors"
	logr "github.com/sirupsen/logrus"
	"github.com/montanaflynn/stats"
	"log"
	"sync"
	"runtime"
	"strings"
	"sort"
)

// Medium to Long term model.
// Search for stocks with best KDJ form which closely matches the historical ones indicating the buy opportunity.
type KdjV struct {
	Code  string
	Name  string
	Dod   float64 // Degree of Distinction
	Stats string
	Len   string
	CCMO  string
	CCWK  string
	CCDY  string
}

const (
	SCORE_KDJV_MONTH float64 = 40.0
	SCORE_KDJV_WEEK          = 30.0
	SCORE_KDJV_DAY           = 30.0
)

func (k *KdjV) GetFieldStr(name string) string {
	switch name {
	case "DOD":
		return fmt.Sprintf("%.2f", k.Dod)
	case "STATS":
		return k.Stats
	case "LEN":
		return k.Len
	case "KDJ_DY":
		return k.CCDY
	case "KDJ_WK":
		return k.CCWK
	case "KDJ_MO":
		return k.CCMO
	default:
		r := reflect.ValueOf(k)
		f := reflect.Indirect(r).FieldByName(name)
		if !f.IsValid() {
			panic(errors.New("undefined field for KDJV: " + name))
		}
		return fmt.Sprintf("%+v", f.Interface())
	}
}

func (k *KdjV) Get(stock []string, limit int, ranked bool) (r *Result) {
	r = &Result{}
	r.PfIds = append(r.PfIds, k.Id())
	var stks []*model.Stock
	if stock == nil || len(stock) == 0 {
		stks = getd.StocksDb()
	} else {
		stks = getd.StocksDbByCode(stock...)
	}
	//TODO need to speed up the evaluation process, now cost nearly 13 mins all stock
	// use goroutines to see if performance can be better
	cpu := runtime.NumCPU()
	logr.Debugf("Number of CPU: %d", cpu)
	var wg sync.WaitGroup
	chitm := make(chan *Item, cpu)
	for _, s := range stks {
		wg.Add(1)
		item := new(Item)
		r.AddItem(item)
		item.Code = s.Code
		item.Name = s.Name
		chitm <- item
		go scoreKdjAsyn(item, &wg, chitm)
	}
	close(chitm)
	wg.Wait()
	r.SetFields(k.Id(), k.Fields()...)
	if ranked {
		r.Sort()
	}
	r.Shrink(limit)
	return
}

func (k *KdjV) RenewStats(stock []string) {
	var stks []*model.Stock
	kps := make([]*model.KDJVStat, 0, 16)
	if stock == nil || len(stock) == 0 {
		stks = getd.StocksDb()
	} else {
		stks = getd.StocksDbByCode(stock...)
	}
	cpu := runtime.NumCPU()
	logr.Debugf("Number of CPU: %d", cpu)
	var wg sync.WaitGroup
	chstk := make(chan *model.Stock, cpu)
	chkps := make(chan *model.KDJVStat, JOB_CAPACITY)
	wgr := new(sync.WaitGroup)
	wgr.Add(1)
	go func() {
		defer wgr.Done()
		for k := range chkps {
			kps = append(kps, k)
		}
	}()
	for _, s := range stks {
		wg.Add(1)
		chstk <- s
		go renewKdjStats(s, &wg, chstk, chkps)
	}
	close(chstk)
	wg.Wait()
	close(chkps)
	wgr.Wait()
	saveKps(kps)
}

func saveKps(kps []*model.KDJVStat) {
	if len(kps) > 0 {
		valueStrings := make([]string, 0, len(kps))
		valueArgs := make([]interface{}, 0, len(kps)*17)
		for _, k := range kps {
			valueStrings = append(valueStrings, "(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
			valueArgs = append(valueArgs, k.Code)
			valueArgs = append(valueArgs, k.Dod)
			valueArgs = append(valueArgs, k.Sl)
			valueArgs = append(valueArgs, k.Sh)
			valueArgs = append(valueArgs, k.Bl)
			valueArgs = append(valueArgs, k.Bh)
			valueArgs = append(valueArgs, k.Ol)
			valueArgs = append(valueArgs, k.Oh)
			valueArgs = append(valueArgs, k.Sor)
			valueArgs = append(valueArgs, k.Bor)
			valueArgs = append(valueArgs, k.Scnt)
			valueArgs = append(valueArgs, k.Bcnt)
			valueArgs = append(valueArgs, k.Smean)
			valueArgs = append(valueArgs, k.Bmean)
			valueArgs = append(valueArgs, k.Ddate)
			valueArgs = append(valueArgs, k.Udate)
			valueArgs = append(valueArgs, k.Utime)
		}
		stmt := fmt.Sprintf("INSERT INTO kdjv_stats (code,dod,sl,sh,bl,bh,ol,oh,sor,bor,scnt,bcnt,smean,bmean,"+
			"ddate,udate,utime) VALUES %s on duplicate key update "+
			"dod=values(dod),sl=values(sl),"+
			"sh=values(sh),bl=values(bl),bh=values(bh),ol=values(oh),"+
			"sor=values(bor),scnt=values(bcnt),smean=values(bmean),ddate=values(ddate),"+
			"udate=values(udate),utime=values(utime)",
			strings.Join(valueStrings, ","))
		_, err := dbmap.Exec(stmt, valueArgs...)
		util.CheckErr(err, "failed to bulk update kdjv_stats")
		log.Printf("%d kdjv_stats updated", len(kps))
	}
}

func renewKdjStats(s *model.Stock, wg *sync.WaitGroup, chstk chan *model.Stock, chkps chan *model.KDJVStat) {
	defer func() {
		wg.Done()
		<-chstk
	}()
	//TODO collect kdjv stats
	var e error
	expvr := 5.0
	mxrt := 2.0
	mxhold := 3
	retro := 350
	kps := new(model.KDJVStat)
	klhist := getd.GetKlineDb(s.Code, model.KLINE_DAY, retro, false)
	if len(klhist) < retro {
		log.Printf("%s insufficient data to collect kdjv stats: %d", s.Code, len(klhist))
		return
	}
	kps.Code = s.Code
	kps.Ddate = klhist[len(klhist)-1].Date
	kps.Udate, kps.Utime = util.TimeStr()
	buys := getKdjBuyStats(s.Code, klhist, expvr, mxrt, mxhold)
	sells := getKdjSellStats(s.Code, klhist, expvr, mxrt, mxhold)
	sort.Float64s(buys)
	sort.Float64s(sells)
	kps.Bl = buys[0]
	kps.Sl = sells[0]
	kps.Bh = buys[len(buys)-1]
	kps.Sh = sells[len(sells)-1]
	kps.Bcnt = len(buys)
	kps.Scnt = len(sells)
	kps.Bmean, e = stats.Mean(buys)
	util.CheckErr(e, s.Code+" failed to calculate mean for buy scores")
	kps.Smean, e = stats.Mean(sells)
	util.CheckErr(e, s.Code+" failed to calculate mean for sell scores")
	if kps.Sh >= kps.Bl {
		soc, boc := 0, 0
		for _, s := range buys {
			if s <= kps.Sh {
				boc++
			} else {
				break
			}
		}
		for i := len(sells) - 1; i >= 0; i-- {
			s := sells[i]
			if s >= kps.Bl {
				soc++
			} else {
				break
			}
		}
		kps.Bor = float64(boc) / float64(kps.Bcnt)
		kps.Sor = float64(soc) / float64(kps.Scnt)
	}
	//TODO assess degree of distinction
	//kps.Dod = ?
	chkps <- kps
}

// collect kdjv buy stats
func getKdjBuyStats(code string, klhist []*model.Quote, expvr, mxrt float64, mxhold int) (s []float64) {
	for i := 50; i < len(klhist)-1; i++ {
		kl := klhist[i]
		sc := kl.Close
		if sc >= klhist[i+1].Close {
			continue
		}
		hc := math.Inf(-1)
		tspan := 0
		pc := klhist[i-1].Close
		for w, j := 0, 0; i+j < len(klhist); j++ {
			nc := klhist[i+j].Close
			if nc > hc {
				hc = nc
				tspan = j
			}
			if pc >= nc {
				rt := (hc - nc) / math.Abs(hc) * 100
				if rt >= mxrt || w > mxhold {
					break
				}
				if j > 0 {
					w++
				}
			} else {
				w = 0
			}
			pc = nc
		}
		if sc == 0 {
			sc = 0.01
			hc += 0.01
		}
		mark := (hc - sc) / math.Abs(sc) * 100
		if mark >= expvr {
			histmo := getd.ToLstJDCross(getd.GetKdjHist(code, model.INDICATOR_MONTH, 100, kl.Date))
			histwk := getd.ToLstJDCross(getd.GetKdjHist(code, model.INDICATOR_WEEK, 100, kl.Date))
			histdy := getd.ToLstJDCross(getd.GetKdjHist(code, model.INDICATOR_DAY, 100, kl.Date))
			s = append(s, wgtKdjScore(nil, histmo, histwk, histdy))
		}
		i += tspan
	}
	return s
}

// collect kdjv sell stats
func getKdjSellStats(code string, klhist []*model.Quote, expvr, mxrt float64, mxhold int) (s []float64) {
	for i := 50; i < len(klhist)-1; i++ {
		kl := klhist[i]
		sc := kl.Close
		if sc <= klhist[i+1].Close {
			continue
		}
		lc := math.Inf(0)
		tspan := 0
		pc := klhist[i-1].Close
		for w, j := 0, 0; i+j < len(klhist); j++ {
			nc := klhist[i+j].Close
			if nc < lc {
				lc = nc
				tspan = j
			}
			if pc <= nc {
				rt := (nc - lc) / math.Abs(lc) * 100
				if rt >= mxrt || w > mxhold {
					break
				}
				if j > 0 {
					w++
				}
			} else {
				w = 0
			}
			pc = nc
		}
		if sc == 0 {
			sc = -0.01
			lc -= 0.01
		}
		mark := (lc - sc) / math.Abs(sc) * 100
		if mark <= -expvr {
			histmo := getd.ToLstJDCross(getd.GetKdjHist(code, model.INDICATOR_MONTH, 100, kl.Date))
			histwk := getd.ToLstJDCross(getd.GetKdjHist(code, model.INDICATOR_WEEK, 100, kl.Date))
			histdy := getd.ToLstJDCross(getd.GetKdjHist(code, model.INDICATOR_DAY, 100, kl.Date))
			s = append(s, wgtKdjScore(nil, histmo, histwk, histdy))
		}
		i += tspan
	}
	return s
}

func scoreKdjAsyn(item *Item, wg *sync.WaitGroup, chitm chan *Item) {
	defer func() {
		wg.Done()
		<-chitm
	}()
	start := time.Now()
	kdjv := new(KdjV)
	kdjv.Code = item.Code
	kdjv.Name = item.Name
	item.Profiles = make(map[string]*Profile)
	ip := new(Profile)
	item.Profiles[kdjv.Id()] = ip
	ip.FieldHolder = kdjv

	histmo := getd.ToLstJDCross(getd.GetKdjHist(item.Code, model.INDICATOR_MONTH, 100, ""))
	histwk := getd.ToLstJDCross(getd.GetKdjHist(item.Code, model.INDICATOR_WEEK, 100, ""))
	histdy := getd.ToLstJDCross(getd.GetKdjHist(item.Code, model.INDICATOR_DAY, 100, ""))
	kdjv.Len = fmt.Sprintf("%d/%d/%d", len(histdy), len(histwk), len(histmo))

	//warn if...

	ip.Score = wgtKdjScore(kdjv, histmo, histwk, histdy)
	item.Score += ip.Score

	logr.Debugf("%s %s kdjv: %.2f, time: %.2f", item.Code, item.Name, ip.Score, time.Since(start).Seconds())
}

func wgtKdjScore(kdjv *KdjV, histmo, histwk, histdy []*model.Indicator) (s float64) {
	s += scoreKdj(kdjv, model.MONTH, histmo) * SCORE_KDJV_MONTH
	s += scoreKdj(kdjv, model.WEEK, histwk) * SCORE_KDJV_WEEK
	s += scoreKdj(kdjv, model.DAY, histdy) * SCORE_KDJV_DAY
	s /= SCORE_KDJV_MONTH + SCORE_KDJV_WEEK + SCORE_KDJV_DAY
	s = math.Min(100, math.Max(0, s))
	return
}

//Score by assessing the historical data against feature data.
func scoreKdj(v *KdjV, cytp model.CYTP, kdjhist []*model.Indicator) (s float64) {
	var val string
	byhist, slhist := getKDJfdViews(cytp, len(kdjhist))
	hdr, pdr, mpd, bdi := calcKdjDI(kdjhist, byhist)
	val = fmt.Sprintf("%.2f/%.2f/%.2f/%.2f\n", hdr, pdr, mpd, bdi)
	hdr, pdr, mpd, sdi := calcKdjDI(kdjhist, slhist)
	val += fmt.Sprintf("%.2f/%.2f/%.2f/%.2f\n", hdr, pdr, mpd, sdi)
	dirat := .0
	s = .0
	if sdi == 0 {
		dirat = bdi
	} else {
		dirat = (bdi - sdi) / math.Abs(sdi)
	}
	if dirat > 0 && dirat < 0.995 {
		s = 30 * (0.0015 + 3.3609*dirat - 4.3302*math.Pow(dirat, 2.) + 2.5115*math.Pow(dirat, 3.) -
			0.5449*math.Pow(dirat, 4.))
	} else if dirat >= 0.995 {
		s = 30
	}
	if bdi > 0.201 && bdi < 0.81 {
		s += 70 * (0.0283 - 1.8257*bdi + 10.4231*math.Pow(bdi, 2.) - 10.8682*math.Pow(bdi, 3.) + 3.2234*math.Pow(bdi, 4.))
	} else if bdi >= 0.81 {
		s += 70
	}
	if v != nil {
		switch cytp {
		case model.DAY:
			v.CCDY = val
		case model.WEEK:
			v.CCWK = val
		case model.MONTH:
			v.CCMO = val
		default:
			log.Panicf("unsupported cytp: %s", cytp)
		}
	}
	return
}

func getKDJfdViews(cytp model.CYTP, len int) (buy, sell []*model.KDJfdView) {
	buy = make([]*model.KDJfdView, 0, 1024)
	sell = make([]*model.KDJfdView, 0, 1024)
	for i := -2; i < 3; i++ {
		n := len + i
		if n >= 2 {
			buy = append(buy, getd.GetKdjFeatDat(cytp, true, n)...)
			sell = append(sell, getd.GetKdjFeatDat(cytp, false, n)...)
		}
	}
	return
}

// Evaluates KDJ DEVIA indicator, returns the following result:
// Ratio of high DEVIA, ratio of positive DEVIA, mean of positive DEVIA, and DEVIA indicator, ranging from 0 to 1
func calcKdjDI(hist []*model.Indicator, fdvs []*model.KDJfdView) (hdr, pdr, mpd, di float64) {
	if len(hist) == 0 {
		return 0, 0, 0, 0
	}
	hk := make([]float64, len(hist))
	hd := make([]float64, len(hist))
	hj := make([]float64, len(hist))
	code := hist[0].Code
	for i, h := range hist {
		hk[i] = h.KDJ_K
		hd[i] = h.KDJ_D
		hj[i] = h.KDJ_J
	}
	pds := make([]float64, 0, 16)
	hdc := .0
	for _, fd := range fdvs {
		//skip the identical
		if code == fd.Code && hist[0].Klid == fd.Klid[0] {
			continue
		}
		mod := 1.0
		tsmp, e := time.Parse("2006-01-02", fd.SmpDate)
		util.CheckErr(e, "failed to parse sample date: "+fd.SmpDate)
		days := time.Now().Sub(tsmp).Hours() / 24.0
		if days > 800 {
			mod = math.Max(0.8, -0.0003*math.Pow(days-800, 1.0002)+1)
		}
		bkd := bestKdjDevi(hk, hd, hj, fd.K, fd.D, fd.J) * mod
		if bkd >= 0 {
			pds = append(pds, bkd)
			if bkd >= 0.8 {
				hdc++
			}
		}
	}
	total := float64(len(fdvs))
	pdr = float64(len(pds)) / total
	hdr = hdc / total
	var e error
	if len(pds) > 0 {
		mpd, e = stats.Mean(pds)
		util.CheckErr(e, code+" failed to calculate mean of devia")
	}
	di = 0.5 * math.Min(1, math.Pow(hdr+0.92, 50))
	di += 0.3 * math.Min(1, math.Pow(math.Log(pdr+1), 0.37)+0.4*math.Pow(pdr, math.Pi)+math.Pow(pdr, 0.476145))
	di += 0.2 * math.Min(1, math.Pow(math.Log(math.Pow(mpd, math.E*math.Pi/1.1)+1), 0.06)+
		math.E/1.25/math.Pi*math.Pow(mpd, math.E*math.Pi))
	return
}

// Calculates the best match KDJ DEVIA, len(sk)==len(sd)==len(sj),
// and len(sk) and len(tk) can vary.
// DEVIA ranges from negative infinite to 1, with 1 indicating the most relevant KDJ data sets.
func bestKdjDevi(sk, sd, sj, tk, td, tj []float64) float64 {
	//should we also consider the len(x) to weigh the final result?
	dif := len(sk) - len(tk)
	if dif > 0 {
		cc := -100.0
		for i := 0; i <= dif; i++ {
			e := len(sk) - dif + i
			tcc := calcKdjDevi(sk[i:e], sd[i:e], sj[i:e], tk, td, tj)
			if tcc > cc {
				cc = tcc
			}
		}
		return cc
	} else if dif < 0 {
		cc := -100.0
		dif *= -1
		for i := 0; i <= dif; i++ {
			e := len(tk) - dif + i
			tcc := calcKdjDevi(sk, sd, sj, tk[i:e], td[i:e], tj[i:e])
			if tcc > cc {
				cc = tcc
			}
		}
		return cc
	} else {
		return calcKdjDevi(sk, sd, sj, tk, td, tj)
	}
}

func calcKdjDevi(sk, sd, sj, tk, td, tj []float64) float64 {
	kcc, e := util.Devi(sk, tk)
	util.CheckErr(e, "failed to calculate kcc")
	dcc, e := util.Devi(sd, td)
	util.CheckErr(e, "failed to calculate dcc")
	jcc, e := util.Devi(sj, tj)
	util.CheckErr(e, "failed to calculate jcc")
	scc := (kcc*1.0 + dcc*4.0 + jcc*5.0) / 10.0
	return -0.001*math.Pow(scc, math.E) + 1
}

func extractKdjFd(fds []*model.KDJfd) (k, d, j []float64) {
	for _, f := range fds {
		k = append(k, f.K)
		d = append(d, f.D)
		j = append(j, f.J)
	}
	return
}

func (k *KdjV) Id() string {
	return "KDJV"
}

func (k *KdjV) Fields() []string {
	return []string{"DOD", "STATS", "LEN", "KDJ_DY", "KDJ_WK", "KDJ_MO"}
}

func (k *KdjV) Description() string {
	panic("implement me")
}

func (k *KdjV) Geta() (r *Result) {
	return k.Get(nil, -1, false)
}
