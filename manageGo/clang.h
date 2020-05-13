typedef char* (*CmdCallBack)(char*);

char* doCmd(char* msg);

void CallBackFun(CmdCallBack back);