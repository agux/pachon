package util

import (
	"math/rand"
	"time"

	"github.com/agux/pachon/global"
)

var log = global.Log

func init() {
	rand.Seed(time.Now().UnixNano())
}
