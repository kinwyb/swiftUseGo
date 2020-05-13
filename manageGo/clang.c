#include "clang.h"

CmdCallBack _cmdCallbackFun;

void CallBackFun(CmdCallBack back) {
    _cmdCallbackFun = back;
}

char* doCmd(char* msg) {
    if(_cmdCallbackFun) {
        return _cmdCallbackFun(msg);
    }
    return "";
}