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
import DZNEmptyDataSet

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


class MessageListVC: LCCKConversationListViewController,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate  {
    
    var customStatusView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customStatusView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        customStatusView.backgroundColor = UIColor.init(hexString: "EDF0F1")
        let tap = UITapGestureRecognizer(target: self, action: #selector(MessageListVC.logOutMyBook))
        customStatusView.isUserInteractionEnabled = true
        customStatusView.addGestureRecognizer(tap)
        
        
        let label  = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        label.text = "PC端已经登陆,点击退出"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.init(hexString: "888C8E")
        customStatusView.addSubview(label)
        
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "暂无消息"
        
        let attrString = NSAttributedString(string: text)
        
        return attrString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    func addMyBookLoginStatusCell() {
        
        
    }
    
    
    override func updateStatusView() {
        super.updateStatusView()
        
        let isConnected = LCChatKit.sharedInstance().sessionService.connect
        if isConnected == true {
            getMyBookERPLoginStatus()
        }
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

