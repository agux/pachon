package sampler

import (
	"fmt"
	"strings"
	"testing"

	"github.com/agux/pachon/model"
)

func Test_calWcc(t *testing.T) {
	stocks := new(model.Stocks)
	stocks.Add(&model.Stock{
		Code: "600104",
		Name: "上汽集团",
	})
	CalWcc(stocks)
}

func Test_PrintIntSlice(t *testing.T) {
	ss := []int{1, 2, 3, 4, 5}
	log.Debugf("the slice: %v", strings.ReplaceAll(strings.Trim(fmt.Sprint(ss), "[]"), " ", ","))
}
