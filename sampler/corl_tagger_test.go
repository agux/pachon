package sampler

import (
	"math/rand"
	"testing"

	"github.com/jfcg/sorty"
)

func TestSorty(t *testing.T) {
	records := rand.Perm(1000)
	log.Debugf("%+v", records)
	lsw := func(i, k, r, s int) bool {
		if records[i] < records[k] {
			if r != s {
				records[r], records[s] = records[s], records[r]
			}
			return true
		}
		return false
	}
	sorty.Sort3(len(records), lsw)
	log.Debugf("%+v", records)
}

func TestPassArray(t *testing.T) {
	arr := []int{
		5, 4, 3, 2, 1,
	}
	log.Debugf("%+v", arr)
	shuffle(arr)
	log.Debugf("%+v", arr)
}

func shuffle(arr []int) {
	arr[0], arr[1], arr[3], arr[4] = arr[4], arr[3], arr[1], arr[0]
}
