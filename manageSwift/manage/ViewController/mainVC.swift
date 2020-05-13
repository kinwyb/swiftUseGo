//
//  ViewController.swift
//  manage
//
//  Created by 王迎宾 on 2020/5/6.
//  Copyright © 2020 王迎宾. All rights reserved.
//

import Cocoa

class mainVC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // 产量校对
    @IBAction func dyemDataCheck(_ sender: Any) {
        self.view.viewDidHide()
    }
    
}

