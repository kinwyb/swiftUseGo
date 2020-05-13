//
//  configVC.swift
//  manage
//
//  Created by 王迎宾 on 2020/5/7.
//  Copyright © 2020 王迎宾. All rights reserved.
//

import Cocoa

class dbConfig:NSObject {
    @objc dynamic var IP:String = ""
    @objc dynamic var User:String = ""
    @objc dynamic var Password:String = ""
    @objc dynamic var DbName:String = ""
}

class dbConfigVC: NSViewController {
    
    // 吊挂数据配置
    @objc dynamic var dgData = dbConfig()
    // 中间库
    @objc dynamic var crystalData = dbConfig()
    // 博大
    @objc dynamic var bdData = dbConfig()
    
    @IBOutlet weak var label: NSTextField!
    
    @IBOutlet weak var btn: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let cmd = CmdData.init(cmdID: CmdID.dbConfigLoad.rawValue, data: "")
//        let (jsonString,e) = doCmd(data: cmd)
//        if e != nil {
//            dgData.IP = "127.0.0.1"
//            dgData.User = "sa"
//            dgData.Password = ""
//            dgData.DbName = "DG_TMP"
//            crystalData.IP = "127.0.0.1"
//            crystalData.User = "root"
//            crystalData.Password = ""
//            crystalData.DbName = "crystal"
//            bdData.IP = "127.0.0.1"
//            bdData.User = "sa"
//            bdData.Password = ""
//            bdData.DbName = "BDDMS"
//        } else {
//            let dbConfig = JSONStringDecode(jsonString: jsonString!, dbConfigData.self)
//            dgData.IP = dbConfig?.dgHost ?? ""
//            dgData.User = dbConfig?.dgUser ?? ""
//            dgData.Password = dbConfig?.dgPwd ?? ""
//            dgData.DbName = dbConfig?.dgName ?? ""
//            crystalData.IP = dbConfig?.crystalHost ?? ""
//            crystalData.User = dbConfig?.crystalUser ?? ""
//            crystalData.Password = dbConfig?.crystalPwd ?? ""
//            crystalData.DbName = dbConfig?.crystalName ?? ""
//            bdData.IP = dbConfig?.bdHost ?? ""
//            bdData.User = dbConfig?.bdUser ?? ""
//            bdData.Password = dbConfig?.bdPwd ?? ""
//            bdData.DbName = dbConfig?.bdName ?? ""
//        }
        label.isHidden = true
    }
    
    @IBAction func saveAction(_ sender: Any) {
//        let dbCfg = dbConfigData(dg: dgData, crystal: crystalData, bd: bdData)
//        let dbCfgJson = dbCfg.toJSONString()
//        if dbCfgJson == nil {
//            showAlert(title: "失败", msg: "参数序列化失败", icon: nil)
//            return
//        }
//        label.isHidden = false
//        btn.isEnabled = false
//        let cmd = CmdData.init(cmdID: CmdID.dbConfig.rawValue, data: dbCfgJson!)
//        let (_,e) = doCmd(data: cmd)
//        btn.isEnabled = true
//        label.isHidden = true
//        if e == nil {
//            let cwc = self.view.window?.windowController as! configWC
//            if cwc.isInit {
//                NotificationCenter.default.post(name: NSNotification.Name.showMainWindow, object: nil)
//                self.view.window?.close()
//            }
//        } else {
//            showAlert(title: "", msg: e!.Msg, icon:nil,style: NSAlert.Style.critical)
//        }
    }
}

// 配置数据
struct dbConfigData : JSONToString {
    
    let bdHost : String?
    let bdName : String?
    let bdPwd : String?
    let bdUser : String?
    let crystalHost : String?
    let crystalName : String?
    let crystalPwd : String?
    let crystalUser : String?
    let dgHost : String?
    let dgName : String?
    let dgPwd : String?
    let dgUser : String?
    
    enum CodingKeys: String, CodingKey {
        case bdHost = "BdHost"
        case bdName = "BdName"
        case bdPwd = "BdPwd"
        case bdUser = "BdUser"
        case crystalHost = "CrystalHost"
        case crystalName = "CrystalName"
        case crystalPwd = "CrystalPwd"
        case crystalUser = "CrystalUser"
        case dgHost = "DgHost"
        case dgName = "DgName"
        case dgPwd = "DgPwd"
        case dgUser = "DgUser"
    }
    
    init(dg:dbConfig,crystal:dbConfig,bd:dbConfig){
        self.bdHost = bd.IP
        self.bdName = bd.DbName
        self.bdPwd = bd.Password
        self.bdUser = bd.User
        self.crystalHost = crystal.IP
        self.crystalName = crystal.DbName
        self.crystalPwd = crystal.Password
        self.crystalUser = crystal.User
        self.dgHost = dg.IP
        self.dgName = dg.DbName
        self.dgPwd = dg.Password
        self.dgUser = dg.User
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bdHost = try values.decodeIfPresent(String.self, forKey: .bdHost)
        bdName = try values.decodeIfPresent(String.self, forKey: .bdName)
        bdPwd = try values.decodeIfPresent(String.self, forKey: .bdPwd)
        bdUser = try values.decodeIfPresent(String.self, forKey: .bdUser)
        crystalHost = try values.decodeIfPresent(String.self, forKey: .crystalHost)
        crystalName = try values.decodeIfPresent(String.self, forKey: .crystalName)
        crystalPwd = try values.decodeIfPresent(String.self, forKey: .crystalPwd)
        crystalUser = try values.decodeIfPresent(String.self, forKey: .crystalUser)
        dgHost = try values.decodeIfPresent(String.self, forKey: .dgHost)
        dgName = try values.decodeIfPresent(String.self, forKey: .dgName)
        dgPwd = try values.decodeIfPresent(String.self, forKey: .dgPwd)
        dgUser = try values.decodeIfPresent(String.self, forKey: .dgUser)
    }
    
}
