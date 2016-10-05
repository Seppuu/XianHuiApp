//
//  GoodProfileVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/10/5.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class GoodProfileVC: BaseProfileViewController {

    var isProject = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                let vc = GoodDetailListVC()
                vc.goodProfileType = .first
                vc.json = self.profileDetailJSON
                vc.isProject = isProject
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else if indexPath.row == 1 {
                let vc = GoodDetailListVC()
                vc.goodProfileType = .second
                vc.json = self.profileDetailJSON
                vc.isProject = isProject
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let vc = GoodDetailListVC()
                vc.goodProfileType = .third
                vc.json = self.profileDetailJSON
                vc.isProject = isProject
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            
        }
        else if indexPath.section == 2 {
            let baseModel = listArray[indexPath.section - 1].list[indexPath.row]
            let vc = BaseTableViewController()
            let listArr = BaseTableViewModelList()
            listArr.listName = ""
            listArr.list = baseModel.listData
            vc.listArray = [listArr]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            
        }
    }

}

class EmployeeProfileVC: BaseProfileViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        

    }
    
}
