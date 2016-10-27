//
//  CustomerCardDetailVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/29.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomerCardDetailVC: BaseTableViewController {

    var cardNum = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCardDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    func getCardDetail() {
        
        NetworkManager.sharedManager.getCustomerCardDetailWith(cardNum) { (success, json, error) in
            
            if success == true {
                if let rows = json!["rows"].array {
                    self.makeData(rows)
                }
            }
            else {
                
            }
        }
        
    }
    
    func makeData(_ datas:[JSON]) {
        
        let section0 = BaseTableViewModelList()
        
        for data in datas {
            let model = BaseTableViewModel()
            if let fullName = data["fullname"].string{
                model.name = fullName
            }
            
            if let amount = data["amount"].string{
                model.desc = amount
            }
            section0.listName = "消费明细"
            section0.list.append(model)
        }
        
        self.listArray = [section0]
        
        self.tableView.reloadData()
        
    }

}

