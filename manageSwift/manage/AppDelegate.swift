//
//  AppDelegate.swift
//  manage
//
//  Created by 王迎宾 on 2020/5/6.
//  Copyright © 2020 王迎宾. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let storyboard:NSStoryboard = NSStoryboard.init(name: NSStoryboard.Name("Main"), bundle:nil)
    
    lazy var configWC: configWC? = {
        let ret = storyboard.instantiateController(
        withIdentifier: NSStoryboard.SceneIdentifier("configWC")) as? configWC
        ret?.isInit = true
        return ret
    }()
    
    lazy var mainWC: NSWindowController? = storyboard.instantiateController(
            withIdentifier: NSStoryboard.SceneIdentifier("mainWC")) as? NSWindowController
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        setCallback()
        initDateFormat()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showConfigWindow(_:)), name: Notification.Name.showConfigWindow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showMainWindow(_:)), name: Notification.Name.showMainWindow, object: nil)
        loadConfig()
    }
    
    func loadConfig() {
        let cmd = CmdData.init(cmdID: CmdID.initConfig.rawValue, data: "")
        let (_,e) = doCmd(data: cmd)
        if e != nil {
            NotificationCenter.default.post(name: Notification.Name.showConfigWindow, object: nil)
        }else {
            NotificationCenter.default.post(name: NSNotification.Name.showMainWindow, object: nil)
        }
    }
    
    // 显示子窗口
    @objc func showConfigWindow(_ notification:Notification) {
        configWC?.showWindow(self)
    }
    
    // 显示主窗口
    @objc func showMainWindow(_ notification:Notification) {
        mainWC?.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // 最后一个窗口关闭时退出程序
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}

