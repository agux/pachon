package main

import (
	"strings"

	"github.com/agux/pachon/cmd"
	"github.com/agux/pachon/conf"
	"github.com/pkg/profile"
	"github.com/sirupsen/logrus"

	"github.com/agux/pachon/global"
)

var log = global.Log

func main() {
	defer func() {
		code := 0
		if r := recover(); r != nil {
			if _, hasError := r.(error); hasError {
				code = 1
			}
		}
		logrus.Exit(code)
	}()

	log.Info("starting...")
	log.Infof("config file used: %s", conf.ConfigFileUsed())

	switch strings.ToLower(conf.Args.Profiling) {
	case "cpu":
		defer profile.Start().Stop()
	case "mem":
		defer profile.Start(profile.MemProfile).Stop()
	}

	cmd.Execute()
}
