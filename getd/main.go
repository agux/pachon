package getd

import (
	"math/rand"
	"time"

	"github.com/agux/pachon/global"
	"github.com/agux/pachon/model"
)

var (
	dbmap    = global.Dbmap
	dot      = global.Dot
	log      = global.Log
	registry = make(map[model.DataSource]klineFetcher)
)

func init() {
	rand.Seed(time.Now().UnixNano())
}

func registerKlineFetcher(src model.DataSource, kf klineFetcher) {
	registry[src] = kf
}
