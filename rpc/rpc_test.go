package rpc

import (
	"testing"

	"github.com/agux/pachon/util"
)

func TestWordCount(t *testing.T) {
	service := "GTest.WordCount"
	var rep bool
	e := Call(service, "", &rep, 3)
	util.CheckErr(e, "failed word count")
}
