//
//  CustomerManagerSelectVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/29.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class CustomerManagerSelectVC: UIViewController {
    
    var tableView:UITableView!
    
    var listOfEmployee = [Manager]()
    
    var customer = Customer()

    let cellId = "typeCell"
    
    var updateTime = "无"
    
    var setManagerHandler:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "顾问选择"
        setTableView()
        getListOfManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func setTableView() {
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
    }
    
    func getListOfManager() {
        
        NetworkManager.sharedManager.getCustomerAdviserWith(customer.id) { (success, json, error) in
            
            if success == true {
                    self.makeDataModel(json!)
            }
            else {
                
            }
        }
        
        
        
        
    }
    
    func makeDataModel(data:JSON) {
        
        if let updateTime = data["update_time"].string {
            self.updateTime = updateTime
        }
        
        var list = [Manager]()
        for e in data["rows"].array! {
            
            let m = Manager()
            m.displayName = e["display_name"].string!
            if let selected = e["selected"].bool {
                m.selected = selected
            }
            
            m.id = e["user_id"].int!
            
            list.append(m)
            
            
            
        }
        listOfEmployee = list
        tableView.reloadData()
    }
    

}

extension CustomerManagerSelectVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return listOfEmployee.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? typeCell
        if cell == nil {
            let nib = UINib(nibName: cellId, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: cellId)
            cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? typeCell
        }
        
        if indexPath.section == 0 {
            
            cell!.leftLabel.text = "变更日期"
            cell!.typeLabel.text = updateTime
            
            
            
        }
        else {
            
            let manager = listOfEmployee[indexPath.row]
            cell?.leftLabel.text = manager.displayName
            cell!.typeLabel.text = ""
            if manager.selected == true  {
                cell!.accessoryType = .Checkmark
            }
            else {
                cell!.accessoryType = .None
            }
        }
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            return
        }
        
        let manger = listOfEmployee[indexPath.row]
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = .Indeterminate
        
        NetworkManager.sharedManager.setCustomerAdviserWith(customer.id, advisderId: manger.id) { (success, json, error) in
            
            if success == true {
                hud.hide(true, afterDelay: 0.5)
                
                self.getListOfManager()
                
                self.setManagerHandler?()
            }
            else {
                
            }
        }
        
        
        
    }
    
    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        cell?.accessoryType = .None
//        
//    }
    
}
