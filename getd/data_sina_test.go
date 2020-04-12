package getd

import (
	"database/sql"
	"testing"

	"github.com/agux/pachon/model"
)

func TestSinaKlineFetcher_fetchKline(t *testing.T) {
	type args struct {
		stk  *model.Stock
		fr   FetchRequest
		incr bool
	}
	tests := []struct {
		name      string
		s         *SinaKlineFetcher
		args      args
		wantTdmap map[FetchRequest]*model.TradeData
		wantSuc   bool
		wantRetry bool
	}{
		{
			name: "First Test",
			args: args{
				stk: &model.Stock{
					Code:   "HSI",
					Market: sql.NullString{String: "HK", Valid: true},
				},
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &SinaKlineFetcher{}
			s.fetchKline(tt.args.stk, tt.args.fr, tt.args.incr)
		})
	}
}
