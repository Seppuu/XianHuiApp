//
//  MyCustomerVC.swift
//  XianHui
//
//  Created by jidanyu on 16/8/21.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

enum CustomerLisType:String {
    case All = "all"
    case Plan = "plan"
    case Advice = "advice"
    case Service = "service"
}

//待计划,待咨询,待售后,全部.
class MyCustomerVC: BaseViewController {
    
    var tableView:UITableView!
    
    var parentVC:UIViewController?
    
    var parentNavigationController : UINavigationController?
    
    let cellId = "CustomerCell"
    
    var type = CustomerLisType.All
    
    var listOfCustommer = [Customer]()

    override func viewDidLoad() {
        super.viewDidLoad()

        getCustomList()
        view.backgroundColor = UIColor.whiteColor()
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCustomList() {
        
//            NetworkManager.sharedManager.getCustomerListWith(type) { (success, json, error) in
//                
//                if success == true {
//                    
//                    let jsonArr = json!.array!
//                    self.listOfCustommer = self.makeCustomerListWith(jsonArr)
//                    
//                    self.tableView.reloadData()
//                    
//                }
//                else {
//                    
//                }
//                
//            }
//            
        
    }
    
    func makeCustomerListWith(dataArr:[JSON]) -> [Customer] {
        
        var list = [Customer]()
        
        for data in dataArr {
            
            let customer = Customer()
            customer.id = data["customer_id"].int!
            customer.guid = data["guid"].string!
            customer.name = data["fullname"].string!
            customer.avatarUrlString = data["avator_url"].string!
            
            customer.happyLevel = "满意度:\(data["score"].int!)"
            
            
            customer.lastProject = "天地藏浴 冬阴功补"
            customer.lastProduction = "牛樟芝 益畅菌"
            customer.time = "4天"
            

            let type = data["type"].string!
            switch  type {
            case "plan":
                customer.type = CustomerLisType.Plan
                
                list.append(customer)
                
            case "advice":
                customer.type = CustomerLisType.Advice
                list.append(customer)
            
            case "service":
                customer.type = CustomerLisType.Service
                list.append(customer)
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
        cell.stageLabel.text = customer.type.rawValue
        cell.happyLevel.text = customer.happyLevel
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let customer = listOfCustommer[indexPath.row]
        let vc = CustomerProfileVCViewController()
        vc.customer = customer
        
        parentVC?.presentViewController(vc, animated: true, completion: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
   
}