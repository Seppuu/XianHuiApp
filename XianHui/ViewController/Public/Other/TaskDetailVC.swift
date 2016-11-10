//
//  TaskDetailVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/11/10.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class TaskDetailVC: UIViewController {
    
    var tableView:UITableView!
    
    var topCellId = "ConversationCell"
    
    var bottomCellId = "typeCell"
    
    var segmentView = UISegmentedControl()

    override func viewDidLoad() {
        super.viewDidLoad()

       setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: topCellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: topCellId)
        
        let nib1 = UINib(nibName: bottomCellId, bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: bottomCellId)
        
        view.addSubview(tableView)
        
    }
    
    var currentIndex = 0
    
    func segmentVauleChanged(_ sender:UISegmentedControl) {
        currentIndex = sender.selectedSegmentIndex
        tableView.reloadData()
    }
    

}

extension TaskDetailVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 76
        }
        else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            
            let containr = UIView()
            containr.frame = CGRect(x: 0, y:0, width: screenWidth, height: 46)
            let segment = UISegmentedControl(items: ["顾问","技师","客人"])
            segment.frame = CGRect(x: 16, y: 8, width: screenWidth - 16 * 2, height: 46 - 8*2)
            segment.selectedSegmentIndex = currentIndex
            segment.addTarget(self, action: #selector(TaskDetailVC.segmentVauleChanged(_:)), for: .valueChanged)
            segment.layer.borderColor = UIColor.init(hexString: "236C51").cgColor
            segment.tintColor = UIColor.init(hexString: "236C51")
            containr.addSubview(segment)
            
            return containr
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        else {
            return 46
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: topCellId, for: indexPath) as! ConversationCell
            
            cell.layoutMargins = UIEdgeInsetsMake(0, 76, 0, 0)
            cell.avatarImageView.image = UIImage(named: "TaskIcon")
            cell.nameLabel.text = "全公司"
            
            return cell
        }
        else {
//            let baseModel = listArray[(indexPath as NSIndexPath).section].list[(indexPath as NSIndexPath).row]
            
            let cellId = "typeCell"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: bottomCellId) as? typeCell
            cell?.selectionStyle = .none
            if cell == nil {
                let nib = UINib(nibName: cellId, bundle: nil)
                tableView.register(nib, forCellReuseIdentifier: cellId)
                cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? typeCell
            }
            
            cell?.leftLabel.text = "名字"
            cell?.typeLabel.text = "详细"
            cell?.typeLabel.textAlignment = .right
            

            return cell!
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}


