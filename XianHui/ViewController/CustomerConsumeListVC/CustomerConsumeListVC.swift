//
//  CustomerConsumeListVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/6.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomerConsumeListVC: UIViewController {
    
    var tableView:UITableView!

    var customer:Customer!
    
    var goodListArray = [[Good]]()
    
    var dateList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        getListWith(customer.id, pageSize: 20, pageNumber: 1)
        
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func getListWith(id:Int,pageSize:Int,pageNumber:Int) {
        
        NetworkManager.sharedManager.getCustomerConsumeListWith(id, pageSize: pageSize, pageNumber: pageNumber) { (success, json, error) in
            
            if success == true {
                let jsonData = json!["rows"].array!
                self.goodListArray = self.makeGoodListWith(jsonData)
                self.tableView.reloadData()
            }
            else {
                
            }
            
        }
    }
    
    func makeGoodListWith(json:[JSON]) -> [[Good]] {
        
        var list = [Good]()
        
        for g in json {
            
            let good = Good()
            good.name = g["fullname"].string!
            good.id   = g["item_id"].int!
            good.amount = g["amount"].string!
            good.saledate = g["saledate"].string!
            
            list.append(good)
        }
        
        var lastDate = ""
        
        list.forEach {
            
            if $0.saledate != lastDate {
                lastDate = $0.saledate
                
                dateList.append(lastDate)
            }
        }
        
        var listArray = [[Good]]()
        
        for date in dateList {
            
            var aList = [Good]()
            
            list.forEach{
                if $0.saledate == date {
                    aList.append($0)
                }
            }
            
            listArray.append(aList)
        }
        
        
        return listArray
        
    }
    
    let cellId = "typeCell"
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style:.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let nib  = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        
    }

}

extension CustomerConsumeListVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dateList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodListArray[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateList[section]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! typeCell
        cell.selectionStyle = .None
        
        let good = goodListArray[indexPath.section][indexPath.row]
        
        cell.leftLabel.text = good.name
        cell.typeLabel.text = good.amount + "元"
        
        return cell
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}





