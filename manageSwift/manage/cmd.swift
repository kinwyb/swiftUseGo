//
//  cmd.swift
//  manage
//
//  Created by 王迎宾 on 2020/5/10.
//  Copyright © 2020 王迎宾. All rights reserved.
//

import Foundation


//自定义一个JSON协议
protocol JSONToString: Codable {
    func toJSONString() -> String?
}

//扩展协议方法
extension JSONToString {
    
    //将数据转成可用的JSON模型
    func toJSONString() -> String? {
        //encoded对象
        if let encodedData = try? JSONEncoder().encode(self) {
            //从encoded对象获取String
            return String(data: encodedData, encoding: .utf8)
        }
        return nil
    }
}

// 解析json数据
func JSONStringDecode<T>(jsonString:String,_ type: T.Type) -> T? where T : Decodable {
    return try? JSONDecoder().decode(type, from: jsonString.data(using: .utf8)!)
}

@_silgen_name("macosDoCmd")
func cmd(_ arg: UnsafePointer<Int8>!) -> UnsafeMutablePointer<Int8>! {
    let ret = String.init(utf8String: arg)!
    let x = ret[ret.index(after: ret.startIndex)...]
    let data = ("swift "+x).cString(using: String.Encoding.utf8)
    let req = strdup(data)
    return req
}

struct CmdData : JSONToString {
    
    let cmdID : Int?
    let data : String?
    
    enum CodingKeys: String, CodingKey {
        case cmdID = "CmdID"
        case data = "Data"
    }
    
    init(cmdID:Int,data:String) {
        self.cmdID = cmdID
        self.data = data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cmdID = try values.decodeIfPresent(Int.self, forKey: .cmdID)
        data = try values.decodeIfPresent(String.self, forKey: .data)
    }
    
}

// 错误结构
class CmdErr {
    var Msg:String
    init(msg:String) {
        Msg=msg
    }
}

// 调用golang代码,请求返回都是json编码的字符串
func doCmd(data: JSONToString)->(String?,CmdErr?) {
    let arg = data.toJSONString()
    if arg == nil {
        return (nil,CmdErr(msg: "json序列化失败"))
    }
    let data = arg!.cString(using: String.Encoding.utf8)
    let req = strdup(data)
    let retMsg = Cmd(GoString(p: req, n: data!.count))
    req?.deallocate() //释放内存
    if retMsg == nil {
        return (nil,CmdErr(msg: "请求失败"))
    }
    let ret = String.init(utf8String: retMsg!)!
    retMsg?.deallocate() //释放内存
    let status = ret[...ret.startIndex]
    let msg = ret[ret.index(after: ret.startIndex)...]
    if status.description == "E" {
        return (nil,CmdErr(msg: msg.description))
    }
    return (msg.description,nil)
}

// 所有命令ID枚举
enum CmdID:Int {
    case initConfig = 1 //加载配置
    case dyemCheckGroupID = 2 //查询同步数据
    case dyemCheckDgID  = 3 //校验吊挂数据
    case dyemCheckBdID  = 4 //校验博大数据
}
