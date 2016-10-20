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
import Palau


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

class XHMessageNoti: NSObject {
    
    var name = ""
    
    var time = ""
    
    var timeString:String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
        if let date = dateFormatter.dateFromString(time) {
            
            return date.lcck_shortTimeAgoSinceNow()
            
        }
        else {
            return "新手教学"
        }
    }
    
    var isCommonNotice = false
    
}

class MessageListVC: LCCKConversationListViewController {
    
    var topTableView:UITableView!
    
    var topView:UIView!
    
    var topCellId = "LCCKConversationListCell"
    
    var noticeList = [XHMessageNoti]()
    
    let cellHeight:CGFloat = 64.0
    
    var tableViewModel = MessageListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setCustomerCell()
        setTableView()
        showRemindNotice()
        
        self.tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setCustomerCell() {
        
        LCChatKit.sharedInstance()
        
    }
    
    func setTableView() {
        
        
        let countFloat = CGFloat(noticeList.count)
        topView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: cellHeight * countFloat))
        topView.backgroundColor = UIColor ( red: 0.5, green: 0.5, blue: 0.5, alpha: 0.29 )
        
        topTableView = UITableView(frame: CGRectMake(0, 0, screenWidth, cellHeight * countFloat), style: .Plain)
        topTableView.delegate = self
        topTableView.dataSource = self
        topTableView.scrollEnabled = false
        topTableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        topView.addSubview(topTableView)
        
        self.tableView.tableHeaderView = topView
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessageListVC.addNewNoticeType(_:)), name:NoticeComingNoti , object: nil)

    }
    
    func addMyBookLoginStatusCell() {
        
        
    }
    
    //展示助手,提醒.
    func showRemindNotice() {
        
        if isFirstLaunch == true {
            
            let hepler = XHMessageNoti()
            hepler.name = "助手"
            hepler.time = "新手提示"
            hepler.isCommonNotice = false
            
            self.noticeList.append(hepler)
            
            let remind = XHMessageNoti()
            remind.name = "提醒"
            remind.time = "新手提示"
            
            remind.isCommonNotice = true
            self.noticeList.append(remind)
            
        }
        else {
            
            if Defaults.MessageListHelperLastTime.value! != "" {
                let hepler = XHMessageNoti()
                hepler.name = "助手"
                hepler.time = Defaults.MessageListHelperLastTime.value!
                hepler.isCommonNotice = false
               
                self.noticeList.append(hepler)
            }
            else {
                let hepler = XHMessageNoti()
                hepler.name = "助手"
                hepler.time = "新手提示"
                hepler.isCommonNotice = false
               
                self.noticeList.append(hepler)
            }
            
            if Defaults.MessageListRemiandLastTime.value! != "" {
                let remind = XHMessageNoti()
                remind.name = "提醒"
                remind.time = Defaults.MessageListRemiandLastTime.value!
                
                remind.isCommonNotice = true
                self.noticeList.append(remind)
            }
            else {
                let remind = XHMessageNoti()
                remind.name = "提醒"
                remind.time = "新手提示"
                
                remind.isCommonNotice = true
                self.noticeList.append(remind)
            }
            
   
        }
        
        self.updateTopView()
        
    }
    
    func updateTopView() {
        
        var frame = topView.frame
        frame.size.height = cellHeight * CGFloat(noticeList.count)
        
        topView.frame = frame
        
        topTableView.frame = frame
        
        self.tableView.tableHeaderView = topView
        
        self.topTableView.reloadData()
    }

    
    func addNewNoticeType(noti:NSNotification) {
        
        if let data  = noti.object as? [NSObject : AnyObject] {
            
            if let userInfo = data as? [String : AnyObject] {
                
                if let type =  userInfo["notice_type"] as? String {
                    if type == "daily_report" || type == "project_plan"{
                        
                        var hasReportOrPlan = false
                        self.noticeList.forEach{
                            
                            if $0.isCommonNotice == false {
                                hasReportOrPlan = true
                                //update old one
                                if let time = userInfo["notice_time"] as? String {
                                    $0.time = time
                                    
                                    Defaults.MessageListHelperLastTime.value = time
                                }
                                
                            }
                            
                            }
                            
                            if hasReportOrPlan == false {
                                //add new one
                                let hepler = XHMessageNoti()
                                hepler.name = "助手"
                                hepler.time = "时间"
                                hepler.isCommonNotice = false
                                
                                if let time = userInfo["notice_time"] as? String {
                                    hepler.time = time
                                    
                                    Defaults.MessageListHelperLastTime.value = time
                                }
                                self.noticeList.append(hepler)
                            }
                            else {
                                //already update old one
                            }
                    }
                    else if type == "common_notice" {
                        
                        var hasCommonNotice = false
                        self.noticeList.forEach{
                            
                            if $0.isCommonNotice == true {
                                hasCommonNotice = true
                                //update old one
                                if let time = userInfo["notice_time"] as? String {
                                    $0.time = time
                                    
                                    Defaults.MessageListRemiandLastTime.value = time
                                }
                            }
                            
                        }
                        
                        if hasCommonNotice == false {
                            //add new one
                            let remind = XHMessageNoti()
                            remind.name = "提醒"
                            
                            if let time = userInfo["notice_time"] as? String {
                                remind.time = time
                                
                                Defaults.MessageListHelperLastTime.value = time
                            }
                            remind.isCommonNotice = true
                            self.noticeList.append(remind)
                        }
                        else {
                            //already update old one
                        }
                        
                    }
                    else {
                        
                    }
                    
                    self.updateTopView()
                    
                }
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getMyBookERPLoginStatus()
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    //当前的策略是每次进入这个页面,检查mybook登陆状态.
    func getMyBookERPLoginStatus() {
        NetworkManager.sharedManager.getERPLogInStatus { (success, json, error) in
            
            if success == true {
                
            }
            else {
                
            }
        }
    }
    
    //顶部网络状态栏位置和三个标签重合
    override func updateStatusView() {
        
        self.tableView.tableHeaderView = nil
        
        let isConnnect = LCCKSessionService.sharedInstance().connect
        
        if isConnnect == true {
            
            topTableView.frame.size.height = cellHeight * CGFloat(noticeList.count)
            topView.frame.size.height = cellHeight * CGFloat(noticeList.count)
            topTableView.tableHeaderView = nil
            
            self.tableView.tableHeaderView = topView
        }
        else {
            let cellHeight = LCCKConversationListCellDefaultHeight
            topView.frame.size.height = cellHeight * CGFloat(noticeList.count) + 44
            topTableView.frame.size.height = cellHeight * CGFloat(noticeList.count) + 44
            topTableView.tableHeaderView = self.clientStatusView
            
            self.tableView.tableHeaderView = topView
        }
        
    }

}

extension MessageListVC {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeList.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //return LCCKConversationListCellDefaultHeight
        return 64
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = MessageListCell.dequeueOrCreateCellByTableView(tableView)
        cell.selectionStyle = .None
        let notice = noticeList[indexPath.row]
        
        cell.nameLabel.text = notice.name
        
        if notice.name == "助手" {
            cell.avatarImageView.image = UIImage(named: "analyze")
        }
        else if notice.name == "提醒" {
            cell.avatarImageView.image = UIImage(named: "bell")
        }
        else {
            
        }
        
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.ddWidth/2
        cell.avatarImageView.layer.masksToBounds = true
        cell.timestampLabel.text = notice.timeString
        
       // cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let notice = noticeList[indexPath.row]
        
        if notice.name == "助手" {
            
            if notice.time == "新手提示" {
                let vc = FirstLaunchRemindVC()
                vc.title = "助手新手教学"
                vc.isRemind = false
                navigationController?.pushViewController(vc, animated: true)
                
            }
            else {
                let vc = HelperVC()
                vc.title = "助手"
                navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else {
            
            if notice.time == "新手提示" {
                let vc = FirstLaunchRemindVC()
                vc.title = "提醒新手教学"
                vc.isRemind = true
                navigationController?.pushViewController(vc, animated: true)
                
            }
            else {
                let vc = NoticeListVC()
                vc.title = "提醒"
                navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
        
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            noticeList.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            self.updateTopView()
        }
        else {
            
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    
    
    
    
    
}
