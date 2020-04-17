package getd

import (
	"testing"

	"github.com/agux/pachon/model"
)

func TestGetIndexList(t *testing.T) {
	tests := []struct {
		name string
	}{
		{
			name: "Basic",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			GetIndexList()
		})
	}
}

func TestGetIndicesV2(t *testing.T) {
	type args struct {
		isValidate bool
	}
	tests := []struct {
		name       string
		args       args
		wantIdxlst []*model.IdxLst
		wantSuclst []*model.IdxLst
	}{
		{
			name: "Basic",
			args: args{
				isValidate: true,
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			GetIndicesV2(tt.args.isValidate)
		})
	}
}
