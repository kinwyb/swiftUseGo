# swiftUseGo
swift通过C接口调用go代码

## Go构建C库
go build -buildmode=c-archive -o manage.a

## swift导入.a文件
tagets -> build phases -> link binary with libraries -> + 