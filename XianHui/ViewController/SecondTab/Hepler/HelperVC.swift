//
//  HelperVC.swift
//  XianHui
//
//  Created by Seppuu on 16/8/3.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON


class HelperVC: BaseViewController {
    
    var tableView:UITableView!
    
    var cellId = "HeplerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    var listOfNotice = [Notice]()
    
    var pageSize = 10
    
    var pageNumber = 1
    
    var firstLoad = true
    
    func getHelperList() {
        
        NetworkManager.sharedManager.getHelperListWith(pageSize, pageNumber: pageNumber) { (success, json, error) in
            
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
    
    func makeNoticeListWith(jsons:[JSON]){
        
        if jsons.count == 0 {
            
            tableView.mj_header.endRefreshing()
            
            return
        }
        
        
        for json in jsons {
            let no = Notice()
            
            if let noticeId = json["notice_id"].int {
                no.id = noticeId
            }
            
            if let body = json["body"].string {
                no.text = body
            }
            if let subject = json["subject"].string {
                no.title = subject
            }
            if let extraId = json["extra_id"].string {
                no.day = extraId
            }
            
            if let createTime = json["create_time"].string {
                if let date = createTime.toDate("yyyy-MM-dd HH:mm:ss") {
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    no.createTime = dateFormatter.stringFromDate(date)
                    
                }
                
            }
            
            if let status = json["status"].int {
                let status = status
                
                if status == 0 {
                    no.hasRead = false
                }
                else if status == 1{
                    no.hasRead = true
                }
            }
            
            if let notice_type = json["notice_type"].string {
                
                switch notice_type {
                case "daily_report":
                no.type = NoticeType.daily_report
                case "project_plan":
                no.type = NoticeType.project_plan
                case "common_notice":
                no.type = NoticeType.common_notice
                default:
                break;
                }
            }
            
            listOfNotice.insert(no, atIndex: 0)
        }
    }
    
    func setTableView() {
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            
            self.getHelperList()
            
        })
        
        tableView.mj_header.beginRefreshing()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func scrollTableViewBottom() {
        guard listOfNotice.count > 0 else {return}
        let indexPath = NSIndexPath(forItem: listOfNotice.count - 1, inSection: 0)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
    }
}

extension HelperVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfNotice.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  170
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! HeplerCell
        cell.selectionStyle = .None
        let no = listOfNotice[indexPath.row]
        
        cell.pushTimeLabel.text = no.createTime
        cell.nameLabel.text     = no.title
        cell.dayTimeLabel.text  = no.day
        cell.descLabel.text     = no.text
        
        if no.hasRead == true {
            
            cell.statusLabel.text = "已读"
            cell.statusLabel.textColor = UIColor ( red: 1.0, green: 0.2072, blue: 0.2616, alpha: 1.0 )
        }
        else {
            cell.statusLabel.text = "未读"
            cell.statusLabel.textColor = UIColor ( red: 0.0019, green: 0.6729, blue: 0.003, alpha: 1.0 )
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let no = listOfNotice[indexPath.row]
        
        switch no.type {
        case .daily_report:
            let vc = DailyFormVC()
            vc.noticeId = no.id
            vc.title = "日报表"
            navigationController?.pushViewController(vc, animated: true)
            
        case .project_plan:
            let vc = MyWorkVC()
            vc.title = "我的工作"
            navigationController?.pushViewController(vc, animated: true)
        case .common_notice: break;
        }
        
        //设置已读
        NetworkManager.sharedManager.getNoticeDetailWith(no.id) { (success, json, error) in
            
            if success == true {
                no.hasRead = true
                self.tableView.reloadData()
            }
            else {
                //TODO:设置失败
            }
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}


class DemoPageViewController: BaseViewController {
    
    
    override func viewDidLoad() {
        
        
    }
}














