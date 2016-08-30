//
//  TrackingTableView.swift
//  XianHui
//
//  Created by jidanyu on 16/8/22.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class TrackingTableView: UIView, UITableViewDelegate,UITableViewDataSource {
    
    var parentVC:UIViewController!

    var tableView:UITableView!

    var listOfProject = [Project]()
    
    var listOfProduction = [Production]()
    
    var section0Title = "消费中的项目 (剩余次数)"
    
    var section1Title = "消费中的产品 (剩余天数)"
    
    var cellId = "progressCell"
    
    var prodCellTapHandler:((prod:Production)->())?
    
    override func didMoveToSuperview() {
        
        backgroundColor = UIColor.whiteColor()
        
        tableView = UITableView(frame: bounds, style: .Grouped)
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
           return listOfProject.count
        }
        else {
           return listOfProduction.count
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return section0Title
        }
        else {
            return section1Title
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! progressCell
        
        if indexPath.section == 0 {
            let project = listOfProject[indexPath.row]
            
            cell.nameLabel.text = project.name
            
            cell.uaProgressView.setProgress(project.remainingTime, animated: true)
            cell.progressLabel.text = project.remainingTimeString
        }
        else {
            let prod = listOfProduction[indexPath.row]
            
            cell.nameLabel.text = prod.name
            
            if prod.startDay == "" {
                cell.tipLabel.alpha = 1.0
                cell.uaProgressView.alpha = 0.0
                cell.tipLabel.text = "去设置"
            }
            else {
                cell.tipLabel.alpha = 0.0
                cell.uaProgressView.alpha = 1.0
                
                cell.uaProgressView.setProgress(prod.remainingTime, animated: true)
                cell.progressLabel.text = prod.remainedDay
            }
            
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.section == 1 {
            
            let prod = listOfProduction[indexPath.row]
            
            let vc = ProdDateSetVC()
            vc.prod = prod
            
            let nav = UINavigationController(rootViewController: vc)
            
            self.parentVC.presentViewController(nav, animated: true, completion: nil)
            
            
            vc.confirmTapHandler = {
                (prod) in
                
                self.listOfProduction[indexPath.row] = prod
                
                self.tableView.reloadData()
                
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    


}
