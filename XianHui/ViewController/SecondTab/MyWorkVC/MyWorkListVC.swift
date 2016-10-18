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
    
    var filterParams = JSONDictionary()
    
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
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 44))
        button.setTitle("筛选", forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        button.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        button.addTarget(self, action: #selector(MyWorkListVC.filterButtonTap), forControlEvents: .TouchUpInside)
        
        tableView.tableHeaderView = button
        
        // add MJRefresh
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            self.getDataFromServer(self.filterParams)
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
        
        setFilterView()
        getFilterData(JSONDictionary())
    }
    
    var filterView:XHSideFilterView!

    var blackOverlay = UIControl()
    
    func setFilterView() {
        
        let inView = UIApplication.sharedApplication().keyWindow!
        self.blackOverlay.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.blackOverlay.frame = CGRect(x: 0, y: 0, width: inView.bounds.width, height: inView.bounds.height)
        
        self.blackOverlay.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        self.blackOverlay.alpha = 0
        
        inView.addSubview(self.blackOverlay)
        
        self.blackOverlay.addTarget(self, action: #selector(MyWorkListVC.blackOverlayTap), forControlEvents: .TouchUpInside)
        
        filterView = XHSideFilterView(frame: CGRect(x: 40, y: 0, width: screenWidth - 40, height: screenHeight))
        filterView.frame.origin.x = screenWidth
        
        inView.addSubview(filterView)
        
        
        filterView.confirmHandler = {
            self.blackOverlayTap()
        }
        
        filterView.filterSelected = {
            (models) in
            var dict = JSONDictionary()
            for model in models {
                let name = model.paramName
                let id = model.id
                
                var isSameParam = false
                
                for (key,value) in dict {
                    
                    if key == name {
                        //参数类型相同
                        isSameParam = true
                        let stringValue = value as! String
                        dict[key] = stringValue + "," + id
                    }
                    
                }
                
                //无相同参数类型,新增一个.
                if isSameParam == false {
                    dict += [
                       name:id
                    ]
                }
            }
            
            self.getFilterData(dict)
            
        }
        
    }
    
    func filterButtonTap() {
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
            self.filterView.frame.origin.x = 40
            self.blackOverlay.alpha = 1.0
            }, completion: nil)
        
    }
    
    func blackOverlayTap() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
            self.filterView.frame.origin.x = screenWidth
            self.blackOverlay.alpha = 0.0
            }, completion: nil)
        
    }
    
    func clearDataBeforeFilterSuccess() {
        
        self.dataHelper.dataArray =  [MyWorkObject]()
        self.pageNumber = 1
        self.jsons = [JSON]()
        self.tableView.reloadData()
        
        
        
    }
    
    func getFilterData(params:JSONDictionary) {
        
        var urlString = ""
        switch self.type {
        case .customer:
            urlString = getMyCustomerListFilterDataUrl
        case .employee:
            urlString = getMyColleaguesListFilterDataUrl
        case .project:
            urlString = getMyProjectListFilterDataUrl
        case .prod:
            urlString = getMyProdListFilterDataUrl
        }
        
        
        showHudWith(filterView, animated: true, mode: .Indeterminate, text: "")
        
        NetworkManager.sharedManager.getMyWorkListFilterDataWith(params,urlString:urlString) { (success, json, error) in
            hideHudFrom(self.filterView)
            if success == true {
                
                if let datas = json?.array {
                    self.filterView.dataArray = self.makeFilterTableViewWith(datas)
                    self.filterView.collectionView.reloadData()
                    self.clearDataBeforeFilterSuccess()
                    self.filterParams = params
                    self.getDataFromServer(self.filterParams)
                }
                
            }
            else {
                
            }
        }
        
    }
    
    func makeFilterTableViewWith(datas:[JSON])  -> [XHSideFilterDataList] {
        var arr = [XHSideFilterDataList]()
        for data in datas {
            
            let list = XHSideFilterDataList()
            if let sectionName = data["name"].string {
                list.name = sectionName
            }
            
            if let sectionDatas = data["list"].array {
                
                for sectionData in sectionDatas {
                    let model = XHSideFilterDataModel()
                    
                    if let paramName = data["param"].string{
                        model.paramName = paramName
                    }
                    
                    if let name = sectionData["text"].string{
                        model.name = name
                    }
                    
                    if let idString = sectionData["value"].string {
                        model.id = idString
                    }
                    if let selected = sectionData["selected"].bool {
                        model.selected = selected
                    }
                    
                    list.list.append(model)
                }
            }
            
            arr.append(list)

        }
        return arr
    }
    
    

    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "暂无数据"
        
        let attrString = NSAttributedString(string: text)
        
        return attrString
    }
    
    var pageSize = 20
    
    var pageNumber = 1
    
    func getDataFromServer(params:JSONDictionary) {
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
        
        
        NetworkManager.sharedManager.getMyWorkListWith(params,urlString:urlString, pageSize: pageSize, pageNumber: pageNumber) { (success, json, error) in
            
            if success == true {
                if let rows = json!["rows"].array {
                    
                    if rows.count == 0 {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    else {
                        self.tableView.mj_footer.endRefreshing()
                        self.pageNumber += 1
                        self.jsons += rows
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
                c.time  = days
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
            
            if let avator_url = data["avator_url"].string {
                p.avatarUrl = avator_url
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
            
            if let orgName = data["org_name"].string {
                prod.place = orgName
            }
            
            if let avator_url = data["avator_url"].string {
                prod.avatarUrl = avator_url
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
            work.leftImageUrl = p.avatarUrl
            work.firstTagString = p.place
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
