//
//  configWC.swift
//  manage
//
//  Created by 王迎宾 on 2020/5/7.
//  Copyright © 2020 王迎宾. All rights reserved.
//

import Cocoa

class configWC: NSWindowController {

    @IBOutlet weak var toolBar: NSToolbar!
    var configViewDictionary: Dictionary = Dictionary<String, NSViewController?>()
    var selectToolBarIdentifier = ""
    var isInit = false
    
    override func windowDidLoad() {
        super.windowDidLoad()
        toolBarItemClicked(NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "otherConfig")))
    }
    
    @IBAction func toolBarItemClicked(_ sender: Any) {
        let item = sender as? NSToolbarItem
        if item == nil {
            return
        }
        toolBar.selectedItemIdentifier = item!.itemIdentifier
        let identifier = item!.itemIdentifier.rawValue
        // 没有变化直接返回
        if identifier == selectToolBarIdentifier {
            return
        }
        selectToolBarIdentifier = identifier
        var cv = configViewDictionary[identifier] as? NSViewController
        if cv == nil {
            cv = self.storyboard?.instantiateController(withIdentifier: identifier) as? NSViewController
            if cv != nil {
                self.configViewDictionary[identifier] = cv
            }
        }
        window?.contentView = cv?.view
    }
    
}

extension Notification.Name {
    static let showConfigWindow = Notification.Name("showConfigWindow")
    static let showMainWindow = Notification.Name("showMainWindow")
}
