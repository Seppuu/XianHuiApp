//
//  AccountManagerVC.swift
//  XianHui
//
//  Created by 鲁莹 on 2016/9/27.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class Agent: NSObject {
    
    var name = ""
    var id = ""
    
    var isCurrentUse = false
}

class AccountManagerVC: UIViewController {

    var tableView:UITableView!
    
    var listOfAgent = [Agent]()
    
    private let logOutCellId = "SingleTapCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        
        getAgentList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: logOutCellId, bundle: nil), forCellReuseIdentifier: logOutCellId)
    }
    
    func getAgentList() {
        
        NetworkManager.sharedManager.getCompanyListWith(User.currentUser().userName, usertype: .Employee) { (success, json, error) in

            if success == true {
                
                self.listOfAgent = self.makeAgentListWith(json!)
                self.tableView.reloadData()
            }
            else {
                
            }
        }
    }
    
    //切换企业
    func makeAgentListWith(data:JSON) -> [Agent] {
        
        var list = [Agent]()
        
        for agent in data.array! {
            
            let a = Agent()
            if let name = agent["agent_name"].string {
                a.name = name
            }
            
            if let id = agent["agent_id"].string {
                a.id = id
            }
            
            if let isCurrentUse = agent["is_default"].string {
                
                if isCurrentUse == "1" {
                    a.isCurrentUse = true
                }
                else {
                    a.isCurrentUse = false
                }
            }
            
            list.append(a)
        }
        
        return list
    }
    
    
    
    
    

}

extension AccountManagerVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listOfAgent.count
        }
        else {
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "账号切换"
        }
        else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cellId = "cellId"
            
            let cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            let agent = listOfAgent[indexPath.row]
            cell.textLabel?.text = agent.name
            
            if agent.isCurrentUse == true {
                cell.accessoryType = .Checkmark
            }
            else {
                cell.accessoryType = .None
            }
            
            return cell
        }
        else {
            //退出
            let cell = tableView.dequeueReusableCellWithIdentifier(logOutCellId, forIndexPath: indexPath) as! SingleTapCell
            
            cell.middleLabel.text = "退出"
            cell.middleLabel.textColor = UIColor.redColor()
            
            return cell
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let agent = listOfAgent[indexPath.row]
            let agentId = agent.id.toInt()!
            changeCompanyWith(agentId)
        }
        else {
            showAlertView()
        }
        
    }
    
    
    
    func changeCompanyWith(agentId:Int) {
        
        showHudWith(self.view, animated: true, mode: .Indeterminate, text: "")
        NetworkManager.sharedManager.setCurrentCompanyWith(User.currentUser().userName, usertype: .Employee, agentId: agentId) { (success, json, error) in
            
            if success == true {
                
                self.changeAccount()
            }
            else {
                let hud = MBProgressHUD.showHUDAddedTo((self.view)!, animated: true)
                hud.mode = .Text
                hud.labelText = error
                
                hud.hide(true, afterDelay: 1.5)
            }
            
        }
        
    }
    
    func showAlertView() {
        
        let alert = UIAlertController(title: "提示", message: "退出应用", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .Default, handler: nil)
        
        let confirmAction = UIAlertAction(title: "确认", style: .Destructive) { (action) in
            self.logOut()
        }
        
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func logOut() {
        
        User.logOut({ (success, json, error) in
            
            if success {
                //show intro
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.showLoginVC()
                
            }
            else {
                let hud = MBProgressHUD.showHUDAddedTo((self.view)!, animated: true)
                hud.mode = .Text
                hud.labelText = error
                
                hud.hide(true, afterDelay: 1.5)
            }
            
        }) { (error) in
            //TODO:leanCloud IM 退出失败
            let hud = MBProgressHUD.showHUDAddedTo((self.view)!, animated: true)
            hud.mode = .Text
            hud.labelText = error.description
            
            hud.hide(true, afterDelay: 1.5)
        }
        
        
    }
    
    
    func changeAccount() {
        
       logOutFirst()
        
    }
    
    
    func logOutFirst() {
        User.logOut({ (success, json, error) in
            
            if success {
                //log in with current acount
                self.loginAgain()
            }
            else {
                let hud = MBProgressHUD.showHUDAddedTo((self.view)!, animated: true)
                hud.mode = .Text
                hud.labelText = error
                
                hud.hide(true, afterDelay: 1.5)
            }
            
        }) { (error) in
            //TODO:leanCloud IM 退出失败
            let hud = MBProgressHUD.showHUDAddedTo((self.view)!, animated: true)
            hud.mode = .Text
            hud.labelText = error.description
            
            hud.hide(true, afterDelay: 1.5)
        }
    }
    
    func loginAgain() {
        let userName = Defaults.currentAccountName.value!
        let passWord = Defaults.currentPassWord.value!
        
        User.loginWith(userName, passWord: passWord, usertype: UserLoginType.Employee) { (user, data, error) in
            
            
            if error == nil {
                
                let clientId = String(user!.clientId)
                self.connectWithLeanCloudIMWith(clientId)
            }
            else {
                hideHudFrom(self.view)
                //TODO:错误分类
                let textError = error!
                showHudWith(self.view, animated: true, mode: .Text, text: textError)
            }
        }

        
    }
    
    func connectWithLeanCloudIMWith(clientId:String) {
        
        ChatKitExample.invokeThisMethodAfterLoginSuccessWithClientId(clientId, success: {
            
            hideHudFrom(self.view)
            NSNotificationCenter.defaultCenter().postNotificationName(accountHasChangedNoti, object: nil)
            self.getAgentList()
            }, failed: { (error) in
                hideHudFrom(self.view)
                
                showHudWith(self.view, animated: true, mode: .Text, text: error.description)
        })
    }
    
    
    
    
    
    
}
