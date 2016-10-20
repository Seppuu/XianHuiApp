//
//  MyWorkDetailVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/28.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON
import DZNEmptyDataSet
import MJRefresh

class Order: NSObject {
    
    var customerName = ""
    var goodNo = ""
    var goodName = ""
    var bedName = ""
    var employee = ""
    
    var startTime = ""
    var status = ""
    
    var numbers = ""
    var isProd = false
    
}

let CustomerPlannHasAddNoti = "CustomerPlannHasAddNoti"

class MyWorkDetailVC: UIViewController ,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var type:MyWorkType = .customer
    
    var objectId:Int!
    
    var objectName:String!
    
    var tableView:UITableView!
    
    var listOfOrder = [Order]()
    
    var profileJSON:JSON!
    
    var noPlan = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        setNavBarItem()
        addNoti()
        setTableView()
        
        getProfileDetailData()
        
        showPlanRemindIfNeed()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func addNoti() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyWorkDetailVC.hidePlanRemindIfNeed), name: CustomerPlannHasAddNoti, object: nil)
        
    }
    
    func setNavBarItem() {
        
        let rightBarItem = UIBarButtonItem(title: "资料", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MyWorkDetailVC.settingTap(_:)))
        navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    var profileDetailJSON:JSON!
    
    func getProfileDetailData() {
        
        //获取顾客详细资料
        
        NetworkManager.sharedManager.getCustomerDetailWith(objectId) { (success, json, error) in
            
            if success == true {
                self.profileDetailJSON = json!
            }
            else {
                
            }
            
        }
        
    }
    
    func settingTap(sender:UIBarButtonItem) {
        
        if self.type == .customer {
            let vc = CustomerProfileVC()
            vc.title = "详细资料"
            vc.customerId = objectId
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if self.type == .employee {
            
            
            let vc = EmployeeProfileVC()
            vc.title = "详细资料"
            vc.type = self.type
            vc.profileJSON = profileJSON
            vc.profileDetailJSON = profileJSON
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        else if self.type == .project {
            
            NetworkManager.sharedManager.getProjectProfileWith(objectId, completion: { (success, json, error) in
                if success == true {
                    let vc = GoodProfileVC()
                    vc.title = "详细资料"
                    vc.type = self.type
                    vc.profileJSON = json
                    vc.profileDetailJSON = json
                    vc.isProject = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    
                }
            })
            
            
        }
        else if self.type == .prod {
            
            NetworkManager.sharedManager.getProdProfileWith(objectId, completion: { (success, json, error) in
                
                if success == true {
                    let vc = GoodProfileVC()
                    vc.title = "详细资料"
                    vc.type = self.type
                    vc.profileJSON = json
                    vc.profileDetailJSON = json
                    vc.isProject = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    
                }
                
            })
        }
        else {
            
        }
        
    }
    
    func setTableView() {
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        // add MJRefresh
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getOrderList()
            
        })
        
        tableView.mj_header.beginRefreshing()
        
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "暂无数据"
        
        let attrString = NSAttributedString(string: text)
        
        return attrString
    }
    
    
    
    func getOrderList() {
        
        var urlString = ""
        var pramName = ""
        switch self.type {
        case .customer:
            urlString = getMyWorkScheduleListFromCustomerUrl
            pramName = "customer_id"
        case .employee:
            urlString = getMyWorkScheduleListFromEmployeeUrl
            pramName = "user_id"
        case .project:
            urlString = getMyWorkScheduleListFromProjectUrl
            pramName = "project_id"
        case .prod:
            urlString = getMyWorkScheduleListFromProdUrl
            pramName = "item_id"
            
        }
        
        NetworkManager.sharedManager.getMyWorkScheduleListWith(urlString, idPramName: pramName, id: objectId) { (success, json, error) in
            self.tableView.mj_header.endRefreshing()
            if success == true {
                if let rows = json!["rows"].array {
                    self.makeData(rows)
                }
            }
            else {
                
            }
            
        }
        
    }
    
    func makeData(datas:[JSON]) {
        
        var list = [Order]()
        
        for data in datas {
            let o = Order()
            if let customer_name = data["customer_name"].string {
               o.customerName = customer_name
            }
            
            if let number = data["project_code"].string {
                o.goodNo = number
            }
            
            if let number = data["flowno"].string {
                o.goodNo = number
                o.isProd = true
            }
            
            if let numbers = data["qty"].string {
                o.numbers = numbers
            }
            
            if let goodName = data["project_name"].string {
                o.goodName = goodName
            }
            
            if let goodName = data["item_name"].string {
                o.goodName = goodName
                o.isProd = true
            }
            
            
            if let bedName = data["bed_name"].string {
                o.bedName = bedName
            }
            
            if let engineer_name = data["engineer_name"].string {
                o.employee = engineer_name
            }
            
            if let status = data["status"].string {
                o.status = status
            }
            
            if let startTime  = data["start_time"].string {
                o.startTime = startTime
            }
            
            list.append(o)
        }
        
        self.listOfOrder = list
        self.tableView.reloadData()
        
    }
    
    var statusLabel = UILabel()
    
    func showPlanRemindIfNeed() {
        
        if self.type == .customer && noPlan == true {
            //顾客列表进入,并且无计划,显示快捷按钮.去往计划设置.
            statusLabel.frame =  CGRect(x: 0, y: 64, width: screenWidth, height: 40)
            view.addSubview(statusLabel)
            statusLabel.text = "该顾客当前无销售计划,请点击设置"
            statusLabel.textColor = UIColor.darkTextColor()
            statusLabel.textAlignment = .Center
            statusLabel.backgroundColor = UIColor.whiteColor()
            statusLabel.font = UIFont.systemFontOfSize(14)
            let tap = UITapGestureRecognizer(target: self, action: #selector(MyWorkDetailVC.showPlannSettingVC))
            statusLabel.userInteractionEnabled = true
            statusLabel.addGestureRecognizer(tap)
        }
        else {
            
        }
        
    }
    
    func hidePlanRemindIfNeed() {
        statusLabel.removeFromSuperview()
    }
    
    func showPlannSettingVC() {
        
        let vc = ProjectPlanningVC()
        let customer = Customer()
        customer.id = objectId
        vc.customer = customer
        self.navigationController?.pushViewController(vc, animated: true)

        
    }
    
}


extension MyWorkDetailVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfOrder.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "OrderCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? OrderCell
        if cell == nil {
            let nib = UINib(nibName: cellId, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: cellId)
            cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? OrderCell
        }
        
        cell?.selectionStyle = .None
        
        let order = self.listOfOrder[indexPath.row]
        
        cell?.firstLabel.text = "顾客:" + order.customerName
        cell?.secondLabel.text = "编号:" + order.goodNo
        cell?.thirdLabel.text = "品名:" + order.goodName
        
        cell?.fifthLabel.text = "技师:" + order.employee
        
        if order.isProd == true {
            cell?.forthlabel.text = "数量:" + order.numbers
            cell?.secondRightLabel.text = ""
        }
        else {
            cell?.forthlabel.text = "床位:" + order.bedName
            cell?.secondRightLabel.text =  "开始时间:" + order.startTime
        }
        
        
        cell?.rightLabel.text = order.status
        
        
        return cell!
    }
    
    
}
