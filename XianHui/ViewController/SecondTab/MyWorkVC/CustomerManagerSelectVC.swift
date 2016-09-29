//
//  CustomerManagerSelectVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/29.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class CustomerManagerSelectVC: UIViewController {
    
    var tableView:UITableView!
    
    var listOfEmployee = [Manager]()
    
    var customer = Customer()

    let cellId = "typeCell"
    
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
        //TODO:net work
        for i in 0...8 {
            var m = Manager()
            m.displayName = "赵微微"
            
            if i == 4 {
                m.selected = true
            }
            
            listOfEmployee.append(m)
        }
        
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
            cell!.typeLabel.text = "16/12/05"
            
            
            
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
        //TODO:
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! typeCell
        cell.accessoryType = .Checkmark
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! typeCell
        cell.accessoryType = .None
    }
    
}
