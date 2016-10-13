//
//  CustomerProfileVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/5.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomerProfileVC: UIViewController {
    
    var tableView:UITableView!
    
    let topCellId = "CustomerLargeCell"
    
    let typeCellId = "typeCell"
    
    //Data
    var customer = Customer()
    
    var customerId:Int!

    let typeList = ["客服经理","他的卡包","消费记录","项目计划","预约信息"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        getCustomerDetail()
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getCustomerDetail() {
        
        NetworkManager.sharedManager.getCustomerDetailWith(customerId) { (success, json, error) in
            
            if success == true {
                
                self.updateCustomerMsgWith(json!)
                
                self.tableView.reloadData()
            }
            else {
                
            }
            
        }
    }
    
    func updateCustomerMsgWith(json:JSON) {
        
        self.customer.id = self.customerId
        if let certNo = json["basic"]["cert_no"].string {
            self.customer.certNo = certNo
        }
        if let fullName = json["basic"]["fullname"].string {
           self.customer.name = fullName
        }
        
        if let url = json["basic"]["avator_url"].string {
           self.customer.avatarUrlString = url
        }
        
        if let customer_manager = json["customer_manager"].string {
            self.customer.customerManager = customer_manager
        }
        
        if let last_consume_date = json["last_consume_date"].string {
            self.customer.lastConsumeDate = last_consume_date
        }
        
        if let card_total = json["card_total"].int {
            self.customer.cardTotal  = card_total
        }
        
        if let certNo = json["basic"]["cert_no"].string {
            self.customer.certNo    = certNo
        }
        
        if let planned = json["planed"].int {
            self.customer.planned   =  String(planned)
        }
    }
    
    func setTableView() {
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib0 = UINib(nibName: topCellId, bundle: nil)
        tableView.registerNib(nib0, forCellReuseIdentifier: topCellId)
        
        let nib1 = UINib(nibName: typeCellId, bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: typeCellId)
    }
}

extension CustomerProfileVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else {
            return 5
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.001
        }
        else {
            return 30
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(topCellId, forIndexPath: indexPath) as! CustomerLargeCell
            
            if let url = NSURL(string: customer.avatarUrlString) {
                cell.avatarImageView.kf_setImageWithURL(url)
            }
            
            cell.nameLabel.text = customer.name
            cell.vipLabel.text = customer.vipStar
            cell.numberLabel.text = customer.certNo
            
            
            return cell
            
        }
        else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(typeCellId, forIndexPath: indexPath) as! typeCell
            cell.leftLabel.text = typeList[indexPath.row]
            if indexPath.row == 0 {
                
                let currentUser = User.currentUser()
                if currentUser.reportType == 3 || currentUser.reportType == 4 {
                    //当用户是店长或者拉板时,可以更换顾问
                    cell.accessoryType = .DisclosureIndicator
                }
                else {
                    cell.accessoryType = .None
                }
                
                cell.typeLabel.text = customer.customerManager
                
            }
            else if indexPath.row == 1 {
                cell.accessoryType = .DisclosureIndicator
                cell.typeLabel.text = "共\(customer.cardTotal)张"
            }
            else if indexPath.row == 2 {
                cell.accessoryType = .DisclosureIndicator
                cell.typeLabel.text = customer.lastConsumeDate == nil ? "暂无" : customer.lastConsumeDate
            }
            else if indexPath.row == 3 {
                cell.accessoryType = .DisclosureIndicator
                if customer.planned == "1" {
                    cell.typeLabel.text = "已计划"
                }
                else {
                    cell.typeLabel.text = "去设置"
                }
                
            }
            else {
                cell.accessoryType = .DisclosureIndicator
                cell.typeLabel.text = customer.scheduleTime == "" ? "无新预约" : customer.scheduleTime
            }
            
            return cell
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let currentUser = User.currentUser()
                if currentUser.reportType == 3 || currentUser.reportType == 4 {
                    //当用户是店长或者拉板时,可以更换顾问
                    let vc = CustomerManagerSelectVC()
                    vc.customer = customer
                    vc.setManagerHandler = {
                        self.getCustomerDetail()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    return
                }
                
                
            }
            else if indexPath.row == 1 {
                let vc = CustomerCardListVC()
                vc.customer = customer
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 3 {
                
                let vc = ProjectPlanningVC()
                vc.customer = customer
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else if indexPath.row == 2 {
                let vc = CustomerConsumeListVC()
                vc.title = "消费记录"
                vc.customer = customer
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else if indexPath.row == 4 {
                let vc = ProjectPlannedVC()
                vc.customer = customer
                vc.allPlan = true
                vc.title = "预约信息"
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
  
    
}
