//
//  MaxValueSettingVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/27.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class MaxValueSettingVC: UIViewController {

    var tableView:UITableView!
    
    var maxValue = MaxValue()
    
    //真正的值
    var listofkey:[String] {
        return Array(maxValue.list.keys)
    }
    //显示的字符
    var listOfvalue:[String] {
        var list = [String]()
        
        for key in listofkey {
            let v = maxValue.list[key]!
            list.append(v)
        }
        
        return list
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        tableView.delegate   = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
    }
    
}

extension MaxValueSettingVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfvalue.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let value = listOfvalue[indexPath.row]
        
        cell.textLabel?.text = value
        cell.accessoryType = .None
        if listofkey[indexPath.row] == String(maxValue.value) {
            
            cell.accessoryType = .Checkmark
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        maxValue.value = Int(listofkey[indexPath.row])!
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.accessoryType = .None
        
    }
}