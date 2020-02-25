package cmd

import (
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(versionCmd)
}

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Print the version number of Stock",
	Run: func(cmd *cobra.Command, args []string) {
		log.Print("Pachon v0.1.0")
	},
}
