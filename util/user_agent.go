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
		if a.UserAgent.Valid {
			agentPool = append(agentPool, a.UserAgent.String)
		}
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
	ID                   int             `db:"id"`
	Source               sql.NullString  `db:"source"`
	UserAgent            sql.NullString  `db:"user_agent"`
	TimesSeen            sql.NullInt64   `db:"times_seen"`
	Percent              sql.NullFloat64 `db:"percent"`
	SimpleSoftwareString sql.NullString  `db:"simple_software_string"`
	SoftwareName         sql.NullString  `db:"software_name"`
	SoftwareVersion      sql.NullString  `db:"software_version"`
	SoftwareType         sql.NullString  `db:"software_type"`
	SoftwareSubType      sql.NullString  `db:"software_sub_type"`
	HardWareType         sql.NullString  `db:"hardware_type"`
	FirstSeenAt          sql.NullString  `db:"first_seen_at"`
	LastSeenAt           sql.NullString  `db:"last_seen_at"`
	UpdatedAt            sql.NullString  `db:"updated_at"`
}
