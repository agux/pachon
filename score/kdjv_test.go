package score

import (
	"testing"
	"log"
	"fmt"
)

func TestKdjv_SyncRemoteKdjFd(t *testing.T) {
	kdjv := new(KdjV)
	suc := kdjv.SyncKdjFeatDat()
	if !suc {
		log.Printf("KDJ FeatDat Sync Failed.")
	}
}

func TestKdjV_RenewStats(t *testing.T) {
	new(KdjV).RenewStats(false, "000836")
	//kdjv := new(KdjV)
	//kdjv.RenewStats(false)
	//kdjv.RenewStats(false)
}

func TestKdjV_Get(t *testing.T) {
	r := new(KdjV).Get([]string{"000836"}, -1, false)
	fmt.Println(r)
}
