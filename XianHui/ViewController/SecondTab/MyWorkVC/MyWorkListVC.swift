//
//  MyCustomerListVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/28.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON
import DZNEmptyDataSet
import MJRefresh

class MyWorkListVC: UIViewController ,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var tableView:UITableView!
    
    let dataHelper = MyWorkListHepler()
    
    var parentNavigationController : UINavigationController?
    
    var parentVC:UIViewController?
    
    var type:MyWorkType = .customer
    
    var jsons = [JSON]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    func setTableView() {
        tableView = UITableView(frame: CGRectMake(0.0,0.0, self.view.frame.width, self.view.frame.height - 64 - 40), style: .Grouped)
        view.addSubview(tableView)
        tableView.delegate = dataHelper
        tableView.dataSource = dataHelper
        
        // add MJRefresh
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            self.getDataFromServer()
        })        
        
        dataHelper.cellSelectedHandler = {
            (index,objectId,objectName,obj) in
            let vc = MyWorkDetailVC()
            vc.title = objectName
            vc.objectId = objectId
            vc.objectName = objectName
            vc.type = self.type
            
            if obj.thirdTagString == "0项" {
                vc.noPlan = true
            }
            else {
                vc.noPlan = false
            }
            
            vc.profileJSON = self.jsons[index]
            self.parentNavigationController?.pushViewController(vc, animated: true)
            
        }
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        tableView.mj_footer.beginRefreshing()
        
    }
    
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "暂无数据"
        
        let attrString = NSAttributedString(string: text)
        
        return attrString
    }
    
    var pageSize = 20
    
    var pageNumber = 1
    
    func getDataFromServer() {
        var urlString = ""
        switch self.type {
        case .customer:
            urlString = GetMyWorkCustomerUrl
        case .employee:
            urlString = GetMyWorkEmployeeUrl
        case .project:
            urlString = GetMyWorkProjectUrl
        case .prod:
            urlString = GetMyWorkProdUrl
        }
        
        
        NetworkManager.sharedManager.getMyWorkListWith(urlString, pageSize: pageSize, pageNumber: pageNumber) { (success, json, error) in
            
            if success == true {
                if let rows = json!["rows"].array {
                    
                    if rows.count == 0 {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    else {
                        self.tableView.mj_footer.endRefreshing()
                        self.pageNumber += 1
                        self.jsons = rows
                        self.getDataWith(rows)
                    }
                }
            }
            else {
                
            }
        }

        
    }
    
    
    
    func getDataWith(datas:[JSON]) {
        
        var dataArray = [MyWorkObject]()
        
        switch self.type {
        case .customer:
            dataArray = getCustomerDataWith(datas)
        case .employee:
            dataArray = getEmployeeData(datas)
        case .project:
            dataArray = getProjectData(datas)
        case .prod:
            dataArray = getProductionData(datas)
        }
        
        dataHelper.dataArray += dataArray
        
        tableView.reloadData()
        
        
    }
    
    func getCustomerDataWith(datas:[JSON]) -> [MyWorkObject] {
        
        var list = [Customer]()
        
        for data in datas {
            let c = Customer()
            if let fullName = data["fullname"].string {
               c.name = fullName
            }
            if let orgName = data["org_name"].string {
                c.place = orgName
            }
            if let days = data["days"].string {
                c.time  = days + "天"
            }
            
            if let avatarUrl = data["avator_url"].string {
                c.avatarUrlString = avatarUrl
            }
            
            if let customer_id = data["customer_id"].int {
               c.id = customer_id
            }
            
            if let status = data["status"].int {
                let statusInt = status
                
                switch statusInt {
                case 1:
                    c.scheduleStatus = "服务中"
                case 2:
                    c.scheduleStatus = "未到店"
                case 3:
                    c.scheduleStatus = "已离店"
                case 4:
                    c.scheduleStatus = "已预约"
                case 5:
                    c.scheduleStatus = "未预约"
                case 6:
                    c.scheduleStatus = "未预约"
                default:
                    break;
                }
                
            }
            
            if let total = data["project_total"].int {
                c .projectTotal = total
            }
            
            list.append(c)
        }
        
        var dataArray = [MyWorkObject]()
        for c in list {
            let work = MyWorkObject()
            work.nameLabelString = c.name
            work.leftImageUrl = c.avatarUrlString
            work.firstTagString = c.place
            work.secondTagString = c.time
            work.thirdTagString = String(c.projectTotal) + "项"
            work.id = c.id
            
            work.rightLabelString = c.scheduleStatus
            
            work.firstTagImage = UIImage(named: "place")!
            work.secondTagImage = UIImage(named: "clock")!
            work.thirdTagImage = UIImage(named: "planIcon")!
            
            dataArray.append(work)
            
        }
        
        return dataArray
    }
    
    func getEmployeeData(datas:[JSON]) -> [MyWorkObject] {
        var list = [Employee]()
        
        for data in datas {
            let employee = Employee()
            if let displayName = data["display_name"].string {
                employee.displayName = displayName
            }
            
            if let avatarUrl = data["avator_url"].string {
                employee.avatarURL = avatarUrl
            }
            
            if let orgName = data["org_name"].string {
                employee.place = orgName
            }
            
            if let project_hours = data["project_hours"].float {
                
                employee.workTime = String(project_hours)
            }
            
            if let userId = data["user_id"].int {
                employee.id = userId
            }
            
            if let projectTotal = data["project_qty"].int {
                employee.projectTotal = projectTotal
            }
            
            if let status = data["status"].int {
                let statusInt = status
                
                switch statusInt {
                case 1:
                    employee.status = "服务中"
                case 2,3:
                    employee.status = "等待中"
                default:
                    break;
                }
            }
            
            list.append(employee)
        }
        
        var dataArray = [MyWorkObject]()
        for employee in list {
            let work = MyWorkObject()
            work.nameLabelString = employee.displayName
            work.leftImageUrl = employee.avatarURL
            work.firstTagString = employee.place
            work.secondTagString = String(employee.projectTotal)
            work.thirdTagString = employee.workTime
            work.id = employee.id
            work.rightLabelString = employee.status
            
            work.firstTagImage = UIImage(named: "place")!
            work.secondTagImage = UIImage(named: "projectTotal")!
            work.thirdTagImage = UIImage(named: "timeTotal")!
            
            dataArray.append(work)
            
        }
        
        return dataArray

    }
    
    func getProjectData(datas:[JSON])  -> [MyWorkObject] {
        var list = [Project]()
        
        for data in datas {
            let p = Project()
            if let projectName = data["project_name"].string {
                p.name = projectName
            }
            
            if let orgName = data["org_name"].string {
                p.place = orgName
            }
            
            if let scheduleNum = data["schedule_num"].int {
                p.scheduleNum = scheduleNum
            }
            
            if let paidNum = data["paid_num"].string {
                if let paidNumInt = paidNum.toInt() {
                    p.paidNum  = paidNumInt
                }
            }
            
            if let projectId = data["project_id"].int {
                p.id = projectId
            }
            
            list.append(p)
        }
        
        var dataArray = [MyWorkObject]()
        for p in list {
            let work = MyWorkObject()
            work.nameLabelString = p.name
            work.leftImageUrl = p.avatarUrl
            work.firstTagString = p.place
            work.secondTagString = String(p.scheduleNum)
            work.thirdTagString = String(p.paidNum)
            work.id = p.id
            work.firstTagImage = UIImage(named: "place")!
            work.secondTagImage = UIImage(named: "calander")!
            work.thirdTagImage = UIImage(named: "littlePeopleNum")!
            
            dataArray.append(work)
            
        }
        
        return dataArray

    }
    
    func getProductionData(datas:[JSON])  -> [MyWorkObject] {
        
        var list = [Production]()
        
        for data in datas {
            let prod = Production()
            if let itemId = data["item_id"].int {
                prod.id = itemId
            }
            if let itemName = data["item_name"].string {
                prod.name = itemName
            }
            
            if let stockNum = data["stock_qty"].string {
                    prod.stockNum = stockNum
            }
            if let slaeNum = data["buy_qty"].string {
                    prod.saleNum = slaeNum
            }
            
            
            list.append(prod)
        }
        
        var dataArray = [MyWorkObject]()
        for p in list {
            let work = MyWorkObject()
            work.nameLabelString = p.name
            work.leftImageUrl = ""
            work.firstTagString = "缺失"
            work.secondTagString = p.saleNum
            work.thirdTagString = p.stockNum
            work.id            = p.id
            work.firstTagImage = UIImage(named: "place")!
            work.secondTagImage = UIImage(named: "clock")!
            work.thirdTagImage = UIImage(named: "stockIcon")!
            
            dataArray.append(work)
            
        }
        
        return dataArray

    }

  
    
}
