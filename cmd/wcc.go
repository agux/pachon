package cmd

import (
	"os"

	"github.com/agux/pachon/sampler"
	"github.com/spf13/cobra"
)

var (
	expInferFile, upload, nocache, overwrite, del, chron bool
	localPath, rbase, tasklog, targetPath                string
)

func init() {
	pcalWccCmd.Flags().BoolVarP(&expInferFile, "exp", "e", true,
		"Specify whether to export inference file")
	pcalWccCmd.Flags().BoolVarP(&upload, "upload", "u", true,
		"Specify whether to upload inference file.")
	pcalWccCmd.Flags().BoolVarP(&nocache, "nocache", "n", true,
		"Specify whether to delete local exported file after successful upload")
	pcalWccCmd.Flags().BoolVarP(&overwrite, "overwrite", "o", true,
		"Specify whether to overwrite existing files on cloud storage.")
	pcalWccCmd.Flags().StringVarP(&localPath, "path", "p", os.TempDir(),
		"Specify local directory for exported inference file")
	pcalWccCmd.Flags().StringVar(&rbase, "rbase", "",
		"Specify remote base directory to upload the exported file"+
			"(the relative path after the gs://[bucket_name] segment).")

	expWccCmd.Flags().BoolVarP(&upload, "upload", "u", true,
		"Specify whether to upload inference file.")
	expWccCmd.Flags().BoolVarP(&nocache, "nocache", "n", true,
		"Specify whether to delete local exported file after successful upload")
	expWccCmd.Flags().BoolVarP(&overwrite, "overwrite", "o", true,
		"Specify whether to overwrite existing files on cloud storage.")
	expWccCmd.Flags().BoolVarP(&chron, "chron", "c", false,
		"Specify whether to export in chronological order. Default to export in ascending stock code order.")
	expWccCmd.Flags().StringVarP(&localPath, "path", "p", os.TempDir(),
		"Specify local directory for exported inference file")
	expWccCmd.Flags().StringVar(&rbase, "rbase", "",
		"Specify remote base directory to upload the exported file"+
			"(the relative path after the gs://[bucket_name] segment).")

	impWccCmd.Flags().StringVarP(&tasklog, "tasklog", "t", "wccir_tasklog",
		"Specify tasklog file for wcc inference result import.")
	impWccCmd.Flags().StringVarP(&targetPath, "path", "p", "",
		"Specify local or google cloud storage path where the wcc inference result file resides.")
	impWccCmd.Flags().BoolVarP(&del, "del", "d", false,
		"Specify whether to delete remote inference result file after importing.")

	wccCmd.AddCommand(updateWccCmd)
	wccCmd.AddCommand(stzWccCmd)
	wccCmd.AddCommand(pcalWccCmd)
	wccCmd.AddCommand(expWccCmd)
	wccCmd.AddCommand(impWccCmd)
}

var wccCmd = &cobra.Command{
	Use:   "wcc",
	Short: "Process Warping Correlation Coefficient sampling.",
}

var updateWccCmd = &cobra.Command{
	Use:   "update",
	Short: "Update fields in the wcc_trn table.",
	Run: func(cmd *cobra.Command, args []string) {
		sampler.UpdateWcc()
	},
}

var stzWccCmd = &cobra.Command{
	Use:   "stz",
	Short: "Standardize corl value in the wcc_trn table.",
	Run: func(cmd *cobra.Command, args []string) {
		sampler.StzWcc()
	},
}

var pcalWccCmd = &cobra.Command{
	Use:     "pcal",
	Short:   "Pre-calculate eligible wcc and optionally export and upload inference file for cloud inference.",
	Example: "stock sample wcc pcal -p /Volumes/WD-1TB/wcc_infer --rbase wcc_infer",
	Run: func(cmd *cobra.Command, args []string) {
		sampler.PcalWcc(expInferFile, upload, nocache, overwrite, localPath, rbase)
	},
}

var expWccCmd = &cobra.Command{
	Use:     "exp",
	Short:   "Export eligible wcc inference file and optionally upload it for cloud inference.",
	Example: "stock sample wcc exp -p /Volumes/WD-1TB/wcc_infer --rbase wcc_infer",
	Run: func(cmd *cobra.Command, args []string) {
		sampler.ExpInferFile(localPath, rbase, upload, nocache, overwrite, chron)
	},
}

var impWccCmd = &cobra.Command{
	Use:     "imp",
	Short:   "Import WCC inference result file from local or remote.",
	Example: "stock sample wcc imp -t wccir_tasklog -p gs://carusytes_bucket/wcc_infer_results",
	Run: func(cmd *cobra.Command, args []string) {
		sampler.ImpWcc(tasklog, targetPath, del)
	},
}
