//
//  FormSettingVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/27.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class FormSettingVC: UIViewController {
    
    var tableView: UITableView!
    
    var listOfCellTitle = ["现金","实操","产品","客流"]
    
    var listOfTitle = ["10K","30K","50K"]
    
    var cellId = "typeCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDailyReportMaxValues()
        setTableView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        tableView.delegate   = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func getDailyReportMaxValues() {
        
        NetworkManager.sharedManager.getDailyReportMaxVaule { (success, json, error) in
            
            if success == true {
                
            }
            else {
                //use realm data
            }
        }
        
    }
    
    
    
    
    
    
    
    
}

extension FormSettingVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            
            return "日报表峰值"
        }
        else {
            return nil
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! typeCell
        
        cell.accessoryType = .DisclosureIndicator
        cell.leftLabel.text = listOfCellTitle[indexPath.row]
        let index = Defaults.maxValue.value!
        cell.typeLabel.text = listOfTitle[index]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = MaxValueSettingVC()
        vc.title = "最大值"
        
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}
