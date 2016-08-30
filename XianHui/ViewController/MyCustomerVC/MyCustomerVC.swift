//
//  MyCustomerVC.swift
//  XianHui
//
//  Created by jidanyu on 16/8/21.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class MyCustomerVC: BaseViewController {
    
    var tableView:UITableView!
    
    var parentVC:UIViewController?
    
    var parentNavigationController : UINavigationController?
    
    let cellId = "CustomerCell"
    
    var listOfCustommer = [Customer]()

    override func viewDidLoad() {
        super.viewDidLoad()

        listOfCustommer = getCustomList()
        view.backgroundColor = UIColor.whiteColor()
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCustomList() -> [Customer]  {
        
        var list = [Customer]()
        
        for i in 0..<6 {
            
            let customer = Customer()
            customer.name = "郑霞\(i) vip\(i)"
            customer.avatarUrlString = ""
            
            customer.happyLevel = "满意度:5分"
            customer.lastProject = "天地藏浴 冬阴功补"
            customer.lastProduction = "牛樟芝 益畅菌"
            customer.time = "4天"
            
            switch i {
            case 0,1:
                customer.stage = "待咨询"
            case 2,3:
                customer.stage = "待计划"
            case 4,5:
                customer.stage = "待售后"
                
            default:break;
            }
            
            switch title! {
            case "全部":
                list.append(customer)
            case "待咨询":
                if customer.stage == "待咨询" {list.append(customer)}
                
            case "待计划":
                if customer.stage == "待计划" {list.append(customer)}
            case "待售后":
                if customer.stage == "待售后" {list.append(customer)}
            default:
                break;
            }
            
            
            
            
        }
        
        
        
        return list
        
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
    }
    

}

extension MyCustomerVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfCustommer.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! CustomerCell
        let customer = listOfCustommer[indexPath.row]
        
        cell.avatarView.backgroundColor = UIColor ( red: 0.8849, green: 0.8849, blue: 0.8849, alpha: 1.0 )
        cell.avatarView.layer.cornerRadius = cell.avatarView.ddWidth/2
        cell.avatarView.layer.masksToBounds = true
        
        cell.nameLabel.text = customer.name
        cell.stageLabel.text = customer.stage
        cell.happyLevel.text = customer.happyLevel
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let customer = listOfCustommer[indexPath.row]
        let vc = CustomerProfileVCViewController()
        
        switch customer.stage {
        case "待计划":
            vc.workType = .plan
        case "待咨询":
            vc.workType = .chat
        case "待售后":
            vc.workType = .track
        default:
            break;
        }
        
        parentVC?.presentViewController(vc, animated: true, completion: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
   
}