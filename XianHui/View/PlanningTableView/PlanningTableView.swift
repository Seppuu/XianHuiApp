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
        
        backgroundColor = UIColor.white
        
        tableView = UITableView(frame: bounds, style: .grouped)
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 44
        }
        else {
            return 22
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cell"
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        
        if (indexPath as NSIndexPath).section == 0 {
            
            cell.textLabel?.text = "增加项目"
            
            let frame = CGRect(x:screenWidth - 20 - 22, y: 11, width: 22, height: 22)
            let addImageView = UIImageView(frame: frame)
            addImageView.contentMode = .center
            addImageView.image = UIImage(named: "addButton")
            
            cell.contentView.addSubview(addImageView)
            
        }
        else if (indexPath as NSIndexPath).section == 1 {
            
            let project = listOfProject[(indexPath as NSIndexPath).row]
            
            cell.textLabel?.text = project.name
            
        }
        else {
            
            let prod = listOfProd[(indexPath as NSIndexPath).row]
            
            cell.textLabel?.text = prod.name
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 {
            addRowTapHandler?()
        }
        else {
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
