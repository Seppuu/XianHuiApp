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
    
    var listOfTitle = ["10K","30K","50K"]
    
    var selectedIndex = Defaults.maxValue.value!
    
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
        return listOfTitle.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.accessoryType = .None
        if indexPath.item == selectedIndex {
            cell.accessoryType = .Checkmark
        }
        
        cell.textLabel?.text = listOfTitle[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        Defaults.maxValue.value = Int(indexPath.item)
        selectedIndex = Defaults.maxValue.value!
        
        navigationController?.popViewControllerAnimated(true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}