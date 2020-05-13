package main

/*
	#include <stdlib.h>
	#include "clang.h"
*/
import "C"
import (
	"bjmes/tools/manage/cmd"
	"strings"
	"unsafe"
)

func main() {
	cmd.CallBack = Callback
}

//export Cmd
func Cmd(s string) *C.char {
	// 去除最后无用字符'\x00'
	// C语言中字符串会存在\x00表示字符串结尾
	ret, err := cmd.Do(strings.TrimRight(s, string('\x00')))
	if err != nil {
		return C.CString("E" + err.Error())
	}
	return C.CString("S" + ret)
}

// C回调函数
func Callback(s string) string {
	d := C.CString(s)
	ret := C.doCmd(d)
	goString := C.GoString(ret)
	C.free(unsafe.Pointer(d))
	C.free(unsafe.Pointer(ret))
	return goString
}
