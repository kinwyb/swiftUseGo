package cmd

import "testing"

func TestDyemCheckDgCmd_Do(t *testing.T) {
	cmd := dyemCheckDgCmd{}
	data, e := cmd.Do("2020-05-08")
	if e != nil {
		t.Fatal(e)
	}
	t.Log(data)
}
