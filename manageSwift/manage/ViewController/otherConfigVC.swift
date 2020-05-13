//
//  otherConfigVC.swift
//  manage
//
//  Created by 王迎宾 on 2020/5/7.
//  Copyright © 2020 王迎宾. All rights reserved.
//

import Cocoa


// 配置数据
class configData : NSObject, JSONToString {
    
    @objc dynamic var api : String?
    @objc dynamic var user : String?
    @objc dynamic var pwd : String?
    
    enum CodingKeys: String, CodingKey {
        case api = "Api"
        case user = "User"
        case pwd = "Pwd"
    }
    
    override init() {
        api = ""
        user = ""
        pwd = ""
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        api = try values.decodeIfPresent(String.self, forKey: .api)
        user = try values.decodeIfPresent(String.self, forKey: .user)
        pwd = try values.decodeIfPresent(String.self, forKey: .pwd)
    }
    
}

class otherConfigVC: NSViewController {

    @objc dynamic var config = configData.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cmd = CmdData.init(cmdID: CmdID.initConfig.rawValue, data: "")
        let (jsonString,e) = doCmd(data: cmd)
        if e != nil {
            config.api = ""
            config.user = "admin"
            config.pwd = ""
        } else {
            let config = JSONStringDecode(jsonString: jsonString!, configData.self)
            if config != nil {
                self.config.api = config?.api
                self.config.user = config?.user
                self.config.pwd = config?.pwd
            }
        }
    }
    @IBAction func saveBtnClick(_ sender: Any) {
        let cfgJson = config.toJSONString()
        if cfgJson == nil {
            showAlert(title: "失败", msg: "参数序列化失败", icon: nil)
            return
        }
        let cmd = CmdData.init(cmdID: CmdID.initConfig.rawValue, data: cfgJson!)
        let (_,e) = doCmd(data: cmd)
        if e == nil {
            let cwc = self.view.window?.windowController as! configWC
            if cwc.isInit {
                NotificationCenter.default.post(name: NSNotification.Name.showMainWindow, object: nil)
                self.view.window?.close()
            }
        } else {
            showAlert(title: "", msg: e!.Msg, icon:nil,style: NSAlert.Style.critical)
        }
    }
    
}
