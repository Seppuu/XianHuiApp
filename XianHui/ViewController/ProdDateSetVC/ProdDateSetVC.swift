//
//  ProdDateSetVC.swift
//  XianHui
//
//  Created by jidanyu on 16/8/24.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ProdDateSetVC: UIViewController {
    
    var tableUIView:ProdDateSetTableView!
    
    var prod:Production!

    var confirmTapHandler:((prod:Production)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        title = "提醒设置"
        
        tableUIView = ProdDateSetTableView(frame: view.bounds)
        tableUIView.production = prod
        view.addSubview(tableUIView)
        
        setNavBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.sharedManager().enable = true
    }
    
    
    func setNavBarItem() {
        
        let rightBar = UIBarButtonItem(title: "确定", style: .Done, target: self, action: #selector(ProdDateSetVC.confirmTap))
        
        navigationItem.rightBarButtonItem = rightBar
        
    }
    
    func confirmTap() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
        passData()
    }
    
    func passData() {
        
        self.confirmTapHandler?(prod:prod)
    }

}
