package cmd

import (
	"bjmes/src/beans/customer"
	"bjmes/src/common"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/valyala/fasthttp"
	"strings"
	"time"
)

// 产量校验

type dyemCheckGroupApiResult struct {
	Code   int64                     `description:"错误编码" json:"code"`
	ErrMsg string                    `description:"错误描述" json:"errmsg,omitempty"`
	Err    string                    `description:"错误内容" json:"err,omitempty"`
	Data   []*customer.DyemDataGroup `description:"内容" json:"data"`
}

type dyemCheckGroupCmd struct{}

func (d dyemCheckGroupCmd) ID() int64 {
	return dyemCheckGroupID
}

func (d dyemCheckGroupCmd) Do(s string) (string, error) {
	ss := strings.Split(s, "|")
	if len(ss) < 1 {
		now := time.Now()
		ss = append(ss,
			now.AddDate(0, 0, -7).Format(common.DateFormat),
			now.Format(common.DateFormat))
	} else if len(ss) < 2 {
		ss = append(ss, time.Now().Format(common.DateFormat))
	}
	url := configData.Api + "/dyemCheckGroup?startDate=" + ss[0] + "&endDate=" + ss[1]
	req := getRequestGet(url)
	defer fasthttp.ReleaseRequest(req)
	resp := fasthttp.AcquireResponse()
	defer fasthttp.ReleaseResponse(resp)
	err := httpClient.Do(req, resp)
	if err != nil {
		return "", fmt.Errorf("接口请求失败:%s", err.Error())
	}
	result := &dyemCheckGroupApiResult{}
	err = json.Unmarshal(resp.Body(), result)
	if err != nil {
		return "", fmt.Errorf("API结果解析失败%s", err.Error())
	}
	if result.Code != 0 {
		return "", errors.New(result.ErrMsg)
	}
	data, err := marshal(result.Data)
	if err != nil {
		return "", err
	}
	return string(data), nil
}