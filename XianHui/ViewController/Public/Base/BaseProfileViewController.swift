//
//  BaseProfileViewController.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/30.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileModel: NSObject {
    
    var avatarUrl = ""
    
    var firstLabelString = ""
    var secondLabelString = ""
    var thirdLabelString = ""
    
}

class BaseProfileViewController: BaseTableViewController {
    
    var profileModel = ProfileModel()
    
    var type:MyWorkType!

    var profileJSON:JSON!
    
    var profileDetailJSON:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getData() {
        
        //顶部cell信息
        profileModel = MyWorkManager.sharedManager.getBasicInfo(self.type, data: profileJSON)
        
        //下面的cell信息
        
        self.listArray = MyWorkManager.sharedManager.getBasicTableViewData(self.type, data: profileDetailJSON)
        
        self.tableView.reloadData()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.listArray.count + 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return super.tableView(tableView, numberOfRowsInSection: section - 1)
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        else {
            return super.tableView(tableView, titleForHeaderInSection: section - 1 )
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        else {
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellId = "CustomerLargeCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CustomerLargeCell
            if cell == nil {
                let nib = UINib(nibName: cellId, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellId)
                cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CustomerLargeCell
            }
            cell!.selectionStyle = .None
            if let url = NSURL(string:profileModel.avatarUrl)  {
                cell!.avatarImageView.kf_setImageWithURL(url)
            }
            cell!.nameLabel.text = profileModel.firstLabelString
            cell!.vipLabel.text = profileModel.secondLabelString
            cell!.numberLabel.text = profileModel.thirdLabelString
            
            
            return cell!
        }
        else {
            let currentPath = NSIndexPath(forItem: indexPath.item, inSection: indexPath.section - 1)
            return super.tableView(tableView, cellForRowAtIndexPath: currentPath)
        }
    }
    
   
    
    
}
