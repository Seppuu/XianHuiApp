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

let NoticeComingNoti = "NoticeComingNoti"


class XHMessageNoti: NSObject {
    
    var name = ""
    
    var time = ""
    
    var isCommonNotice = false
}

class MessageListVC: LCCKConversationListViewController {
    
    var topTableView:UITableView!
    
    var topView:UIView!
    
    var topCellId = "LCCKConversationListCell"
    
    var noticeList = [XHMessageNoti]()
    
    var tableViewModel = MessageListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.tableView.delegate = tableViewModel
//        self.tableView.dataSource = tableViewModel

        setCustomerCell()
        setTableView()
        showRemindNoticeIfFirstLaunch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setCustomerCell() {
        
        LCChatKit.sharedInstance()
        
    }
    
    func setTableView() {
        
        let cellHeight = LCCKConversationListCellDefaultHeight
        let countFloat = CGFloat(noticeList.count)
        topView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: cellHeight * countFloat))
        topView.backgroundColor = UIColor ( red: 0.5, green: 0.5, blue: 0.5, alpha: 0.29 )
        
        topTableView = UITableView(frame: CGRectMake(0, 0, screenWidth, cellHeight * countFloat), style: .Plain)
        topTableView.delegate = self
        topTableView.dataSource = self
        
        topView.addSubview(topTableView)
        
        self.tableView.tableHeaderView = topView
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessageListVC.addNewNoticeType(_:)), name:NoticeComingNoti , object: nil)
        
    }
    
    //展示提示,教学等cell.如果是第一次打开app
    func showRemindNoticeIfFirstLaunch() {
        
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
            
            self.updateTopView()
            
        }
        else {
            
        }
        
    }
    
    func updateTopView() {
        
        var frame = topView.frame
        frame.size.height = LCCKConversationListCellDefaultHeight * CGFloat(noticeList.count)
        
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
                                $0.time = "新时间"
                            }
                            
                            }
                            
                            if hasReportOrPlan == false {
                                //add new one
                                let hepler = XHMessageNoti()
                                hepler.name = "助手"
                                hepler.time = "时间"
                                hepler.isCommonNotice = false
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
                                $0.time = "新时间"
                            }
                            
                        }
                        
                        if hasCommonNotice == false {
                            //add new one
                            let remind = XHMessageNoti()
                            remind.name = "提醒"
                            remind.time = "时间"
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
            let cellHeight = LCCKConversationListCellDefaultHeight
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
        return LCCKConversationListCellDefaultHeight
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = MessageListCell.dequeueOrCreateCellByTableView(tableView)
        cell.selectionStyle = .None
        let notice = noticeList[indexPath.row]
        
        cell.nameLabel.text = notice.name
        cell.avatarImageView.backgroundColor = UIColor ( red: 0.9671, green: 0.8294, blue: 0.7451, alpha: 0.8 )
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.ddWidth/2
        cell.avatarImageView.layer.masksToBounds = true
        cell.timestampLabel.text = notice.time
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let notice = noticeList[indexPath.row]
        
        if notice.name == "助手" {
            
            if isFirstLaunch == true {
                let vc = FirstLaunchRemindVC()
                vc.title = "助手新手教学"
                navigationController?.pushViewController(vc, animated: true)
                
            }
            else {
                let vc = HelperVC()
                vc.title = "助手"
                navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
        else {
            
            if isFirstLaunch == true {
                let vc = FirstLaunchRemindVC()
                vc.title = "提醒新手教学"
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
