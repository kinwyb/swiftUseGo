package cmd

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/valyala/fasthttp"
	"net/http"
	"time"
)

var token = ""

var httpClient *fasthttp.Client

func init() {
	timeout := 10 * time.Minute
	httpClient = &fasthttp.Client{
		ReadTimeout:        timeout,
		WriteTimeout:       timeout,
		MaxConnWaitTimeout: time.Minute,
	}
}

// 返回结构,用于swagger文档解析
type apiStringResponse struct {
	Code   int64  `description:"错误编码" json:"code"`
	ErrMsg string `description:"错误描述" json:"errmsg,omitempty"`
	Err    string `description:"错误内容" json:"err,omitempty"`
	Data   string `description:"内容" json:"data"`
}

// 获取一个请求
func getRequestJSON(url string, method string, body []byte) (*fasthttp.Request, error) {
	ret := fasthttp.AcquireRequest()
	ret.SetRequestURI(url)
	ret.Header.SetContentType("application/json")
	ret.Header.SetMethod(method)
	if token != "" {
		ret.Header.Add("token", token)
	}
	if body != nil {
		n, err := ret.BodyWriter().Write(body)
		if err != nil {
			fasthttp.ReleaseRequest(ret)
			return nil, err
		} else if n != len(body) {
			fasthttp.ReleaseRequest(ret)
			return nil, errors.New("body写入内容不准确")
		}
	}
	return ret, nil
}

// 获取一个请求
func getRequestGet(url string) *fasthttp.Request {
	ret := fasthttp.AcquireRequest()
	ret.SetRequestURI(url)
	ret.Header.SetMethod(fasthttp.MethodGet)
	if token != "" {
		ret.Header.Add("token", token)
	}
	return ret
}

// 登录用户
func loginUser(userName string, password string) error {
	url := configData.Api + "/login?username=" + userName + "&password=" + password
	req, err := getRequestJSON(url, fasthttp.MethodPost, nil)
	if err != nil {
		return err
	}
	defer fasthttp.ReleaseRequest(req)
	resp := fasthttp.AcquireResponse()
	defer fasthttp.ReleaseResponse(resp)
	err = httpClient.Do(req, resp)
	if err != nil {
		return err
	} else if resp.StatusCode() != http.StatusOK {
		return fmt.Errorf("请求异常:%d", resp.StatusCode())
	}
	result := apiStringResponse{}
	err = json.Unmarshal(resp.Body(), &result)
	if err != nil {
		return err
	} else if result.Code != 0 {
		return fmt.Errorf("请求失败:%s", result.ErrMsg)
	}
	token = result.Data //获取到token
	return nil
}
