//
//  MyCustomerListVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/28.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyCustomerListVC: UIViewController {

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
        getDataFromServer()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    func setTableView() {
        tableView = UITableView(frame: CGRectMake(0.0,0.0, self.view.frame.width, self.view.frame.height - 64 - 40), style: .Grouped)
        view.addSubview(tableView)
        tableView.delegate = dataHelper
        tableView.dataSource = dataHelper
        
        
        dataHelper.cellSelectedHandler = {
            (index,objectId,objectName) in
            let vc = MyWorkDetailVC()
            vc.title = objectName
            vc.objectId = objectId
            vc.objectName = objectName
            vc.type = self.type
            vc.profileJSON = self.jsons[index]
            self.parentNavigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
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
        
        NetworkManager.sharedManager.getMyWorkListWith(urlString) { (success, json, error) in
            if success == true {
                if let rows = json!["rows"].array {
                    self.jsons = rows
                    self.getDataWith(rows)
                }
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
        
        dataHelper.dataArray = dataArray
        
        tableView.reloadData()
        
        
    }
    
    func getCustomerDataWith(datas:[JSON]) -> [MyWorkObject] {
        
        var list = [Customer]()
        
        for data in datas {
            let c = Customer()
            c.name = data["fullname"].string!
            c.place = data["org_name"].string!
            c.time  = data["days"].string! + "天"
            c.avatarUrlString = data["avator_url"].string!
            c.id = data["customer_id"].int!
            let statusInt = data["status"].int!
            
            switch statusInt {
            case 1:
                c.scheduleStatus = "服务中"
            case 2:
                c.scheduleStatus = "未到店"
            case 3:
                c.scheduleStatus = "已离店"
            case 4:
                c.scheduleStatus = "未计已约"
            case 5:
                c.scheduleStatus = "已计未约"
            case 6:
                c.scheduleStatus = "未计未约"
            default:
                break;
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
            work.thirdTagImage = UIImage(named: "calander")!
            
            dataArray.append(work)
            
        }
        
        return dataArray
    }
    
    func getEmployeeData(datas:[JSON]) -> [MyWorkObject] {
        var list = [Employee]()
        
        for data in datas {
            let employee = Employee()
            employee.displayName = data["display_name"].string!
            employee.avatarURL = data["avator_url"].string!
            employee.place = data["org_name"].string!
            employee.workTime = data["project_hours"].int!
            employee.id = data["user_id"].int!
            let statusInt = data["status"].int!
            
            switch statusInt {
            case 1:
                employee.status = "服务中"
            case 2,3:
                employee.status = "等待中"
            default:
                break;
            }
            
            list.append(employee)
        }
        
        var dataArray = [MyWorkObject]()
        for employee in list {
            let work = MyWorkObject()
            work.nameLabelString = employee.displayName
            work.leftImageUrl = employee.avatarURL
            work.firstTagString = employee.place
            work.secondTagString = String(employee.workTime)
            work.thirdTagString = String(employee.projectTotal)
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
            p.name = data["project_name"].string!
            p.place = data["org_name"].string!
            p.scheduleNum = data["schedule_num"].int!
            p.paidNum  = data["paid_num"].string!.toInt()!
            p.id       = data["project_id"].int!
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
        //TODO:需要一些产品的数据.
        var list = [Production]()
        
        for data in datas {
            let prod = Production()
            prod.id = data["item_id"].int!
            prod.name = data["item_name"].string!
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
