//
//  dyemDataMainVC.swift
//  manage
//
//  Created by 王迎宾 on 2020/5/13.
//  Copyright © 2020 王迎宾. All rights reserved.
//

import Cocoa

class dyemCheckMainVC: NSViewController {
    
    var dyemDataCheckVC: dyemDataCheckVC?
    var dyemCheckLogVC:dyemCheckLogVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dyemCheckLogVC = storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("dyemCheckLog")) as? dyemCheckLogVC
        dyemDataCheckVC = storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("dyemDataCheck")) as? dyemDataCheckVC
        addChild(dyemDataCheckVC!)
        addChild(dyemCheckLogVC!)
        NotificationCenter.default.addObserver(self, selector: #selector(showDyemCheckLog), name: NSNotification.Name.init("showDyemCheckDg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showDyemCheckLog), name: NSNotification.Name.init("showDyemCheckBd"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showDyemDataCheck(_:)), name: NSNotification.Name.init("showDyemDataCheck"), object: nil)
    }
    
    override func viewDidAppear() {
        view.addSubview(dyemDataCheckVC!.view)
    }
    
    // 显示吊挂检测
    @objc func showDyemCheckLog(_ notification:Notification) {
        if notification.object != nil {
            let data = notification.object as! String
            let datas = data.split(separator: "|")
            if datas.count < 2 { //参数不足
                return
            }
            dyemCheckLogVC?.isDg = datas[0] == "1"
            dyemCheckLogVC?.date = datas[1].description
            transition(from: dyemDataCheckVC!, to: dyemCheckLogVC!, options: NSViewController.TransitionOptions.slideLeft, completionHandler: nil)
        }
    }
    
    // 返回主页
    @objc func showDyemDataCheck(_ notification:Notification) {
         transition(from: dyemCheckLogVC!, to: dyemDataCheckVC!, options: NSViewController.TransitionOptions.slideRight, completionHandler: nil)
    }
    
}
