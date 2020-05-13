//
//  clang.c
//  manage
//
//  Created by 王迎宾 on 2020/5/8.
//  Copyright © 2020 王迎宾. All rights reserved.
//

#include "manage.h"
#include "clang.h"

char* callbackFun(char* msg);

extern char* macosDoCmd(char*);

// 设置回调函数
void setCallback() {
    CallBackFun(callbackFun);
}

// 回调函数
char* callbackFun(char* msg) {
    return macosDoCmd(msg);
}
