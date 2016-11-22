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
    
    var objectId:Int!
    var objectName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setNavBarItem() {
        
        let rightBarItem = UIBarButtonItem(title: "订单", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EmployeeProfileVC.settingTap))
        navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    func settingTap() {
        
        let vc = MyWorkDetailVC()
        vc.title = objectName
        vc.objectId = objectId
        vc.objectName = objectName
        vc.type = self.type
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 1 {
            
            if (indexPath as NSIndexPath).row == 0 {
                let vc = GoodDetailListVC()
                vc.goodProfileType = .first
                vc.json = self.profileDetailJSON
                vc.isProject = isProject
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else if (indexPath as NSIndexPath).row == 1 {
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
        else if (indexPath as NSIndexPath).section == 2 {
            let baseModel = listArray[(indexPath as NSIndexPath).section - 1].list[(indexPath as NSIndexPath).row]
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
    
    
    var objectId:Int!
    var objectName = ""
    
    var isShowRightBar = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isShowRightBar == true {
            
           setNavBarItem()
        }
        else {
            
        }
        
    }
    
    func setNavBarItem() {
        
        let rightBarItem = UIBarButtonItem(title: "订单", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EmployeeProfileVC.settingTap))
        navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    func settingTap() {
        
        let vc = MyWorkDetailVC()
        vc.title = objectName
        vc.objectId = objectId
        vc.objectName = objectName
        vc.type = self.type
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
    
}
