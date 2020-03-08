package sampler

import (
	"fmt"
	"math"
	"math/rand"
	"runtime"
	"strings"
	"sync"
	"time"

	"github.com/agux/pachon/conf"
	"github.com/agux/pachon/util"
	"github.com/ssgreg/repeat"

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
	log.Println("loading untagged records...")
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
	ofields := `code, date, klid, rcode, corl_stz`
	fields := `flag, bno, code, date, klid, rcode, corl_stz, udate, utime`
	for j := range chjob {
		var args, uuids []interface{}
		strg := "?" + strings.Repeat(",?", len(j.uuids)-1)
		ud, ut := util.TimeStr()
		args = append(args, j.flag, j.bno, ud, ut)
		for _, el := range j.uuids {
			args = append(args, el)
			uuids = append(uuids, el)
		}
		log.Printf("tagging %s,%d size: %d", j.flag, j.bno, len(j.uuids))
		if e = try(func(c int) (e error) {
			if _, e = dbmap.Exec(
				fmt.Sprintf(`insert into %v (%s) (select (?, ?, %s, ?, ?) from %v where uuid in (%s))`,
					table, fields, ofields, otab, strg),
				args...,
			); e != nil {
				e = errors.Wrapf(e, "failed to flag [%s,%d], retrying %d...", j.flag, j.bno, c+1)
				log.Error(e)
				return repeat.HintTemporary(e)
			}
			return
		}); e != nil {
			log.Fatalf("batch [%s, %d] failed: %+v", j.flag, j.bno, e)
			chr <- j
			continue
		}
		log.Printf("removing sample table for [%s,%d], size: %d", j.flag, j.bno, len(j.uuids))
		if e = try(func(c int) (e error) {
			if _, e = dbmap.Exec(
				fmt.Sprintf(`delete from %v where uuid in (%s))`, otab, strg),
				uuids...,
			); e != nil {
				e = errors.Wrapf(e, "failed to remove sample data for [%s,%d], retrying %d...", j.flag, j.bno, c+1)
				log.Error(e)
				return repeat.HintTemporary(e)
			}
			return
		}); e != nil {
			log.Fatalf("batch [%s, %d] failed: %+v", j.flag, j.bno, e)
		} else {
			j.done = true
		}
		chr <- j
	}
}

func getUUID(table CorlTab) (uuids []int, e error) {
	if e := try(func(c int) error {
		uuids = make([]int, 0, 2048)
		stmt, e := dbmap.Prepare(fmt.Sprintf(`select uuid from %v order by corl`, table))
		if e != nil {
			e = errors.Wrapf(e, "#%d failed to prepare sql statement for %s", c, table)
			log.Error(e)
			return repeat.HintTemporary(e)
		}
		defer stmt.Close()
		rows, e := stmt.Query()
		if e != nil {
			e = errors.Wrapf(e, "#%d failed to execute query for %s", c, table)
			log.Error(e)
			return repeat.HintTemporary(e)
		}
		defer rows.Close()
		var uuid int
		for rows.Next() {
			if e = rows.Scan(&uuid); e != nil {
				e = errors.Wrapf(e, "#%d failed to scan rows for %s", c, table)
				log.Error(e)
				return repeat.HintTemporary(e)
			}
			uuids = append(uuids, uuid)
		}
		if e = rows.Err(); e != nil {
			e = errors.Wrapf(e, "#%d failed to scan rows for %s", c, table)
			log.Error(e)
			return repeat.HintTemporary(e)
		}
		return nil
	}); e != nil {
		return nil, errors.WithStack(e)
	}
	return
}
