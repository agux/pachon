package util

import (
	"net/http"
	"testing"
)

func TestHTTPGet(t *testing.T) {
	type args struct {
		link    string
		headers map[string]string
		px      *Proxy
		cookies []*http.Cookie
	}
	tests := []struct {
		name    string
		args    args
		wantRes *http.Response
		wantErr bool
	}{
		{
			name: "tc1",
			args: args{
				link: "http://www.google.com",
				px: &Proxy{
					Host: "127.0.0.1",
					Port: "1080",
					Type: "socks5",
				},
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			gotRes, err := HTTPGet(tt.args.link, tt.args.headers, tt.args.px, tt.args.cookies...)
			log.Debugf("err: %+v", err)
			log.Debugf("%+v", gotRes)
			// if (err != nil) != tt.wantErr {
			// 	t.Errorf("HTTPGet() error = %v, wantErr %v", err, tt.wantErr)
			// 	return
			// }
			// if !reflect.DeepEqual(gotRes, tt.wantRes) {
			// 	t.Errorf("HTTPGet() = %v, want %v", gotRes, tt.wantRes)
			// }
		})
	}
}
