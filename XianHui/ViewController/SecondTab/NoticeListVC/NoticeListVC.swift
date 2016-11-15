//
//  NoticeListVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/9.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import ChatKit

enum NoticeType:String {
    case daily_report = "daily_report"
    case project_plan = "project_plan"
    case common_notice = "common_notice"
}

class Notice: NSObject {

    var id = 0
    var type:NoticeType = NoticeType.daily_report

    //日期
    var day = ""
    
    var title = ""
    
    var text = ""
    
    var orgName = ""
    
    var orgId = 0
    
    var createTime = ""
    
    var hasRead = false
}

class NoticeListVC: UIViewController {
    
    var tableView:UITableView!
    
    var cellId = "HeplerCell"

    var pageNumber = 1
    
    var pageSize = 10
    
    var listOfNotice = [Notice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
      //  LCChatKit.sharedInstance().conversationService.updateConversationAsRead()
        
    }
    
    var firstLoad = true
    
    func getHelperList() {
        
        NetworkManager.sharedManager.getNoticeListWith(pageSize, pageNumber: pageNumber) { (success, json, error) in
            if success == true {
                
                if let jsons = json!["rows"].array {
                    
                    self.makeNoticeListWith(jsons)
                    self.pageNumber += 1
                    self.tableView.reloadData()
                    
                    self.tableView.mj_header.endRefreshing()
                    
                    if self.firstLoad == true {
                        self.firstLoad = false
                        self.scrollTableViewBottom()
                    }
                }
            }
            else {
                
            }
        }
    }
    
    
    func makeNoticeListWith(_ jsons:[JSON]){
        
        if jsons.count == 0 {
            
            tableView.mj_header.endRefreshing()
            
            return
        }
        
        for json in jsons {
            let no = Notice()
            if let noticeId = json["notice_id"].int {
                no.id =  noticeId
            }
            if let body = json["body"].string {
                no.text = body
            }
            
            if let subject = json["subject"].string {
                no.title = subject
            }
            
            if let extra_id = json["extra_id"].string {
                no.day = extra_id
            }
            
            if let create_time = json["create_time"].string {
                no.createTime = create_time
            }
            
            switch json["notice_type"].string! {
            case "daily_report":
                no.type = NoticeType.daily_report
            case "project_plan":
                no.type = NoticeType.project_plan
            case "common_notice":
                no.type = NoticeType.common_notice
            default:
                break;
            }
            
            listOfNotice.insert(no, at: 0)
        }
    }
    
    func setTableView() {
    
        tableView = UITableView(frame: view.bounds, style: .grouped)
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getHelperList()
            
        })
        
        tableView.mj_header.beginRefreshing()
    }
    

    func scrollTableViewBottom() {
        guard listOfNotice.count > 0 else {return}
        let indexPath = IndexPath(item: listOfNotice.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
}

extension NoticeListVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfNotice.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HeplerCell
        cell.selectionStyle = .none
        let no = listOfNotice[(indexPath as NSIndexPath).row]
        
        cell.pushTimeLabel.text = no.createTime
        cell.nameLabel.text     = no.title
        cell.dayTimeLabel.text  = no.day
        cell.descLabel.text     = no.text
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
