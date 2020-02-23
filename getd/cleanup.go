package getd

import "github.com/agux/pachon/conf"

//Cleanup cleans up any resources allocated for the program, including processes running outside of this one.
func Cleanup() {
	switch conf.Args.DataSource.Kline {
	case conf.THS:
		cleanupTHS()
	}
}
