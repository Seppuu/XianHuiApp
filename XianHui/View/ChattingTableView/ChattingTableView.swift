//
//  ChattingTableView.swift
//  XianHui
//
//  Created by jidanyu on 16/8/22.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class ChattingTableView: UIView ,UITableViewDelegate,UITableViewDataSource{


    var tableView:UITableView!
    
    //var addRowTapHandler:(()->())?
    
    var listOfProject = [[Project]]()
    
    var days = [String]()
    
    var sectionTitle = "客户计划"
    
    var cellId = "chatTableViewCell"
    
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
        return days.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfProject[section].count
    
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = chatSectionView.instanceFromNib()
        view.backgroundColor = UIColor.ddViewBackGroundColor()
        view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 22)
        
        view.dateLabel.text = days[section]
        
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! chatTableViewCell
        cell.selectionStyle = .None
        let project = listOfProject[indexPath.section][indexPath.row]
        
        cell.nameLabel.text = project.name
        cell.timeLabel.text = project.time
        
        if project.planType == .salesman {
            cell.tagView.backgroundColor = UIColor ( red: 0.1961, green: 0.5569, blue: 0.8824, alpha: 1.0 )
        }
        else {
            cell.tagView.backgroundColor = UIColor ( red: 0.4324, green: 0.8085, blue: 0.1023, alpha: 1.0 )
        }
        
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

    
    
}
