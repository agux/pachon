package getd

import "testing"

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
