package getd

import (
	"database/sql"
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/agux/pachon/conf"
	"github.com/agux/pachon/model"
	"github.com/agux/pachon/util"
	"github.com/ssgreg/repeat"
)

type indexListFetcher interface {
	fetchIndexList() (list []*model.IdxLst, e error)
}

//GetIndexList fetches index list from configured source.
func GetIndexList() {
	var (
		f    klineFetcher
		ok   bool
		e    error
		list []*model.IdxLst
	)
	genop := func(ilf indexListFetcher) func(c int) (e error) {
		return func(c int) (e error) {
			if list, e = ilf.fetchIndexList(); e != nil {
				log.Errorf("#%d failed to get index list: %+v", c, e)
			}
			return
		}
	}
	try := func(ilf indexListFetcher) error {
		return repeat.Repeat(
			repeat.FnWithCounter(genop(ilf)),
			repeat.StopOnSuccess(),
			repeat.LimitMaxTries(conf.Args.DefaultRetry),
			repeat.WithDelay(
				repeat.FullJitterBackoff(500*time.Millisecond).WithMaxDelay(10*time.Second).Set(),
			),
		)
	}
	fetchFrom := func(source model.DataSource) {
		if f, ok = registry[source]; ok {
			if ilf, ok := f.(indexListFetcher); ok {
				log.Infof("fetching index list from %v", source)
				if e = try(ilf); e == nil {
					log.Infof("%d indices fetched from %s", len(list), source)
					saveIdxLst(list)
				}
			}
		} else {
			log.Errorf("no kline fetcher registered for %s", source)
		}
	}
	src := model.DataSource(conf.Args.DataSource.Index)
	vsrc := model.DataSource(conf.Args.DataSource.Validate.IndexSource)
	fetchFrom(src)
	if vsrc != src {
		fetchFrom(vsrc)
	}
}

//GetIndicesV2 fetches index data from configured source.
func GetIndicesV2(isValidate bool) (idxlst, suclst []*model.IdxLst) {
	src := conf.Args.DataSource.Index
	localSource := model.Index
	if isValidate {
		src = conf.Args.DataSource.Validate.IndexSource
		localSource = model.DataSource(fmt.Sprintf("%v_%v", model.Index, src))
	}
	remoteSource := model.DataSource(src)
	log.Infof("Querying index list for source: %s", src)
	_, e := dbmap.Select(&idxlst, `select * from idxlst where src = ?`, src)
	util.CheckErr(e, "failed to query idxlst")
	log.Infof("# indices: %d", len(idxlst))
	idxMap := make(map[string]*model.IdxLst)
	for _, idx := range idxlst {
		log.Infof("%+v", *idx)
		idxMap[idx.Code] = idx
	}
	stks := &model.Stocks{}
	for _, idx := range idxlst {
		stks.Add(&model.Stock{
			Market: sql.NullString{
				String: idx.Market,
				Valid:  true,
			},
			Code:   idx.Code,
			Name:   idx.Name,
			Source: src,
		})
	}
	var frs []FetchRequest
	kltypes := conf.Args.DataSource.KlineTypes
	if len(kltypes) > 0 {
		cycles := make(map[string]bool)
		for _, t := range kltypes {
			c := t["cycle"]
			if _, ok := cycles[c]; ok {
				continue
			}
			cycles[c] = true
			frs = append(frs, FetchRequest{
				RemoteSource: remoteSource,
				LocalSource:  localSource,
				Reinstate:    model.None,
				Cycle:        model.CYTP(c),
			})
		}
	} else {
		fr := FetchRequest{
			RemoteSource: remoteSource,
			LocalSource:  localSource,
			Reinstate:    model.None,
		}
		cs := []model.CYTP{model.DAY, model.WEEK, model.MONTH}
		frs = make([]FetchRequest, len(cs))
		for i, c := range cs {
			fr.Cycle = c
			frs[i] = fr
		}
	}
	rstks := GetKlinesV2(stks, frs...)
	for _, c := range rstks.Codes {
		suclst = append(suclst, idxMap[c])
	}
	return
}

func saveIdxLst(idxLst []*model.IdxLst) {
	insert := func(list []*model.IdxLst) {
		var vals []string
		var args []interface{}
		ph := "(?,?,?,?)"
		for _, el := range list {
			vals = append(vals, ph)
			args = append(args,
				el.Src,
				el.Market,
				el.Code,
				el.Name,
			)
		}
		op := func(c int) (e error) {
			stmt := fmt.Sprintf("INSERT INTO idxlst (src, market, code, name) VALUES %s"+
				" on duplicate key update market=values(market),name=values(name)", strings.Join(vals, ","))
			_, e = dbmap.Exec(stmt, args...)
			if e != nil {
				log.Errorf("#%d failed to insert idxlst table: %+v", c, e)
				return repeat.HintTemporary(e)
			}
			log.Infof("%d index source updated", len(idxLst))
			return
		}

		if e := repeat.Repeat(
			repeat.FnWithCounter(op),
			repeat.StopOnSuccess(),
			repeat.LimitMaxTries(conf.Args.DefaultRetry),
			repeat.WithDelay(
				repeat.FullJitterBackoff(500*time.Millisecond).WithMaxDelay(10*time.Second).Set(),
			),
		); e != nil {
			panic(e)
		}
	}

	bsize := 1000
	leng := len(idxLst)
	for i := 0; i < leng; i = i + bsize {
		end := int(math.Min(float64(leng), float64(i+bsize)))
		insert(idxLst[i:end])
	}

}
