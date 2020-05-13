//
//  dyemDataCheckVC.swift
//  manage
//
//  Created by 王迎宾 on 2020/5/6.
//  Copyright © 2020 王迎宾. All rights reserved.
//

import Cocoa

// 产量汇总数据结构
class dyemDataGroup:Codable {
    let bodaNum : Int
    let bodaCount : Int
    let crystalNoSyncNum : Int
    let crystalSyncNum : Int
    let crystalNoSyncCount: Int
    let crystalSyncCount: Int
    let date : String
    let dgNum : Int
    let dgCount: Int
    
    enum CodingKeys: String, CodingKey {
        case bodaNum = "BodaNum"
        case bodaCount = "BodaCount"
        case crystalNoSyncNum = "CrystalNoSyncNum"
        case crystalSyncNum = "CrystalSyncNum"
        case crystalSyncCount = "CrystalSyncCount"
        case crystalNoSyncCount = "CrystalNoSyncCount"
        case date = "Date"
        case dgNum = "DgNum"
        case dgCount = "DgCount"
    }
    
    init(){
        bodaNum = 0
        bodaCount = 0
        crystalNoSyncNum  = 0
        crystalSyncNum = 0
        crystalNoSyncCount = 0
        crystalSyncCount = 0
        date  = "ww"
        dgNum = 0
        dgCount = 0
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bodaNum = try values.decodeIfPresent(Int.self, forKey: .bodaNum) ?? 0
        crystalNoSyncNum = try values.decodeIfPresent(Int.self, forKey: .crystalNoSyncNum) ?? 0
        crystalSyncNum = try values.decodeIfPresent(Int.self, forKey: .crystalSyncNum) ?? 0
        date = try values.decodeIfPresent(String.self, forKey: .date) ?? ""
        dgNum = try values.decodeIfPresent(Int.self, forKey: .dgNum) ?? 0
        dgCount = try values.decodeIfPresent(Int.self, forKey: .dgCount) ?? 0
        bodaCount = try values.decodeIfPresent(Int.self, forKey: .bodaCount) ?? 0
        crystalSyncCount = try values.decodeIfPresent(Int.self, forKey: .crystalSyncCount) ?? 0
        crystalNoSyncCount = try values.decodeIfPresent(Int.self, forKey: .crystalNoSyncCount) ?? 0
    }
    
    func getValue(key:String) -> (String,Int) {
        if key.isEmpty {
            return ("",0)
        }
        switch key {
        case "date":
            return (date,0)
        case "dg":
            return (dgNum.description,dgCount)
        case "crystal":
            return ((crystalSyncNum+crystalNoSyncNum).description,crystalSyncCount+crystalNoSyncCount)
        case "crystal_detail":
            let sync = crystalSyncNum.description
            let noSync = crystalNoSyncNum.description
            if sync == "" && noSync == "" {
                return ("",0)
            }
            return  (sync + "[" + crystalSyncCount.description + "]/" + noSync + "[" + crystalNoSyncCount.description + "]",0)
        case "bd":
            return (bodaNum.description,bodaCount)
        default:
            return ("",0)
        }
    }
    
}

class dyemDataCheckVC: NSViewController {
    
    @objc dynamic var startDate:Date=Date()
    @objc dynamic var endDate:Date=Date()
    
    @IBOutlet weak var table: NSTableView!
    @IBOutlet weak var tableView: NSScrollView!
    @IBOutlet weak var loading: NSTextField!
    
    var datas = [dyemDataGroup]()
    
    required init?(coder: NSCoder) {
        let num:Int64 = 8*24*60*60 //7天转换成秒
        startDate.addTimeInterval(TimeInterval.init(integerLiteral:-num))
        endDate.addTimeInterval(TimeInterval.init(integerLiteral: -1*24*60*60))
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func doCheck(_ sender: Any) {
        let startDateString = dateFormat.string(from: startDate).split(separator: " ").first?.description ?? ""
        let endDateString = dateFormat.string(from: endDate).split(separator: " ").first?.description ?? ""
        loading.isHidden = false
        tableView.isHidden = true
        let arg = startDateString + "|"+endDateString
        loadData(arg: arg)
    }
    
    func loadData(arg:String) {
        //1 异步加载数据
        DispatchQueue.global().async {
            let cmd = CmdData.init(cmdID: CmdID.dyemCheckGroupID.rawValue, data:arg)
            let (result,e) = doCmd(data: cmd)
            //3 回到主线程
            DispatchQueue.main.async(execute: {
                if e != nil {
                    showAlert(title: "", msg: "查询失败:"+e!.Msg, icon: nil)
                    return
                }
                let resultData = JSONStringDecode(jsonString: result!, Array<dyemDataGroup>.self)
                self.datas.removeAll() //清空
                resultData?.forEach { (elemt) in
                    self.datas.append(elemt)
                }
                self.tableView.isHidden = false
                self.table.reloadData()
                self.loading.isHidden = true
            })
        }
    }
    
}

// table数据源
extension dyemDataCheckVC : NSTableViewDataSource {
    
    // 返回数据行数
    func numberOfRows(in tableView: NSTableView) -> Int {
        return datas.count
    }
    
}

// table事件代理
extension dyemDataCheckVC: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let data = datas[row]
        let key = tableColumn?.identifier
        let view = tableView.makeView(withIdentifier: key!, owner: self)
        let subViews = view?.subviews
        if(subViews?.count ?? 0 < 1 ) {
            return nil
        }
        if key?.rawValue == "option" {
            let cellView = view as! btnCellView
            if data.dgNum == data.crystalNoSyncNum+data.crystalSyncNum {
                cellView.dgBtn.isHidden = true
            }
            if data.crystalSyncNum == data.bodaNum {
                cellView.bdBtn.isHidden = true
            }
            cellView.date = data.date
            return cellView
        } else {
            let (value,count) = data.getValue(key: key?.rawValue ?? "")
            let text = subViews?[0] as! NSTextField
            text.stringValue = value
            var tip = "条数:"+count.description
            if key?.rawValue == "crystal" {
                let(v,_) = data.getValue(key: "crystal_detail")
                tip = tip+" 明细:" + v
            }
            text.toolTip = tip
            return view
        }
    }
    
}

class btnCellView: NSView {
    
    var date:String = ""
    @IBOutlet weak var dgBtn: NSButton!
    @IBOutlet weak var bdBtn: NSButton!
    
    @IBAction func bdCheck(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name.init("showDyemCheckBd"), object: "0|"+date)
    }
    
    @IBAction func dgCheck(_ sender: Any) {
       NotificationCenter.default.post(name: NSNotification.Name.init("showDyemCheckDg"), object: "1|"+date)
    }
    
}
