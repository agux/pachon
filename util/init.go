package util

import (
	"math/rand"
	"time"

	"github.com/agux/pachon/global"
)

var (
	log   = global.Log
	dbmap = global.Dbmap
)

func init() {
	rand.Seed(time.Now().UnixNano())
}
