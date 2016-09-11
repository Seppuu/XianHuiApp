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
    
    
    func getHelperList() {
        
        
        NetworkManager.sharedManager.getHelperListWith(pageSize, pageNumber: pageNumber) { (success, json, error) in
            
            if success == true {
                
                if let jsons = json!["rows"].array {
                    
                    self.makeNoticeListWith(jsons)
                    self.pageNumber += 1
                    self.tableView.reloadData()
                    
                    self.tableView.mj_header.endRefreshing()
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
            no.id =  json["notice_id"].int!
            no.text = json["body"].string!
            no.title = json["subject"].string!
            no.day = json["extra_id"].string!
            no.createTime = json["create_time"].string!
            
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
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let no = listOfNotice[indexPath.row]
        
        switch no.type {
        case .daily_report:
            let vc = DailyFormVC()
            vc.title = "日报表"
            navigationController?.pushViewController(vc, animated: true)
            
        case .project_plan:
            let vc = MyWorkVC()
            vc.title = "我的工作"
            navigationController?.pushViewController(vc, animated: true)
        case .common_notice: break;
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}


class DemoPageViewController: BaseViewController {
    
    
    override func viewDidLoad() {
        
        
    }
}














