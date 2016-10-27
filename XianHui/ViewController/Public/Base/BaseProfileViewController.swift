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
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.listArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return super.tableView(tableView, numberOfRowsInSection: section - 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        else {
            return super.tableView(tableView, titleForHeaderInSection: section - 1 )
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            return 80
        }
        else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let cellId = "CustomerLargeCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CustomerLargeCell
            if cell == nil {
                let nib = UINib(nibName: cellId, bundle: nil)
                tableView.register(nib, forCellReuseIdentifier: cellId)
                cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CustomerLargeCell
            }
            cell!.selectionStyle = .none
            if let url = URL(string:profileModel.avatarUrl)  {
                cell!.avatarImageView.kf.setImage(with: url)
            }
            cell!.nameLabel.text = profileModel.firstLabelString
            cell!.vipLabel.text = profileModel.secondLabelString
            cell!.numberLabel.text = profileModel.thirdLabelString
            
            
            return cell!
        }
        else {
            let currentPath = IndexPath(item: (indexPath as NSIndexPath).item, section: (indexPath as NSIndexPath).section - 1)
            return super.tableView(tableView, cellForRowAt: currentPath)
        }
    }
    
   
    
    
}
