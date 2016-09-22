//
//  AllEmployeeListVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/22.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

///技师-预约表
class WorkerScheduleVC: UIViewController {
    
    var tableView:UITableView!
    
    var parentVC:UIViewController?
    
    var parentNavigationController : UINavigationController?
    
    let cellId = "CustomerCell"
    
    var type = CustomerLisType.All
    
    var listOfCustommerPlanned = [Customer]()
    
    var listOfCustommerNotPlanned = [Customer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCustomList()
        view.backgroundColor = UIColor.whiteColor()
        setTableView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getCustomList()
    }
    
    func getCustomList() {
        
        NetworkManager.sharedManager.getCustomerPlanListWith() { (success, json, error) in
            
            if success == true {
                
                if let jsonArr = json!.array {
                    self.makeCustomerListWith(jsonArr)
                    
                    self.tableView.reloadData()
                }
                else {
                    //no data
                }
                
            }
            else {
                
            }
        }
    }
    
    func makeCustomerListWith(dataArr:[JSON]) {
        
        var listPlanned = [Customer]()
        
        var listNotPlanned = [Customer]()
        
        for data in dataArr {
            
            let customer = Customer()
            customer.id = data["customer_id"].int!
            customer.guid = data["guid"].string!
            customer.name = data["fullname"].string!
            customer.avatarUrlString = data["avator_url"].string!
            
            customer.happyLevel = "满意度:\(data["score"].int!)"
            
            customer.planned = data["planed"].string!
            
            if customer.planned == "0" {
                listNotPlanned.append(customer)
            }
            else if customer.planned == "1" {
                listPlanned.append(customer)
            }
            else {
                
            }
            
        }
        
        self.listOfCustommerPlanned = listPlanned
        
        self.listOfCustommerNotPlanned = listNotPlanned
        
    }
    
    
    
    func setTableView() {
        
        //64是navbar+status 高度 40是"pageMenu"高度
        tableView = UITableView(frame: CGRectMake(0.0,0.0, self.view.frame.width, self.view.frame.height - 64 - 40), style: .Grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
    }
    
    func avatarTap(sender:UITapGestureRecognizer) {
        
        let point = sender.locationInView(tableView)
        
        let cellIndex = tableView.indexPathForRowAtPoint(point)!
        
        var customer:Customer!
        
        if cellIndex.section == 0 {
            customer = listOfCustommerNotPlanned[cellIndex.row]
        }
        else {
            customer = listOfCustommerPlanned[cellIndex.row]
        }
        
        
        let vc = CustomerProfileVC()
        vc.title = "详细资料"
        vc.customer = customer
        
        self.parentNavigationController?.pushViewController(vc, animated: true)
    }
}

extension WorkerScheduleVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listOfCustommerNotPlanned.count
        }
        else {
            return listOfCustommerPlanned.count
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "待计划"
        }
        else {
            return "已计划"
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    //当header 高度不起作用时,需要同时设置footer的高度.
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! CustomerCell
        
        cell.avatarView.backgroundColor = UIColor ( red: 0.8849, green: 0.8849, blue: 0.8849, alpha: 1.0 )
        cell.avatarView.layer.cornerRadius = cell.avatarView.ddWidth/2
        cell.avatarView.layer.masksToBounds = true
        cell.accessoryType = .DisclosureIndicator
        
        cell.avatarView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(PlanningVC.avatarTap(_:)))
        cell.avatarView.addGestureRecognizer(tap)
        
        if indexPath.section == 0 {
            
            let customer = listOfCustommerNotPlanned[indexPath.row]
            
            cell.nameLabel.text = customer.name
            cell.stageLabel.text = ""
            
            cell.happyLevel.text = "待计划"
            cell.happyLevel.textColor = UIColor.redColor()
            
        }
        else {
            
            let customer = listOfCustommerPlanned[indexPath.row]
            
            cell.nameLabel.text = customer.name
            
            cell.stageLabel.text = ""
            
            cell.happyLevel.text = ""
        }
        
        return cell
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var customer = Customer()
        
        if indexPath.section == 0 {
            
            customer = listOfCustommerNotPlanned[indexPath.row]
        }
        else {
            
            customer = listOfCustommerPlanned[indexPath.row]
        }
        
        let vc = ProjectPlanningVC()
        vc.customer = customer
        vc.saveGoodListCompletion = {
            
            self.getCustomList()
        }
        
        self.parentNavigationController!.pushViewController(vc, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    
}


