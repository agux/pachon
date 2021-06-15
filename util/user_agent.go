package util

import (
	"archive/tar"
	"compress/gzip"
	"database/sql"
	"encoding/csv"
	"errors"
	"fmt"
	"io"
	"math/rand"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"

	"github.com/agux/pachon/conf"
	"github.com/agux/pachon/global"
	"github.com/ssgreg/repeat"
)

var (
	agentPool []string
	uaLock    = sync.RWMutex{}
)

//PickUserAgent picks a user agent string from the pool randomly.
//if the pool is not populated, it will trigger the initialization process
//to fetch user agent lists from remote server.
func PickUserAgent() (ua string, e error) {
	uaLock.Lock()
	defer uaLock.Unlock()

	if len(agentPool) > 0 {
		return agentPool[rand.Intn(len(agentPool))], nil
	}
	//first, load from database
	agents := loadUserAgents()
	if len(agents) == 0 {
		e = errors.New("user_agents table is empty. try to populate this table with some valid entries.")
		log.Warn(e)
		return
	}
	for _, a := range agents {
		agentPool = append(agentPool, a.UserAgent)
	}
	return agentPool[rand.Intn(len(agentPool))], nil
}

func loadUserAgents() (agents []*UserAgent) {
	_, e := dbmap.Select(&agents, "select * from user_agents where user_agent is not null")
	if e != nil {
		if sql.ErrNoRows != e {
			log.Panicln("failed to run sql", e)
		}
	}
	return
}

func mergeAgents(agents []*UserAgent) (e error) {
	fields := []string{
		"id", "user_agent", "times_seen", "simple_software_string", "software_name", "software_version", "software_type",
		"software_sub_type", "hardware_type", "first_seen_at", "last_seen_at", "updated_at",
	}
	numFields := len(fields)
	holders := make([]string, numFields)
	for i := range holders {
		holders[i] = "?"
	}
	holderString := fmt.Sprintf("(%s)", strings.Join(holders, ","))
	valueStrings := make([]string, 0, len(agents))
	valueArgs := make([]interface{}, 0, len(agents)*numFields)
	for _, a := range agents {
		valueStrings = append(valueStrings, holderString)
		valueArgs = append(valueArgs, a.ID)
		valueArgs = append(valueArgs, a.UserAgent)
		valueArgs = append(valueArgs, a.TimesSeen)
		valueArgs = append(valueArgs, a.SimpleSoftwareString)
		valueArgs = append(valueArgs, a.SoftwareName)
		valueArgs = append(valueArgs, a.SoftwareVersion)
		valueArgs = append(valueArgs, a.SoftwareType)
		valueArgs = append(valueArgs, a.SoftwareSubType)
		valueArgs = append(valueArgs, a.HardWareType)
		valueArgs = append(valueArgs, a.FirstSeenAt)
		valueArgs = append(valueArgs, a.LastSeenAt)
		valueArgs = append(valueArgs, a.UpdatedAt)
	}

	var updFieldStr []string
	for _, f := range fields {
		if "id" == f {
			continue
		}
		updFieldStr = append(updFieldStr, fmt.Sprintf("%[1]s=values(%[1]s)", f))
	}

	retry := 5
	rt := 0
	stmt := fmt.Sprintf("INSERT INTO user_agents (%s) VALUES %s on duplicate key update %s",
		strings.Join(fields, ","), strings.Join(valueStrings, ","), strings.Join(updFieldStr, ","))
	for ; rt < retry; rt++ {
		_, e = dbmap.Exec(stmt, valueArgs...)
		if e != nil {
			log.Error(e)
			if strings.Contains(e.Error(), "Deadlock") {
				continue
			} else {
				log.Panicln("failed to merge user_agent", e)
			}
		}
		return nil
	}
	log.Panicln("failed to merge user_agent", e)
	return
}

func readCSV(src string) (agents []*UserAgent, err error) {
	f, err := os.Open(src)
	if err != nil {
		return
	}
	defer f.Close()

	gzf, err := gzip.NewReader(f)
	if err != nil {
		return
	}

	tarReader := tar.NewReader(gzf)

	for {
		var header *tar.Header
		header, err = tarReader.Next()
		if err == io.EOF {
			return
		} else if err != nil {
			return
		}

		name := header.Name

		switch header.Typeflag {
		case tar.TypeDir:
			continue
		case tar.TypeReg:
			if !strings.EqualFold(".csv", filepath.Ext(name)) {
				continue
			}
		default:
			continue
		}

		csvReader := csv.NewReader(tarReader)
		var lines [][]string
		lines, err = csvReader.ReadAll()
		if err != nil {
			return
		}

		for i, ln := range lines {
			if i == 0 {
				//skip header line
				continue
			}
			agents = append(agents, &UserAgent{
				ID:                   ln[0],
				UserAgent:            ln[1],
				TimesSeen:            ln[2],
				SimpleSoftwareString: ln[3],
				SoftwareName:         ln[7],
				SoftwareVersion:      ln[10],
				SoftwareType:         ln[22],
				SoftwareSubType:      ln[23],
				HardWareType:         ln[25],
				FirstSeenAt:          ln[35],
				LastSeenAt:           ln[36],
				UpdatedAt:            time.Now().Format(global.DateTimeFormat),
			})
		}
		break
	}
	return
}

func downloadFile(filepath string, url string) (err error) {

	// Create the file
	out, err := os.Create(filepath)
	if err != nil {
		return err
	}
	defer out.Close()

	// Get the data
	var resp *http.Response
	op := func(c int) error {
		resp, err = http.Get(url)
		return repeat.HintTemporary(err)
	}
	err = repeat.Repeat(
		repeat.FnWithCounter(op),
		repeat.StopOnSuccess(),
		repeat.LimitMaxTries(conf.Args.DefaultRetry),
		repeat.WithDelay(
			repeat.FullJitterBackoff(500*time.Millisecond).WithMaxDelay(10*time.Second).Set(),
		),
	)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	// Check server response
	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("bad status: %s", resp.Status)
	}

	// Writer the body to file
	_, err = io.Copy(out, resp.Body)
	if err != nil {
		return err
	}

	return nil
}

//UserAgent represents user_agent table structure.
type UserAgent struct {
	ID                   string
	UserAgent            string `db:"user_agent"`
	TimesSeen            string `db:"times_seen"`
	SimpleSoftwareString string `db:"simple_software_string"`
	SoftwareName         string `db:"software_name"`
	SoftwareVersion      string `db:"software_version"`
	SoftwareType         string `db:"software_type"`
	SoftwareSubType      string `db:"software_sub_type"`
	HardWareType         string `db:"hardware_type"`
	FirstSeenAt          string `db:"first_seen_at"`
	LastSeenAt           string `db:"last_seen_at"`
	UpdatedAt            string `db:"updated_at"`
}
