package chrome

import (
	"fmt"
	"reflect"

	"github.com/agux/pachon/conf"
	"github.com/agux/pachon/global"
	"github.com/agux/pachon/util"
	"github.com/chromedp/chromedp"
)

var log = global.Log

//AllocatorOptions creates a slice of chromedp.ExecAllocatorOption pre-configured
//with provided proxy (if any) and parameters from configuration file.
func AllocatorOptions(px *util.Proxy) (o []chromedp.ExecAllocatorOption) {
	if px != nil {
		p := fmt.Sprintf("%s://%s:%s", px.Type, px.Host, px.Port)
		log.Debugf("using proxy: %s", p)
		o = append(o, chromedp.ProxyServer(p))
	}
	if ua, e := util.PickUserAgent(); e != nil {
		log.Fatalf("failed to pick user agents from the pool: %+v", e)
	} else {
		o = append(o, chromedp.UserAgent(ua))
	}
	if conf.Args.ChromeDP.NoImage {
		o = append(o, chromedp.Flag("blink-settings", "imagesEnabled=false"))
	}

	for _, opt := range chromedp.DefaultExecAllocatorOptions {
		if reflect.ValueOf(chromedp.Headless).Pointer() == reflect.ValueOf(opt).Pointer() {
			if conf.Args.ChromeDP.Headless {
				log.Debug("headless mode is enabled")
			} else {
				log.Debug("ignored headless mode")
				continue
			}
		}
		o = append(o, opt)
	}
	return
}
