//
//  DropDownView.swift
//  XianHui
//
//  Created by jidanyu on 2017/1/4.
//  Copyright © 2017年 mybook. All rights reserved.
//

import UIKit

class DropDownView: UIView {

    var tableView:UITableView!
    
    var beginDate = Date() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var endDate   = Date(){
        didSet {
            tableView.reloadData()
        }
    }
    
    var confirmTapHandler:(()->())?
    
    var beginTapHandler:(()->())?
    
    var endTapHandler:(()->())?
    
    override func didMoveToSuperview() {
        self.backgroundColor = UIColor.white
        setTableView()
    }
    
    var cellId = "typeCell"
    
    func setTableView() {
        
        tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.frame.origin.y = 22
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        self.addSubview(tableView)
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    var firstTap = false
    
    var secondTap = false

}

extension DropDownView:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! typeCell
            cell.selectionStyle = .none
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY/MM/dd"
            
            if indexPath.row == 0 {
                cell.leftLabel.text = "开始"
                cell.typeLabel.text = dateFormatter.string(from: beginDate)
                
                if firstTap == true {
                    cell.dotView.alpha = 1.0
                }
                else {
                    cell.dotView.alpha = 0.0
                }
            }
            else {
                cell.leftLabel.text = "结束"
                cell.typeLabel.text = dateFormatter.string(from: endDate)
                
                if secondTap == true {
                    cell.dotView.alpha = 1.0
                }
                else {
                    cell.dotView.alpha = 0.0
                }
            }
            
            return cell
        }
        else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            let label = UILabel(frame: cell.frame)
            cell.addSubview(label)
            label.text = "确认"
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.init(hexString: "4089DE")
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0 {
            beginTapHandler?()
            firstTap = true
            secondTap = false
        }
        else if indexPath.row == 1 {
            endTapHandler?()
            secondTap = true
            firstTap = false
        }
        else if indexPath.row == 2 {
            confirmTapHandler?()
        }
        
        tableView.reloadData()
    }
    
    
}
