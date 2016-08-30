//
//  PlanningTableView.swift
//  XianHui
//
//  Created by jidanyu on 16/8/22.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class PlanningTableView: UIView ,UITableViewDelegate,UITableViewDataSource{

    
    var tableView:UITableView!
    
    var addRowTapHandler:(()->())?
    
    var listOfProject = [Project]()
    
    var listOfProd = [Production]()
    
    var sectionTitle = "客户计划"
    
    override func didMoveToSuperview() {
        
        backgroundColor = UIColor.whiteColor()
        
        tableView = UITableView(frame: bounds, style: .Grouped)
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return listOfProject.count
        }
        else {
            return listOfProd.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 44
        }
        else {
            return 22
        }
        
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
           return sectionTitle
        }
        else if section == 1 {
            return listOfProject.count > 0 ? "计划的项目" : nil
        }
        else {
            return listOfProd.count > 0 ?  "计划的产品" : nil 
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cell"
        let cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        
        if indexPath.section == 0 {
            
            cell.textLabel?.text = "增加项目"
            
            let frame = CGRect(x:screenWidth - 20 - 22, y: 11, width: 22, height: 22)
            let addImageView = UIImageView(frame: frame)
            addImageView.contentMode = .Center
            addImageView.image = UIImage(named: "addButton")
            
            cell.contentView.addSubview(addImageView)
            
        }
        else if indexPath.section == 1 {
            
            let project = listOfProject[indexPath.row]
            
            cell.textLabel?.text = project.name
            
        }
        else {
            
            let prod = listOfProd[indexPath.row]
            
            cell.textLabel?.text = prod.name
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            addRowTapHandler?()
        }
        else {
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
