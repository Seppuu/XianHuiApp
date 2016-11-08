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
    
    
    public static var MyBookLogInToken: PalauDefaultsEntry<String> {
        get {
            return value("MyBookLogInToken").whenNil(use:"")
        }
        set {
            
        }
    }
    
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
    
    var model = MessageListModel()
    
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
        
        //setLeftBarAvatar()
        
        ChatKitExample.updateMessageListVC()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let container = UIView(frame: self.tableView.frame)
        container.backgroundColor = UIColor.white
        let chartView = XHStackedBarChart(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 300))
        chartView.center = container.center
        
        container.addSubview(chartView)
        self.tableView.addSubview(container)
        chartView.updateChartData()
    }
    
    func setLeftBarAvatar() {
        
        let user = User.currentUser()
        
        let avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        avatarImageView.layer.cornerRadius = avatarImageView.ddWidth/2
        avatarImageView.layer.masksToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        if let url = URL(string: (user?.avatarURL)!) {
            avatarImageView.kf.setImage(with: url)
        }
        
        
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(MessageListVC.userAvatarTap))
        avatarImageView.addGestureRecognizer(tap)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: avatarImageView)
        
    }
    
    func userAvatarTap() {
        
        let alert = UIAlertController(title: "状态", message: "切换当前状态", preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "上班", style: .default, handler:  nil)
        
        let action1 = UIAlertAction(title: "休息", style: .default, handler:  nil)
        
        let action0 = UIAlertAction(title: "取消", style: .cancel, handler:  nil)
        
        alert.addAction(action)
        alert.addAction(action1)
        alert.addAction(action0)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func refeshLeftBarAvatarImage() {
        setLeftBarAvatar()
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

