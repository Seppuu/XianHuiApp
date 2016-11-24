//
//  CustomerCardListVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/29.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

//卡包列表
class CustomerCardListVC: BaseTableViewController {
    
    var customer = Customer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func getData() {
        
        NetworkManager.sharedManager.getCustomerCardListWith(customer.id) { (success, json, error) in
            if success == true {
                if let arr = json?.array {
                   self.makeData(arr)
                }
                
            }
            else {
                
            }
            
        }
    }

    
    func makeData(_ datas:[JSON]) {
        
        let section0 = BaseTableViewModelList()
        let section1 = BaseTableViewModelList()
        
        for data in datas {
            
            let  card_sort = data["card_sort"].int!
            if card_sort == 1 {
                //会员卡
                let model = BaseTableViewModel()
                if let fullName = data["fullname"].string {
                    model.name = fullName
                }
                
                if let amount = data["amount"].string {
                    model.desc = "余"  + amount
                }
                
                if let cardNum = data["card_num"].string {
                    model.num = cardNum
                }
                
                model.hasList = true
                section0.listName = "会员卡"
                section0.list.append(model)
            }
            else if card_sort == 3 {
                //疗程卡
                let model = BaseTableViewModel()
                if let fullName = data["fullname"].string {
                    model.name = fullName
                }
                
                if let cardNum = data["card_num"].string {
                    model.num = cardNum
                }
                
                if let project_list = data["project_list"].array {
                    for p in project_list {
                        var times = 0
                        times += p["times"].string!.toInt()!
                        model.desc = String(times) + "次"
                    }
                    
                }
                
                model.hasList = true
                section1.listName = "疗程卡"
                section1.list.append(model)
                
            }
            else {
                
            }
            
        }
        
        self.listArray = [section0,section1]
        self.tableView.reloadData()
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.listArray[(indexPath as NSIndexPath).section].list[(indexPath as NSIndexPath).row]
        
        let vc = CustomerCardDetailVC()
        vc.cardNum = model.num
        vc.title = model.name
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }

}

