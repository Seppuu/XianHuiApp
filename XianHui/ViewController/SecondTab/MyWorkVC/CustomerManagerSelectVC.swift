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
        tableView = UITableView(frame: view.bounds, style: .grouped)
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
    
    func makeDataModel(_ data:JSON) {
        
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return listOfEmployee.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? typeCell
        if cell == nil {
            let nib = UINib(nibName: cellId, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: cellId)
            cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? typeCell
        }
        
        if (indexPath as NSIndexPath).section == 0 {
            
            cell!.leftLabel.text = "变更日期"
            cell!.typeLabel.text = updateTime
        }
        else {
            
            let manager = listOfEmployee[(indexPath as NSIndexPath).row]
            cell?.leftLabel.text = manager.displayName
            cell!.typeLabel.text = ""
            if manager.selected == true  {
                cell!.accessoryType = .checkmark
            }
            else {
                cell!.accessoryType = .none
            }
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 {
            return
        }
        
        let manger = listOfEmployee[(indexPath as NSIndexPath).row]
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = .indeterminate
        
        NetworkManager.sharedManager.setCustomerAdviserWith(customer.id, advisderId: manger.id) { (success, json, error) in
            
            if success == true {
                hud?.hide(true, afterDelay: 0.5)
                
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
