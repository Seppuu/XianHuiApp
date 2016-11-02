//
//  MessageListVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/22.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import MJRefresh
import ChatKit



extension PalauDefaults {
    
    //0 是新手提示 1是跳转界面
    //助手
    public static var MessageListHelperLastTime: PalauDefaultsEntry<String> {
        get {
            return value("MessageListHelperLastTime").whenNil(use:"")
        }
        set {
            
        }
    }
    
    //提醒
    public static var MessageListRemiandLastTime: PalauDefaultsEntry<String> {
        get {
            return value("MessageListRemiandLastTime").whenNil(use:"")
        }
        set {
            
        }
    }
    
}

let NoticeComingNoti = "NoticeComingNoti"

let MyBookHasLoginNoti = "NoticeComingNoti"


class MessageListVC: LCCKConversationListViewController {
    
    var customStatusView = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customStatusView = UILabel(frame: CGRect(x: 15, y: 0, width: screenWidth, height: 44))
        customStatusView.text = "PC端已经登陆,点击退出"
        customStatusView.font = UIFont.systemFont(ofSize: 12)
        customStatusView.backgroundColor = UIColor.init(hexString: "EDF0F1")
        customStatusView.textColor = UIColor.init(hexString: "888C8E")
        let tap = UITapGestureRecognizer(target: self, action: #selector(MessageListVC.logOutMyBook))
        customStatusView.isUserInteractionEnabled = true
        customStatusView.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    func addMyBookLoginStatusCell() {
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyBookERPLoginStatus()
        
        
    }

    
    //当前的策略是每次进入这个页面,检查mybook登陆状态.
    func getMyBookERPLoginStatus() {
        NetworkManager.sharedManager.getERPLogInStatus { (success, json, error) in
            
            if success == true {
                //已经登陆
                self.tableView.tableHeaderView = self.customStatusView
            }
            else {
               //未登录
                self.tableView.tableHeaderView = nil
            }
        }
    }
    
    
    func logOutMyBook() {
        
        let vc = ScanResultController()
        vc.isLogInMyBook = false
        vc.title = "退出登陆"
        navigationController?.pushViewController(vc, animated: true)
    }


}

