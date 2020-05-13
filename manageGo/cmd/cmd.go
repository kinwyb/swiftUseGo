package cmd

import (
	"encoding/json"
	"errors"
	"fmt"
)

var cmdMap = map[int64]ICmd{}

var CallBack func(s string) string = nil

//命令ID
const (
	initConfigID     int64 = 1 //加载配置
	dyemCheckGroupID int64 = 2 //查询数据
)

// 命令结构
type Data struct {
	CmdID int64  `description:"命令ID"`
	Data  string `description:"命令参数"`
}

// 命令结构
type ICmd interface {
	ID() int64
	Do(string) (string, error)
}

func RegisterCmd(cmd ICmd) {
	if cmd != nil {
		cmdMap[cmd.ID()] = cmd
	}
}

func init() {
	RegisterCmd(configCmd{})
	RegisterCmd(dyemCheckGroupCmd{})
}

// 处理命令
func Do(cmdJson string) (string, error) {
	cmd := &Data{}
	err := json.Unmarshal([]byte(cmdJson), cmd)
	if err != nil {
		return "", fmt.Errorf("json解析失败:%w", err)
	}
	cmdDo := cmdMap[cmd.CmdID]
	if cmdDo == nil {
		return "", errors.New("命令不存在")
	}
	ret, e := cmdDo.Do(cmd.Data)
	if e != nil {
		return "", e
	}
	return ret, nil
}

// 解码
func unmarshal(data []byte, v interface{}) error {
	return json.Unmarshal(data, v)
}

// 编码
func marshal(v interface{}) ([]byte, error) {
	return json.Marshal(v)
}
