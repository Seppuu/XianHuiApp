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
        
        backgroundColor = UIColor.white
        
        tableView = UITableView(frame: bounds, style: .grouped)
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfProject[section].count
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = chatSectionView.instanceFromNib()
        view.backgroundColor = UIColor.ddViewBackGroundColor()
        view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 22)
        
        view.dateLabel.text = days[section]
        
        if section == 0 {
            view.sectionTitleLabel.alpha = 1.0
            view.firstTagView.alpha = 1.0
            view.firsTagLabel.alpha = 1.0
            
            view.sectionTagView.alpha = 1.0
            view.secondTagLabel.alpha = 1.0
            
            
        }
        else {
            
            view.sectionTitleLabel.alpha = 0.0
            view.firstTagView.alpha = 0.0
            view.firsTagLabel.alpha = 0.0
            
            view.sectionTagView.alpha = 0.0
            view.secondTagLabel.alpha = 0.0
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! chatTableViewCell
        cell.selectionStyle = .none
        let project = listOfProject[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    
}
