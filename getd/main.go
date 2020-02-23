package getd

import (
	"math/rand"
	"time"

	"github.com/agux/pachon/global"
)

var (
	dbmap = global.Dbmap
	dot   = global.Dot
	log = global.Log
)

func init() {
	rand.Seed(time.Now().UnixNano())
}
