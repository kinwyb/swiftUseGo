//
//  utils.swift
//  manage
//
//  Created by 王迎宾 on 2020/5/6.
//  Copyright © 2020 王迎宾. All rights reserved.
//

import Cocoa
import Foundation

var dateFormat = DateFormatter()

func initDateFormat() {
    dateFormat.locale = Locale(identifier: "zh_CN")
    dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
}

// 显示弹窗
func showAlert(title:String,msg:String,icon:NSImage? ,style:NSAlert.Style = NSAlert.Style.critical) {
    let alert = NSAlert.init()
    //设置alert 样式有三种: warning informational 没有太大差别,critical icon 会有黄色叹号
    alert.alertStyle = style
    //设置图标
    if icon != nil {
        alert.icon = icon
    }
    alert.addButton(withTitle: "确定")
    //提示标题
    alert.messageText = title
    //提示的详细内容
    alert.informativeText = msg
    //跳出window弹出提醒框
    alert.runModal()
    
    // 显示与按钮事件监听
    //              let window = NSApp.windows.last
    //              alert.beginSheetModal(for: self.view.window ?? window!, completionHandler: { res in
    //                  print(res) // 按钮对应的 code 第一个是1000, 第二个 1001, 依次类推
    //              })
}
