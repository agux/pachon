package util

import (
	"bufio"
	"compress/flate"
	"compress/gzip"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"time"

	"github.com/carusyte/stock/conf"
	"github.com/pkg/errors"
	"github.com/shirou/gopsutil/cpu"
	"github.com/ssgreg/repeat"
)

//CPUUsage returns current cpu idle percentage.
func CPUUsage() (idle float64, e error) {
	var ps []float64
	ps, e = cpu.Percent(0, false)
	if e != nil {
		return
	}
	return ps[0], e
}

//FileExists checks whether the specified file exists
//in the provided directory (or optionally its sub-directory).
func FileExists(dir, name string, searchSubDirectory bool) (exists bool, path string, e error) {
	paths := []string{filepath.Join(dir, name)}
	op := func(c int) error {
		if searchSubDirectory {
			dirs, err := ioutil.ReadDir(dir)
			if err != nil {
				log.Printf("#%d failed to read content from %s: %+v", c, dir, err)
				return repeat.HintTemporary(errors.WithStack(err))
			}
			for _, d := range dirs {
				if d.IsDir() {
					paths = append(paths, filepath.Join(dir, d.Name(), name))
				}
			}
		}
		for _, p := range paths {
			_, e = os.Stat(p)
			if e != nil {
				if !os.IsNotExist(e) {
					log.Printf("#%d failed to check existence of %s : %+v", c, p, e)
					return repeat.HintTemporary(errors.WithStack(e))
				}
			} else {
				exists = true
				path = p
				return nil
			}
		}
		return nil
	}

	e = repeat.Repeat(
		repeat.FnWithCounter(op),
		repeat.StopOnSuccess(),
		repeat.LimitMaxTries(conf.Args.DefaultRetry),
		repeat.WithDelay(
			repeat.FullJitterBackoff(500*time.Millisecond).WithMaxDelay(5*time.Second).Set(),
		),
	)

	return
}

//NumOfFiles counts files matching the provided pattern
//under the specified directory (or optionally its sub-directory).
func NumOfFiles(dir, pattern string, searchSubDirectory bool) (num int, e error) {
	op := func(c int) error {
		num = 0
		if _, e = os.Stat(dir); e != nil {
			log.Printf("#%d failed to read stat for %s: %+v", c, dir, e)
			return repeat.HintTemporary(errors.WithStack(e))
		}
		paths := []string{dir}
		if searchSubDirectory {
			dirs, e := ioutil.ReadDir(dir)
			if e != nil {
				log.Printf("#%d failed to read content from %s: %+v", c, dir, e)
				return repeat.HintTemporary(errors.WithStack(e))
			}
			for _, d := range dirs {
				if d.IsDir() {
					paths = append(paths, filepath.Join(dir, d.Name()))
				}
			}
		}
		for _, p := range paths {
			files, e := ioutil.ReadDir(p)
			if e != nil {
				log.Printf("#%d failed to read content from %s: %+v", c, p, e)
				return repeat.HintTemporary(errors.WithStack(e))
			}
			for _, f := range files {
				if !f.IsDir() {
					m, e := regexp.MatchString(pattern, f.Name())
					if e != nil {
						return repeat.HintStop(errors.WithStack(e))
					}
					if m {
						num++
					}
				}
			}
		}
		return nil
	}

	e = repeat.Repeat(
		repeat.FnWithCounter(op),
		repeat.StopOnSuccess(),
		repeat.LimitMaxTries(conf.Args.DefaultRetry),
		repeat.WithDelay(
			repeat.FullJitterBackoff(500*time.Millisecond).WithMaxDelay(5*time.Second).Set(),
		),
	)

	return
}

//WriteJSONFile writes provided payload object pointer as (gzipped) json formatted file.
//it first tries to write to a *.tmp file, then renames it to *.json(.gz),
//then returns the final path of the written file. If the final file already exists, error is returned.
//path parameter should not include file extensions.
func WriteJSONFile(payload interface{}, path string, compress bool) (finalPath string, e error) {
	op := func(c int) error {
		tmp := fmt.Sprintf("%s.tmp", path)
		if compress {
			finalPath = fmt.Sprintf("%s.json.gz", path)
		} else {
			finalPath = fmt.Sprintf("%s.json", path)
		}
		dir, name := filepath.Dir(tmp), filepath.Base(tmp)
		ex, _, e := FileExists(dir, name, false)
		if e != nil {
			return repeat.HintStop(errors.WithMessage(errors.WithStack(e), "unable to check existence for "+tmp))
		}
		if ex {
			os.Remove(tmp)
		}
		dir, name = filepath.Dir(finalPath), filepath.Base(finalPath)
		ex, _, e = FileExists(dir, name, false)
		if e != nil {
			return repeat.HintStop(errors.WithMessage(errors.WithStack(e), "unable to check existence for "+finalPath))
		}
		if ex {
			return repeat.HintStop(fmt.Errorf("%s already exists", finalPath))
		}
		jsonBytes, e := json.Marshal(payload)
		if e != nil {
			log.Printf("#%d failed to marshal payload %+v: %+v", c, payload, e)
			return repeat.HintStop(e)
		}
		_, e = bufferedWrite(tmp, jsonBytes, compress)
		if e != nil {
			log.Printf("#%d %+v", c, e)
			return repeat.HintTemporary(e)
		}
		e = os.Rename(tmp, finalPath)
		if e != nil {
			log.Printf("#%d failed to rename %s to %s: %+v", c, tmp, finalPath, e)
			return repeat.HintTemporary(e)
		}
		return nil
	}

	e = repeat.Repeat(
		repeat.FnWithCounter(op),
		repeat.StopOnSuccess(),
		repeat.LimitMaxTries(conf.Args.DefaultRetry),
		repeat.WithDelay(
			repeat.FullJitterBackoff(500*time.Millisecond).WithMaxDelay(15*time.Second).Set(),
		),
	)

	return
}

func bufferedWrite(path string, data []byte, compress bool) (nn int, e error) {
	var wt io.Writer
	wt, e = os.OpenFile(path, os.O_WRONLY|os.O_CREATE, 0666)
	if e != nil {
		return nn, errors.WithStack(
			errors.WithMessage(e, fmt.Sprintf("failed to create file %s", path)))
	}
	if compress {
		wt, e = gzip.NewWriterLevel(wt, flate.BestCompression)
		if e != nil {
			return nn, errors.WithStack(
				errors.WithMessage(e, fmt.Sprintf("failed to create gzip writer %s", path)))
		}
	}
	bw := bufio.NewWriter(wt)
	defer func() {
		bw.Flush()
		wt.(io.Closer).Close()
	}()
	nn, e = bw.Write(data)
	if e != nil {
		os.Remove(path)
		return nn, errors.WithStack(
			errors.WithMessage(e, fmt.Sprintf("failed to write bytes to %s", path)))
	}
	return
}
