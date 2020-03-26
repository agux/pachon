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
	"github.com/agux/pachon/model"
	"github.com/agux/pachon/util"
	"github.com/jfcg/sorty"
	"github.com/lytics/ordpool"
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

//TODO use bucketing to execute SQL for wcc tagging

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
	defer func() {
		if r := recover(); r != nil {
			if er, hasError := r.(error); hasError {
				log.Errorf("caught error:%+v", er)
			}
		}
	}()
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
	log.Infof("querying max bno from %v with flag %s...", table, vflag)
	// load existent max tag number
	q := fmt.Sprintf(
		"SELECT  "+
			"    MAX(bno) AS max_bno "+
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
		log.Errorf("failed to get UUID: %+v", e)
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

	updateMaxBNO(table, flag)

	log.Printf("%v %s set tagged: %d", table, flag, ngrps)
	return nil
}

func updateMaxBNO(table CorlTab, flag string) {
	q := fmt.Sprintf(`
		INSERT INTO fs_stats (method, tab, fields, vmax, udate, utime) 
		SELECT 
			'standardization', ?, ?, max(bno), 
			DATE_FORMAT(now(), '%%Y-%%m-%%d'), DATE_FORMAT(now(), '%%H:%%i:%%S')
		FROM
			%v
		WHERE 
			flag = ?
		ON DUPLICATE KEY UPDATE 
			vmax=values(vmax), 
			udate=values(udate), 
			utime=values(utime)
	`, table)
	if e := try(func(c int) error {
		if _, e := dbmap.Exec(q, string(table), flag+"_BNO", flag); e != nil {
			e = errors.Wrapf(e, "#%d failed to update max bno for %v, %s, sql: %s\nerror:%+v", c, table, flag, q, e)
			log.Error(e)
			return repeat.HintTemporary(e)
		}
		return nil
	}); e != nil {
		log.Panicf("failed to update max bno for %v, %s: %+v", table, flag, e)
	}
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
	var cachedJob []*tagJob
	var cachedUUID []interface{}
	var cachedArgs []interface{}
	cacheSize := 0
	ofields := []string{"code", "date", "klid", "rcode", "corl_stz"}
	fields := []string{"flag", "bno", "code", "date", "klid", "rcode", "corl_stz", "udate", "utime"}
	flushCache := func(insArgs, uuid []interface{}, insRowSize int) {
		if e = writeTag(table, otab, fields, insArgs, uuid, insRowSize); e == nil {
			for _, cj := range cachedJob {
				cj.done = true
			}
		} else {
			log.Errorf("write db failed, record size %d : %+v", insRowSize, e)
		}
		for _, j := range cachedJob {
			chr <- j
		}
	}
	for j := range chjob {
		var uuids []interface{}
		for _, el := range j.uuids {
			uuids = append(uuids, el)
		}
		//insert-select sql statement runs very slow with partitioned wcc_trn table,
		//possible cause is scanning over all partitions, as of MySQL v8.0.18
		var rows []*model.WccTrn
		log.Debugf("tagging [%s,%d] size: %d", j.flag, j.bno, len(j.uuids))
		if e = try(func(c int) (e error) {
			q := fmt.Sprintf(
				`select %s from %v where uuid in (%s)`,
				strings.Join(ofields, ","), otab, "?"+strings.Repeat(",?", len(uuids)-1))
			if _, e = dbmap.Select(&rows, q, uuids...); e != nil {
				e = errors.Wrapf(e, "#%d batch [%s,%d] failed to query from %v, sql: %s",
					c, j.flag, j.bno, otab, q)
				log.Error(e)
				return repeat.HintTemporary(e)
			}
			return
		}); e != nil {
			log.Errorf("batch [%s, %d] failed: %+v", j.flag, j.bno, e)
			chr <- j
			continue
		}

		ud, ut := util.TimeStr()
		for _, row := range rows {
			cachedArgs = append(cachedArgs, j.flag)
			cachedArgs = append(cachedArgs, j.bno)
			cachedArgs = append(cachedArgs, row.Code)
			cachedArgs = append(cachedArgs, row.Date)
			cachedArgs = append(cachedArgs, row.Klid)
			cachedArgs = append(cachedArgs, row.Rcode)
			cachedArgs = append(cachedArgs, row.CorlStz)
			cachedArgs = append(cachedArgs, ud)
			cachedArgs = append(cachedArgs, ut)
		}

		cacheSize += len(rows)
		cachedJob = append(cachedJob, j)
		cachedUUID = append(cachedUUID, uuids...)

		if cacheSize >= conf.Args.Database.BucketSize {
			flushCache(cachedArgs, cachedUUID, cacheSize)
			//clear cache
			cacheSize = 0
			cachedJob = make([]*tagJob, 0, 64)
			cachedArgs = make([]interface{}, 0, 2048)
			cachedUUID = make([]interface{}, 0, 2048)
		}
	}

	if cacheSize > 0 {
		flushCache(cachedArgs, cachedUUID, cacheSize)
	}
}

func writeTag(table, otab CorlTab, fields []string, insArgs, uuid []interface{}, insRowSize int) (e error) {
	holder := "(?" + strings.Repeat(",?", len(fields)-1) + ")"
	insPH := holder + strings.Repeat(", "+holder, insRowSize-1)
	delPH := "?" + strings.Repeat(",?", len(uuid)-1)
	if e = try(func(c int) (e error) {
		var tx *gorp.Transaction
		if tx, e = dbmap.Begin(); e != nil {
			e = errors.Wrapf(e, "#%d unable to start transaction", c)
			log.Error(e)
			return repeat.HintTemporary(e)
		}
		q := fmt.Sprintf(
			`insert into %v (%s) values %s`,
			table, strings.Join(fields, ","), insPH)
		if _, e = tx.Exec(q, insArgs...); e != nil {
			if re := tx.Rollback(); re != nil {
				log.Errorf("failed to rollback: %+v", re)
			}
			e = errors.Wrapf(e, "#%d failed to insert %s, sql:%s", c, table, q)
			log.Error(e)
			return repeat.HintTemporary(e)
		}
		log.Debugf("removing %v, size: %d", otab, insRowSize)
		q = fmt.Sprintf(`delete from %v where uuid in (%s)`, otab, delPH)
		if _, e = tx.Exec(q, uuid...); e != nil {
			if re := tx.Rollback(); re != nil {
				log.Errorf("failed to rollback: %+v", re)
			}
			e = errors.Wrapf(e, "#%d failed to remove %s data, sql:%s", c, otab, q)
			log.Error(e)
			return repeat.HintTemporary(e)
		}
		if e = tx.Commit(); e != nil {
			log.Errorf("#%d failed to commit transaction: %+v", c, e)
			return repeat.HintTemporary(e)
		}
		return
	}); e != nil {
		e = errors.Wrapf(e, "write db failed")
		log.Error(e)
	}
	return
}

type sample struct {
	UUID int
	Corl float64
}

func getUUID(table CorlTab) (uuids []int, e error) {
	rch := make(chan []sample, conf.Args.DBQueueCapacity)
	var closeOnce sync.Once
	defer closeOnce.Do(func() { close(rch) })

	var records []sample
	var wgr sync.WaitGroup
	wgr.Add(1)
	go func() {
		defer wgr.Done()
		for r := range rch {
			records = append(records, r...)
		}
	}()

	runner := func(partition string) func(c int) (e error) {
		return func(c int) (e error) {
			// var count int64
			// q := fmt.Sprintf(`select count(uuid) from %v partition (%s)`, table, partition)
			// if count, e = dbmap.SelectInt(q); e != nil {
			// 	e = errors.Wrapf(e, "#%d failed to count %v uuid for partition %s", c, table, partition)
			// 	log.Error(e)
			// 	return repeat.HintTemporary(e)
			// }
			// log.Printf("%v partition %s records: %d", table, partition, count)
			var records []sample
			q := fmt.Sprintf(`select uuid, corl from %v partition (%s)`, table, partition)
			if _, e = dbmap.Select(&records, q); e != nil {
				e = errors.Wrapf(e, "#%d failed to query %v uuid & corl for partition %s", c, table, partition)
				log.Error(e)
				return repeat.HintTemporary(e)
			}
			rch <- records
			return nil
		}
	}

	if e = runByPartitions(nil, string(table), runner); e != nil {
		e = errors.WithStack(e)
		return
	}

	closeOnce.Do(func() { close(rch) })
	wgr.Wait()

	log.Printf("total samples: %d", len(records))
	log.Println("sorting samples by corl...")
	// native sort took about 11 min to sort 0.5 billion records.
	// sort.Slice(records, func(i, j int) bool {
	// 	ci, cj := records[i].Corl, records[j].Corl
	// 	return ci < cj
	// })

	// using parallel sort lib
	sortSamples(records)
	log.Println("sort complete. extracting UUID...")
	// extract UUID in parallel and must preserve slice order
	const SegSize = 4096
	batch := int(math.Ceil(float64(len(records)) / float64(SegSize)))

	// numWorkers := int(math.Round(float64(runtime.NumCPU()) * conf.Args.Sampler.CPUWorkloadRatio))
	numWorkers := runtime.NumCPU()

	o := ordpool.New(numWorkers, extractUUID)
	o.Start()

	go func(ch <-chan interface{}) {
		for r := range ch {
			uuids = append(uuids, r.([]int)...)
		}
	}(o.GetOutputCh())

	workChan := o.GetInputCh()
	for i := 0; i < batch; i++ {
		count := len(records)
		if count > SegSize {
			workChan <- records[:SegSize]
			records = records[SegSize:]
		} else {
			workChan <- records
		}
	}

	o.Stop()
	o.WaitForShutdown()

	errs := o.GetErrs()
	if len(errs) != 0 {
		log.Panicf("failed to extract UUIDs: %+v", errs)
	}

	log.Printf("Finished extracting UUID. Records: %d", len(uuids))
	samLen := 10
	if len(uuids) <= 0 {
		samLen = len(uuids)
	}
	log.Printf("First %d Samples: %+v", samLen, uuids[:samLen])
	return
}

func extractUUID(input interface{}) (output interface{}, e error) {
	seg := input.([]sample)
	var ret []int
	for _, s := range seg {
		ret = append(ret, s.UUID)
	}
	return ret, nil
}

func sortSamples(records []sample) {
	lsw := func(i, k, r, s int) bool {
		if records[i].Corl < records[k].Corl {
			if r != s {
				records[r], records[s] = records[s], records[r]
			}
			return true
		}
		return false
	}
	sorty.Sort3(len(records), lsw)
}
