//
//  CustomerProfileVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/5.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class CustomerProfileVC: UIViewController {
    
    var tableView:UITableView!
    
    let topCellId = "CustomerLargeCell"
    
    let typeCellId = "typeCell"
    
    //Data
    var customer:Customer!

    let typeList = ["客服经理","他的卡包","消费记录","项目计划","预约信息"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib0 = UINib(nibName: topCellId, bundle: nil)
        tableView.registerNib(nib0, forCellReuseIdentifier: topCellId)
        
        let nib1 = UINib(nibName: typeCellId, bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: typeCellId)
        
        
        
    }
    
    

}

extension CustomerProfileVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else {
            return 5
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.001
        }
        else {
            return 30
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(topCellId, forIndexPath: indexPath) as! CustomerLargeCell
            
            cell.avatarImageView.backgroundColor = UIColor.lightGrayColor()
            cell.nameLabel.text = "顾客姓名"
            cell.vipLabel.text = "vip4"
            cell.numberLabel.text = "档案编号:13131313131"
            
            
            return cell
            
        }
        else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(typeCellId, forIndexPath: indexPath) as! typeCell
            cell.leftLabel.text = typeList[indexPath.row]
            if indexPath.row == 0 {
                cell.typeLabel.text = "陈旭"
                
            }
            else if indexPath.row == 1 {
                cell.accessoryType = .DisclosureIndicator
                cell.typeLabel.text = "共4张"
            }
            else if indexPath.row == 2 {
                cell.accessoryType = .DisclosureIndicator
                cell.typeLabel.text = "16/08/12"
            }
            else if indexPath.row == 3 {
                cell.accessoryType = .DisclosureIndicator
                cell.typeLabel.text = "去设置"
            }
            else {
                cell.accessoryType = .DisclosureIndicator
                cell.typeLabel.text = "16/12/34"
            }
            
            
            return cell
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            if indexPath.row == 3 {
                
                let vc = ProjectPlanningVC()
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else if indexPath.row == 4 {
                let vc = ProjectPlannedVC()
                vc.title = "预约信息"
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
