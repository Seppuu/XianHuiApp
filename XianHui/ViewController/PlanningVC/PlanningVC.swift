//
//  PlanningVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/5.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

//计划表
class PlanningVC: UIViewController {
    
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
    
    
    func getCustomList() {
        
        NetworkManager.sharedManager.getCustomerPlanListWith() { (success, json, error) in
            
            if success == true {
                
                let jsonArr = json!.array!
                self.makeCustomerListWith(jsonArr)
                
                self.tableView.reloadData()
                
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
            
            customer.time = "4天"
            
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
        
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
    }
}

extension PlanningVC: UITableViewDelegate,UITableViewDataSource {
    
    
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
        
        if indexPath.section == 0 {
            let customer = listOfCustommerNotPlanned[indexPath.row]
            
            cell.nameLabel.text = customer.name
            cell.stageLabel.text = "无"
           
            cell.happyLevel.text = "待计划"
            cell.happyLevel.textColor = UIColor.redColor()
            
        }
        else {
            let customer = listOfCustommerPlanned[indexPath.row]
            
            cell.nameLabel.text = customer.name
            cell.stageLabel.text = "无"
            
            cell.happyLevel.text = "计划:无"
            cell.stageLabel.text = "16/11/06"
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
        self.parentNavigationController!.pushViewController(vc, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    
}
