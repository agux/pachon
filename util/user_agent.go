package util

import (
	"database/sql"
	"errors"
	"math/rand"
	"sync"
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
		e = errors.New("user_agents table is empty. try to populate this table with some valid entries")
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
