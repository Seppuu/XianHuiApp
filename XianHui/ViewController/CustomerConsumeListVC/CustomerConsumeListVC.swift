//
//  CustomerConsumeListVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/6.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class CustomerConsumeListVC: UIViewController {
    
    var tableView:UITableView!
    
    var records = [String]()

    var customer:Customer!
    
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
                
            }
            else {
                
            }
            
        }
    }
    
    let cellId = "type"
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style:.Plain)
        view.addSubview(tableView)
        
        let nib  = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
    }

}

extension CustomerConsumeListVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! typeCell
        cell.selectionStyle = .None
        cell.leftLabel.text = ""
        cell.typeLabel.text = ""
        
        return cell
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}






