package getd

import (
	"math"
	"time"

	"github.com/agux/pachon/conf"
	"github.com/agux/pachon/model"
)

func readFetReqs() (preReqs, masterReqs []FetchRequest) {
	kltypes := conf.Args.DataSource.KlineTypes
	if len(kltypes) == 0 {
		return
	}
	src := model.DataSource(conf.Args.DataSource.Kline)
	for _, klt := range kltypes {
		switch klt["reinstate"] {
		case string(model.None):
			preReqs = append(preReqs, FetchRequest{
				RemoteSource: src,
				LocalSource:  model.KlineMaster,
				Reinstate:    model.None,
				Cycle:        model.CYTP(klt["cycle"]),
			})
		default:
			masterReqs = append(masterReqs, FetchRequest{
				RemoteSource: src,
				LocalSource:  model.KlineMaster,
				Reinstate:    model.Rtype(klt["reinstate"]),
				Cycle:        model.CYTP(klt["cycle"]),
			})
		}
	}
	return
}

//GetV2 gets miscellaneous stock info.
func GetV2() {
	var allstks, stks *model.Stocks
	start := time.Now()
	defer StopWatch("GETD_TOTAL", start)
	if !conf.Args.DataSource.SkipStocks {
		allstks = GetStockInfo()
		StopWatch("STOCK_LIST", start)
	} else {
		log.Printf("skipped stock data from web")
		allstks = new(model.Stocks)
		stks := StocksDb()
		log.Printf("%d stocks queried from db", len(stks))
		allstks.Add(stks...)
	}

	//every step hereafter returns only the stocks successfully processed
	if !conf.Args.DataSource.SkipFinance {
		stgfi := time.Now()
		stks = GetFinance(allstks)
		StopWatch("GET_FINANCE", stgfi)
	} else {
		log.Printf("skipped finance data from web")
		stks = allstks
	}

	if !conf.Args.DataSource.SkipFinancePrediction {
		fipr := time.Now()
		stks = GetFinPrediction(stks)
		StopWatch("GET_FIN_PREDICT", fipr)
	} else {
		log.Printf("skipped financial prediction data from web")
	}

	if !conf.Args.DataSource.SkipXdxr {
		// Validate Kline process already fetches XDXR info
		if conf.Args.DataSource.SkipKlineVld {
			stgx := time.Now()
			stks = GetXDXRs(stks)
			StopWatch("GET_XDXR", stgx)
		}
	} else {
		log.Printf("skipped xdxr data from web")
	}

	stks = getKlineVld(stks)

	cs := []model.CYTP{model.DAY, model.WEEK, model.MONTH}
	src := model.DataSource(conf.Args.DataSource.Kline)
	preReqs, masterReqs := readFetReqs()
	postProcess := false
	if !conf.Args.DataSource.SkipKlinePre {
		begin := time.Now()
		if len(preReqs) == 0 {
			preReqs = make([]FetchRequest, 3)
			for i := range preReqs {
				preReqs[i] = FetchRequest{
					RemoteSource: src,
					LocalSource:  model.KlineMaster,
					Reinstate:    model.None,
					Cycle:        cs[i],
				}
			}
		}
		stks = GetKlinesV2(stks, preReqs...)
		StopWatch("GET_KLINES_PRE", begin)
		postProcess = true
	} else {
		log.Printf("skipped kline-pre data from web (non-reinstated)")
	}

	if !conf.Args.DataSource.SkipKlines {
		begin := time.Now()
		if len(masterReqs) == 0 {
			masterReqs = make([]FetchRequest, 6)
			for i := range masterReqs {
				csi := int(math.Mod(float64(i), 3))
				r := model.Backward
				if i > 2 {
					r = model.Forward
				}
				masterReqs[i] = FetchRequest{
					RemoteSource: src,
					LocalSource:  model.KlineMaster,
					Reinstate:    r,
					Cycle:        cs[csi],
				}
			}
		}
		stks = GetKlinesV2(stks, masterReqs...)
		StopWatch("GET_KLINES_MASTER", begin)
		postProcess = true
	} else {
		log.Printf("skipped klines data from web (backward & forward reinstated)")
	}

	FreeFetcherResources()
	if postProcess {
		stks = KlinePostProcess(stks)
	}

	if !conf.Args.DataSource.SkipIndicesVld {
		stidx := time.Now()
		GetIndicesV2(true)
		StopWatch("GET_INDICES_VLD", stidx)
	} else {
		log.Printf("skipped validation index data from web")
	}

	var allIdx, sucIdx []*model.IdxLst
	if !conf.Args.DataSource.SkipIndices {
		stidx := time.Now()
		allIdx, sucIdx = GetIndicesV2(false)
		StopWatch("GET_INDICES", stidx)
		for _, idx := range allIdx {
			allstks.Add(&model.Stock{Code: idx.Code, Name: idx.Name})
		}
	} else {
		log.Printf("skipped index data from web")
	}

	if !conf.Args.DataSource.SkipBasicsUpdate {
		updb := time.Now()
		stks = updBasics(stks)
		StopWatch("UPD_BASICS", updb)
	} else {
		log.Printf("skipped updating basics table")
	}

	// Add indices pending to be calculated
	for _, idx := range sucIdx {
		stks.Add(&model.Stock{Code: idx.Code, Name: idx.Name, Source: idx.Src})
	}
	if !conf.Args.DataSource.SkipIndexCalculation {
		stci := time.Now()
		stks = CalcIndics(stks)
		StopWatch("CALC_INDICS", stci)
	} else {
		log.Printf("skipped index calculation")
	}

	if !conf.Args.DataSource.SkipFsStats {
		stfss := time.Now()
		CollectFsStats()
		StopWatch("FS_STATS", stfss)
	} else {
		log.Printf("skipped feature scaling stats")
	}

	if !conf.Args.DataSource.SkipFinMark {
		finMark(stks)
	} else {
		log.Printf("skipped updating fin mark")
	}

	rptFailed(allstks, stks)
}

func getKlineVld(stks *model.Stocks) *model.Stocks {
	if conf.Args.DataSource.SkipKlineVld {
		log.Printf("skipped kline-vld data from web")
		return stks
	}

	vsrc := model.DataSource(conf.Args.DataSource.Validate.Source)
	cs := []model.CYTP{model.DAY, model.WEEK, model.MONTH}
	preReqs, masterReqs := readFetReqs()
	if conf.Args.DataSource.Validate.SkipKlinePre {
		log.Printf("skipped preliminary data for validate klines (non-reinstated)")
	} else {
		if len(preReqs) == 0 {
			preReqs = make([]FetchRequest, 3)
			for i := range preReqs {
				preReqs[i] = FetchRequest{
					RemoteSource: vsrc,
					LocalSource:  vsrc,
					Reinstate:    model.None,
					Cycle:        cs[i],
				}
			}
		}
		begin := time.Now()
		stks = GetKlinesV2(stks, preReqs...)
		UpdateValidateKlineParams()
		StopWatch("GET_VLD_KLINES_PRE", begin)
	}

	if conf.Args.DataSource.Validate.SkipKlines {
		log.Printf("skipped validate kline main data (backward & forward reinstated)")
	} else {
		if len(masterReqs) == 0 {
			masterReqs = make([]FetchRequest, 6)
			for i := range masterReqs {
				csi := int(math.Mod(float64(i), 3))
				r := model.Backward
				if i > 2 {
					r = model.Forward
				}
				masterReqs[i] = FetchRequest{
					RemoteSource: vsrc,
					LocalSource:  vsrc,
					Reinstate:    r,
					Cycle:        cs[csi],
				}
			}
		}
		begin := time.Now()
		stks = GetKlinesV2(stks, masterReqs...)
		StopWatch("GET_VLD_KLINES_MASTER", begin)
	}

	FreeFetcherResources()

	return stks
}
