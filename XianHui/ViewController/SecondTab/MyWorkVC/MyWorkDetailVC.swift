//
//  MyWorkDetailVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/28.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

class Order: NSObject {
    
    var customerName = ""
    var number = ""
    var goodName = ""
    var bedName = ""
    var employee = ""
    
    var startTime = ""
    var status = ""
    
}

class MyWorkDetailVC: UIViewController {
    
    var type:MyWorkType = .customer
    
    var objectId:Int!
    
    var objectName:String!
    
    var tableView:UITableView!
    
    var listOfOrder = [Order]()
    
    var profileJSON:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        setNavBarItem()
        setTableView()
        getOrderList()
        getProfileDetailData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
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
            urlString = getMyWorkScheduleListFromEmployeeUrl
            pramName = "project_id"
        case .prod:
            urlString = getMyWorkScheduleListFromEmployeeUrl
            pramName = "item_id"
            
        }
        
//        NetworkManager.sharedManager.getMyWorkScheduleListWith(urlString, idPramName: pramName, id: objectId) { (success, json, error) in
//            
//            if success == true {
//                
//            }
//            else {
//                
//            }
//            
//        }
        
    }
    
    
    func makeData(data:[JSON]) {
        
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
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "OrderCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? OrderCell
        if cell == nil {
            let nib = UINib(nibName: cellId, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: cellId)
            cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? OrderCell
        }
        
        
        
        
        
        
        
        
        return cell!
    }
    
    
}
