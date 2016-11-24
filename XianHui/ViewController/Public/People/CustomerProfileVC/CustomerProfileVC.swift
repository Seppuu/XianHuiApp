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

    let typeList = ["客服经理","他的卡包","消费记录","项目计划","预约信息","订单信息"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        getCustomerDetail()
        setTableView()
        setNavBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setNavBarItem() {
        
        let rightBarItem = UIBarButtonItem(title: "订单", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EmployeeProfileVC.settingTap))
        navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    func settingTap() {
        
        let vc = MyWorkDetailVC()
        vc.title = "订单信息"
        vc.objectId = customer.id
        vc.objectName = customer.name
        vc.type = .customer
        
        self.navigationController?.pushViewController(vc, animated: true)
        
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
    
    func updateCustomerMsgWith(_ json:JSON) {
        
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
            self.customer.cardTotal = card_total
        }
        
        if let certNo = json["basic"]["cert_no"].string {
            self.customer.certNo    = certNo
        }
        
        if let planned = json["planed"].int {
            self.customer.planned   =  String(planned)
        }
    }
    
    func setTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib0 = UINib(nibName: topCellId, bundle: nil)
        tableView.register(nib0, forCellReuseIdentifier: topCellId)
        
        let nib1 = UINib(nibName: typeCellId, bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: typeCellId)
    }
}

extension CustomerProfileVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            return 80
        }
        else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.001
        }
        else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: topCellId, for: indexPath) as! CustomerLargeCell
            
            if let url = URL(string: customer.avatarUrlString) {
                cell.avatarImageView.kf.setImage(with: url)
            }
            
            cell.nameLabel.text = customer.name
            cell.vipLabel.text = customer.vipStar
            cell.numberLabel.text = customer.certNo
            
            
            return cell
            
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: typeCellId, for: indexPath) as! typeCell
            cell.leftLabel.text = typeList[indexPath.row]
            if indexPath.row == 0 {
                
                let currentUser = User.currentUser()
                if currentUser?.reportType == 3 || currentUser?.reportType == 4 {
                    //当用户是店长或者拉板时,可以更换顾问
                    cell.accessoryView = UIImageView.xhAccessoryView()
                }
                else {
                    cell.accessoryView = UIImageView.xhAccessoryViewClear()
                }
                
                cell.typeLabel.text = customer.customerManager
                
            }
            else if indexPath.row == 1 {
                cell.accessoryView = UIImageView.xhAccessoryView()
                cell.typeLabel.text = "共\(customer.cardTotal)张"
            }
            else if indexPath.row == 2 {
                cell.accessoryView = UIImageView.xhAccessoryView()
                cell.typeLabel.text = customer.lastConsumeDate == nil ? "暂无" : customer.lastConsumeDate
            }
            else if indexPath.row == 3 {
                cell.accessoryView = UIImageView.xhAccessoryView()
                if customer.planned == "1" {
                    cell.typeLabel.text = "已计划"
                }
                else {
                    cell.typeLabel.text = "去设置"
                }
                
            }
            else if indexPath.row == 4 {
                cell.accessoryView = UIImageView.xhAccessoryView()
                cell.typeLabel.text = customer.scheduleTime == "" ? "无新预约" : customer.scheduleTime
            }
            else {
                cell.accessoryView = UIImageView.xhAccessoryView()
                cell.typeLabel.text = "服务状态"
            }
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let currentUser = User.currentUser()
                if currentUser?.reportType == 3 || currentUser?.reportType == 4 {
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
            else {
                //订单信息
                let vc = MyWorkDetailVC()
                vc.title = "订单信息"
                vc.objectId = customer.id
                vc.objectName = customer.name
                vc.type = .customer

                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  
    
}
