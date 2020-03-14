package sampler

import (
	"fmt"
	"math"
	"math/rand"
	"runtime"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/agux/pachon/conf"
	"github.com/agux/pachon/model"
	"github.com/agux/pachon/util"
	"github.com/ssgreg/repeat"
	"gopkg.in/gorp.v2"

	"github.com/pkg/errors"
)

//CorlTab type, such as XcorlTrn, WccTrn, etc.
type CorlTab string
type tagJob struct {
	flag  string
	bno   int
	uuids []int
	done  bool
}

const (
	XcorlSmp CorlTab = "xcorl_smp"
	//XcorlTrn Cross Correlation Training
	XcorlTrn CorlTab = "xcorl_trn"
	//WccTrn Warping Correlation Coefficient Training
	WccTrn CorlTab = "wcc_trn"
	WccSmp CorlTab = "wcc_smp"
)

//TagCorlTrn create tags from the correlation sample table (such as xcorl_smp or wcc_smp)
//and transfers tagged sets to the final table (such as xcorl_trn or wcc_trn),
//by randomly and evenly selecting untagged samples based on corl score.
func TagCorlTrn(table CorlTab, flag string) (e error) {
	log.Printf("tagging %v for dataset %s...", table, flag)
	var otab CorlTab
	switch table {
	case XcorlTrn:
		otab = XcorlSmp
	case WccTrn:
		otab = WccSmp
	}
	startno := 0
	vflag := ""
	bsize := 0
	switch flag {
	case TrainFlag:
		vflag = "TR"
		bsize = conf.Args.Sampler.TrainSetBatchSize
	case TestFlag:
		vflag = "TS"
		bsize = conf.Args.Sampler.TestSetBatchSize
	default:
		log.Panicf("unsupported flag: %s", flag)
	}
	log.Infof("querying max bno from wcc_trn with flag %s...", vflag)
	// load existent max tag number
	q := fmt.Sprintf(
		"SELECT  "+
			"    MAX(distinct bno) AS max_bno "+
			"FROM "+
			"    %s "+
			"WHERE "+
			"    flag = ?",
		table)
	if e = try(func(c int) error {
		sno, e := dbmap.SelectNullInt(q, vflag)
		if e != nil {
			e = errors.Wrapf(e, "#%d failed to query max bno from %s with flag %s", c, table, vflag)
			log.Error(e)
			return repeat.HintTemporary(e)
		}
		if sno.Valid {
			startno = int(sno.Int64)
			log.Printf("continue with batch number: %d", startno+1)
		} else {
			log.Printf("no existing data for %s set. batch no will be starting from %d", vflag, startno+1)
		}
		return nil
	}); e != nil {
		return errors.WithStack(e)
	}
	// tag group * batch_size of target data from untagged records randomly and evenly
	log.Printf("loading untagged records from %v ...", otab)
	untagged, e := getUUID(otab)
	if e != nil {
		return errors.WithStack(e)
	}
	total := len(untagged)
	log.Printf("total of untagged records: %d", total)
	segment := int(float64(total) / float64(bsize))
	rem := int(total) % bsize
	//take care of remainder
	remOwn := make(map[int]bool)
	if rem > 0 {
		perm := rand.Perm(bsize)
		for i := 0; i < rem; i++ {
			remOwn[perm[i]] = true
		}
	}
	offset := 0
	var batches int
	switch flag {
	case TestFlag:
		batches = conf.Args.Sampler.TestSetGroups
	case TrainFlag:
		batches = segment
	}
	grps := make([][]int, batches)
	for i := 0; i < bsize; i++ {
		limit := segment
		if _, ok := remOwn[i]; ok {
			limit++
		}
		var uuids []int
		if i < bsize-1 {
			uuids = untagged[offset : offset+limit]
		} else {
			uuids = untagged[offset:]
		}
		log.Printf("%d/%d size: %d", i+1, bsize, len(uuids))
		offset += limit
		log.Printf("generating permutations of size %d...", len(uuids))
		perm := rand.Perm(len(uuids))
		n := int(math.Min(float64(len(perm)), float64(batches)))
		for j := 0; j < n; j++ {
			grps[j] = append(grps[j], uuids[perm[j]])
		}
	}
	untagged = nil
	remOwn = nil
	var wg, wgr sync.WaitGroup
	chjob := make(chan *tagJob, conf.Args.DBQueueCapacity)
	chr := make(chan *tagJob, conf.Args.DBQueueCapacity)
	ngrps := len(grps)
	pll := int(math.Max(float64(runtime.NumCPU())*conf.Args.Sampler.CPUWorkloadRatio, 1.0))
	wgr.Add(1)
	go collectTagJob(ngrps, &wgr, chr)
	for i := 0; i < pll; i++ {
		wg.Add(1)
		go procTagJob(table, &wg, chjob, chr)
	}
	for i := 0; i < len(grps); i++ {
		chjob <- &tagJob{
			flag:  vflag,
			bno:   startno + i + 1,
			uuids: grps[i],
		}
	}
	close(chjob)
	wg.Wait()
	close(chr)
	wgr.Wait()

	log.Printf("%v %s set tagged: %d", table, flag, ngrps)
	return nil
}

func try(op func(c int) error) error {
	return repeat.Repeat(
		repeat.FnWithCounter(op),
		repeat.StopOnSuccess(),
		repeat.LimitMaxTries(conf.Args.DefaultRetry),
		repeat.WithDelay(
			repeat.FullJitterBackoff(5*time.Second).WithMaxDelay(30*time.Second).Set(),
		),
	)
}

func collectTagJob(ngrps int, wgr *sync.WaitGroup, chr chan *tagJob) {
	defer wgr.Done()
	i := 0
	f := 0
	for j := range chr {
		//report progres
		i++
		status := "done"
		if !j.done {
			f++
			status = "failed"
		}
		prog := float64(float64(i)/float64(ngrps)) * 100.
		log.Printf("job %s_%d %s, progress: %d/%d(%.3f%%), failed:%d", j.flag, j.bno, status, i, ngrps, prog, f)
	}
}

func procTagJob(table CorlTab, wg *sync.WaitGroup, chjob chan *tagJob, chr chan *tagJob) {
	defer wg.Done()
	var e error
	var otab CorlTab
	switch table {
	case XcorlTrn:
		otab = XcorlSmp
	case WccTrn:
		otab = WccSmp
	}
	ofields := []string{"code", "date", "klid", "rcode", "corl_stz"}
	fields := []string{"flag", "bno", "code", "date", "klid", "rcode", "corl_stz", "udate", "utime"}
	for j := range chjob {
		var uuids []interface{}
		strg := "?" + strings.Repeat(",?", len(j.uuids)-1)
		for _, el := range j.uuids {
			uuids = append(uuids, el)
		}
		//insert-select sql statement runs very slow with partitioned wcc_trn table,
		//possible cause is scanning over all partitions, as of MySQL v8.0.18
		var rows []*model.WccTrn
		if e = try(func(c int) (e error) {
			q := fmt.Sprintf(
				`select %s from %v where uuid in (%s)`,
				strings.Join(ofields, ","), otab, strg)
			if _, e = dbmap.Select(&rows, q, uuids...); e != nil {
				e = errors.Wrapf(e, "#%d batch [%s,%d] failed to query from %v, sql: %s",
					c, j.flag, j.bno, otab, q)
				log.Error(e)
				return repeat.HintTemporary(e)
			}
			return
		}); e != nil {
			log.Fatalf("batch [%s, %d] failed: %+v", j.flag, j.bno, e)
			chr <- j
			continue
		}

		holder := "(?" + strings.Repeat(",?", len(fields)-1) + ")"
		holders := holder + strings.Repeat(", "+holder, len(rows)-1)
		var args []interface{}
		ud, ut := util.TimeStr()
		for _, row := range rows {
			args = append(args, j.flag)
			args = append(args, j.bno)
			args = append(args, row.Code)
			args = append(args, row.Date)
			args = append(args, row.Klid)
			args = append(args, row.Rcode)
			args = append(args, row.CorlStz)
			args = append(args, ud)
			args = append(args, ut)
		}

		if e = try(func(c int) (e error) {
			var tx *gorp.Transaction
			if tx, e = dbmap.Begin(); e != nil {
				e = errors.Wrapf(e, "#%d failed to flag [%s,%d], unable to start transaction", c, j.flag, j.bno)
				log.Error(e)
				return repeat.HintTemporary(e)
			}
			log.Printf("tagging %s,%d size: %d", j.flag, j.bno, len(j.uuids))

			q := fmt.Sprintf(
				`insert into %v (%s) values %s`,
				table, strings.Join(fields, ","), holders)
			if _, e = tx.Exec(q, args...); e != nil {
				if re := tx.Rollback(); re != nil {
					log.Fatalf("failed to rollback: %+v", re)
				}
				e = errors.Wrapf(e, "#%d failed to insert %s [%s,%d], sql:%s", c, table, j.flag, j.bno, q)
				log.Error(e)
				return repeat.HintTemporary(e)
			}
			log.Debugf("removing sample table for [%s,%d], size: %d", j.flag, j.bno, len(j.uuids))
			q = fmt.Sprintf(`delete from %v where uuid in (%s)`, otab, strg)
			if _, e = tx.Exec(q, uuids...); e != nil {
				if re := tx.Rollback(); re != nil {
					log.Fatalf("failed to rollback: %+v", re)
				}
				e = errors.Wrapf(e, "#%d failed to remove %s data for [%s,%d], sql:%s", c, otab, j.flag, j.bno, q)
				log.Error(e)
				return repeat.HintTemporary(e)
			}
			if e = tx.Commit(); e != nil {
				log.Fatalf("#%d failed to commit transaction for [%s,%d]: %+v", c, j.flag, j.bno, e)
				return repeat.HintTemporary(e)
			}
			return
		}); e != nil {
			log.Fatalf("batch [%s, %d] failed: %+v", j.flag, j.bno, e)
			chr <- j
			continue
		} else {
			j.done = true
		}
		chr <- j
	}
}

func getUUID(table CorlTab) (uuids []int, e error) {
	runner := func(partition string, receiver chan<- interface{}) func(c int) (e error) {
		return func(c int) (e error) {
			var records []*model.WccSmp
			q := fmt.Sprintf(`select uuid, corl from %v partition (%s)`, table, partition)
			if _, e = dbmap.Select(&records, q); e != nil {
				e = errors.Wrapf(e, "#%d failed to query %v uuid & corl for partition %s", c, table, partition)
				log.Error(e)
				return repeat.HintTemporary(e)
			}
			receiver <- records
			return
		}
	}
	result, e := runByPartitions(nil, string(table), runner)
	var records []*model.WccSmp
	for _, r := range result {
		records = append(records, r.([]*model.WccSmp)...)
	}
	log.Printf("total samples: %d", len(records))
	log.Println("sorting samples by corl...")
	sort.Slice(records, func(i, j int) bool {
		ci, cj := records[i].Corl, records[j].Corl
		return ci < cj
	})
	log.Println("sort complete. extracting UUID...")
	for _, r := range records {
		uuids = append(uuids, r.UUID)
	}
	return
}
