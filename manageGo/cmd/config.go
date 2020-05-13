package cmd

import (
	"errors"
	"fmt"
	"io/ioutil"
	"strings"
)

var configData = &config{}

const configFile = "./config.json"

type config struct {
	Api  string `description:"Api地址"`
	User string `description:"用户"`
	Pwd  string `description:"密码"`
}

func (c *config) load() error {
	// 读取配置文件
	data, err := ioutil.ReadFile(configFile)
	if err != nil {
		return errors.New("配置文件加载失败")
	}
	err = unmarshal(data, c)
	if err != nil {
		return err
	}
	return nil
}

func (c *config) save() error {
	data, err := marshal(c)
	if err != nil {
		return err
	}
	return ioutil.WriteFile(configFile, data, 0777)
}

type configCmd struct{}

func (c configCmd) ID() int64 {
	return initConfigID
}

func (c configCmd) Do(s string) (string, error) {
	// 解析配置文件
	var err error
	if s != "" {
		err = unmarshal([]byte(s), configData)
		if err == nil {
			configData.save()
		}
	} else {
		err = configData.load()
		data, _ := marshal(configData)
		s = string(data)
	}
	if err != nil {
		return "", err
	}
	return s, initConfig()
}

func initConfig() error {
	if configData.Api != "" || !strings.HasPrefix(configData.Api, "http") {
		return errors.New("输入有效的接口地址")
	}
	err := loginUser(configData.User, configData.Pwd)
	if err != nil {
		return fmt.Errorf("登录失败%w", err)
	}
	return nil
}
