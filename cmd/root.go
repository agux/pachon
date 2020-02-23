package cmd

import (
	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "pachon",
	Short: "Pachon is a tool for China A-share market data mining, engineering and analysis.",
	Long:  `Please provide subcommand to take further actions.`,
}

//Execute is the entrance of this command-line framework
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		panic(err)
	}
}
