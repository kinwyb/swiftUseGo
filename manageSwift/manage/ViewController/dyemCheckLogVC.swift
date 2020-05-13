//
//  dyemCheckLogVC.swift
//  manage
//
//  Created by 王迎宾 on 2020/5/12.
//  Copyright © 2020 王迎宾. All rights reserved.
//

import Cocoa

struct DyemDataCheckLog : Codable {
    
    let employee : String?
    let err : String?
    let isChange : Bool?
    let mo : String?
    let op : Int?
    let qty : Int?
    let workDate : String?
    let workLine : String?
    
    enum CodingKeys: String, CodingKey {
        case employee = "Employee"
        case err = "Err"
        case isChange = "IsChange"
        case mo = "Mo"
        case op = "Op"
        case qty = "Qty"
        case workDate = "WorkDate"
        case workLine = "WorkLine"
    }
    
    init() {
        employee = ""
        err = ""
        isChange = true
        mo = ""
        op = 0
        qty = 0
        workDate = ""
        workLine = ""
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        employee = try values.decodeIfPresent(String.self, forKey: .employee)
        err = try values.decodeIfPresent(String.self, forKey: .err)
        isChange = try values.decodeIfPresent(Bool.self, forKey: .isChange)
        mo = try values.decodeIfPresent(String.self, forKey: .mo)
        op = try values.decodeIfPresent(Int.self, forKey: .op)
        qty = try values.decodeIfPresent(Int.self, forKey: .qty)
        workDate = try values.decodeIfPresent(String.self, forKey: .workDate)
        workLine = try values.decodeIfPresent(String.self, forKey: .workLine)
    }
    
}

class dyemCheckLogVC: NSViewController {
    
    var mainView:NSViewController?
    var isDg = false
    var date = ""
    var datas = [DyemDataCheckLog]()
    
    @IBOutlet weak var table: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let d = DyemDataCheckLog.init()
        datas.append(d)
    }
    
    override func viewDidAppear() {
        loadData() //加载数据
    }
    
    func loadData() {
        var id = CmdID.dyemCheckDgID
        if !isDg {
            id = CmdID.dyemCheckBdID
        }
        let cmd = CmdData.init(cmdID: id.rawValue, data: date)
        let (jsonString,e) = doCmd(data: cmd)
        if e != nil {
            showAlert(title: "", msg: e!.Msg, icon: nil)
            return
        }
        let result = JSONStringDecode(jsonString: jsonString!, Array<DyemDataCheckLog>.self)
        if result != nil {
            datas.removeAll()
            result?.forEach { (v) in
                datas.append(v)
            }
            table.reloadData()
        }
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name.init("showDyemDataCheck"), object:nil)
    }
}


// table数据源
extension dyemCheckLogVC : NSTableViewDataSource {
    
    // 返回数据行数
    func numberOfRows(in tableView: NSTableView) -> Int {
        return datas.count
    }
    
}

// table事件代理
extension dyemCheckLogVC: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let data = datas[row]
        let key = tableColumn?.identifier
        let view = tableView.makeView(withIdentifier: key!, owner: self)
        let subViews = view?.subviews
        if(subViews?.count ?? 0 < 1 ) {
            return nil
        }
        let keyValue = key?.rawValue ?? ""
        var value = ""
        switch keyValue {
        case "workDate":
            value = data.workDate ?? ""
        case "employee":
            value = data.employee ?? ""
        case "op":
            value = data.op?.description ??  ""
        case "qty":
            value = data.qty?.description ?? ""
        case "err":
            value = data.err ?? ""
        case "mo":
            value = data.mo ?? ""
        case "workLine":
            value = data.workLine ?? ""
        default: break
        }
        let text = subViews?[0] as! NSTextField
        text.stringValue = value
        if data.err != nil && data.err! != "" {
            text.textColor = NSColor.red
        } else if data.isChange ?? true{
            text.textColor = NSColor.green
        }
        return view
    }
    
}

