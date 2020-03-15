package cmd

import (
	"strings"
	"time"

	"github.com/agux/pachon/conf"
	"github.com/agux/pachon/getd"
	"github.com/agux/pachon/sampler"
	"github.com/spf13/cobra"
)

var (
	sampleTargets []string
	tagTargets    []string
	tagSets       []string
)

func init() {
	sampleCmd.Flags().StringSliceVarP(&sampleTargets, "target", "t", nil,
		"specify sampling targets. Valid targets include: kpts, xcorl, wcc")
	sampleCmd.Flags().StringSliceVar(&tagTargets, "tag", nil,
		"specify sampling targets to tag. Valid targets include: kpts, xcorl, wcc")
	sampleCmd.Flags().StringSliceVar(&tagSets, "sets", []string{"test", "train"},
		"specify data sets to tag. Valid sets include: test, train")

	sampleCmd.AddCommand(wccCmd)

	rootCmd.AddCommand(sampleCmd)
}

var sampleCmd = &cobra.Command{
	Use:   "sample",
	Short: "Sampling retrieved data.",
	Run: func(cmd *cobra.Command, args []string) {
		for _, t := range sampleTargets {
			switch strings.ToLower(t) {
			case "kpts":
				stkps := time.Now()
				sampler.SampAllKeyPoints()
				getd.StopWatch("KEY_POINT_SAMPLING", stkps)
			case "xcorl":
				s := time.Now()
				sampler.CalXCorl(nil)
				getd.StopWatch("XCORL", s)
			case "wcc":
				s := time.Now()
				sampler.CalWcc(nil)
				getd.StopWatch("WCC", s)
			default:
				log.Panicf("unsupported sampling target: %s", t)
			}
		}
		ts, tr := false, false
		for _, s := range tagSets {
			switch strings.ToLower(s) {
			case "test":
				ts = true
			case "train":
				tr = true
			default:
				log.Panicf("unsupported data set for tagging: %s", s)
			}
		}
		for _, t := range tagTargets {
			switch strings.ToLower(t) {
			case "kpts":
				frames := conf.Args.Sampler.GraderTimeFrames
				if ts {
					for _, f := range frames {
						log.Printf("tagging kpts%d data for test set...", f)
						e := sampler.TagTestSetByIndustry(f, conf.Args.Sampler.TestSetBatchSize)
						if e != nil {
							log.Fatal(e)
						}
					}
				}
				if tr {
					bsize := conf.Args.Sampler.TrainSetBatchSize
					for _, f := range frames {
						log.Printf("tagging kpts%d data for training set, batch size: %d", f, bsize)
						e := sampler.TagTrainingSetByScore(f, bsize)
						if e != nil {
							log.Fatal(e)
						}
					}
				}
			case "xcorl":
				if ts {
					e := sampler.TagCorlTrn(sampler.XcorlTrn, sampler.TestFlag)
					if e != nil {
						log.Fatal(e)
					}
				}
				if tr {
					e := sampler.TagCorlTrn(sampler.XcorlTrn, sampler.TrainFlag)
					if e != nil {
						log.Fatal(e)
					}
				}
			case "wcc":
				if ts {
					e := sampler.TagCorlTrn(sampler.WccTrn, sampler.TestFlag)
					if e != nil {
						log.Fatal(e)
					}
				}
				if tr {
					e := sampler.TagCorlTrn(sampler.WccTrn, sampler.TrainFlag)
					if e != nil {
						log.Fatal(e)
					}
				}
			default:
				log.Panicf("unsupported target for tagging: %s", t)
			}
		}
	},
}
