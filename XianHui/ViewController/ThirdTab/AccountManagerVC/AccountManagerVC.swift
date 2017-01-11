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
    
    fileprivate let logOutCellId = "SingleTapCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        
        getAgentList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        var frame = view.bounds
        frame.size.height -= 20
        tableView = UITableView(frame:frame, style: .grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: logOutCellId, bundle: nil), forCellReuseIdentifier: logOutCellId)
    }
    
    func getAgentList() {
        
        let _ = showHudWith(view, animated: true, mode: .indeterminate, text: "")
        NetworkManager.sharedManager.getCompanyListWith(User.currentUser().userName, usertype: .Employee) { (success, json, error) in
            hideHudFrom(self.view)
            if success == true {
                
                self.listOfAgent = self.makeAgentListWith(json!)
                self.tableView.reloadData()
            }
            else {
                
            }
        }
    }
    
    //切换企业
    func makeAgentListWith(_ data:JSON) -> [Agent] {
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listOfAgent.count
        }
        else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "账号切换"
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0 {
            let cellId = "cellId"
            
            let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
            let agent = listOfAgent[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = agent.name
            
            if agent.isCurrentUse == true {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
            
            return cell
        }
        else {
            //退出
            let cell = tableView.dequeueReusableCell(withIdentifier: logOutCellId, for: indexPath) as! SingleTapCell
            
            cell.middleLabel.text = "退出"
            cell.middleLabel.textColor = UIColor.red
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            let agent = listOfAgent[(indexPath as NSIndexPath).row]
            let agentId = agent.id.toInt()!
            changeCompanyWith(agentId)
        }
        else {
            showAlertView()
        }
        
    }
    
    
    
    func changeCompanyWith(_ agentId:Int) {
        
        _ = showHudWith(self.view, animated: true, mode: .indeterminate, text: "")
        NetworkManager.sharedManager.setCurrentCompanyWith(User.currentUser().userName, usertype: .Employee, agentId: agentId) { (success, json, error) in
            
            if success == true {
                
                self.changeAccount()
            }
            else {
                let hud = MBProgressHUD.showAdded(to: (self.view)!, animated: true)
                hud?.mode = .text
                hud?.labelText = error
                
                hud?.hide(true, afterDelay: 1.5)
            }
            
        }
        
    }
    
    func showAlertView() {
        
        let alert = UIAlertController(title: "提示", message: "退出应用", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        
        let confirmAction = UIAlertAction(title: "确认", style: .destructive) { (action) in
            self.logOut()
        }
        
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func logOut() {
        
        User.logOut({ (success, json, error) in
            
            if success {
                //show intro
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDelegate.showGuide()
                
            }
            else {
                if let hud = MBProgressHUD.showAdded(to: (self.view)!, animated: true) {
                    hud.mode = .text
                    hud.labelText = error
                    
                    hud.hide(true, afterDelay: 1.5)
                }
                
            }
            
        }) { (error) in
            //TODO:leanCloud IM 退出失败
            if let hud = MBProgressHUD.showAdded(to: (self.view)!, animated: true) {
                hud.mode = .text
                hud.labelText = error.debugDescription
                
                hud.hide(true, afterDelay: 1.5)
            }
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
                if let hud = MBProgressHUD.showAdded(to: (self.view)!, animated: true) {
                    hud.mode = .text
                    hud.labelText = error
                    
                    hud.hide(true, afterDelay: 1.5)
                }
            }
            
        }) { (error) in
            //TODO:leanCloud IM 退出失败
            if let hud = MBProgressHUD.showAdded(to: (self.view)!, animated: true) {
                hud.mode = .text
                hud.labelText = error.debugDescription
                
                hud.hide(true, afterDelay: 1.5)
            }
        }
    }
    
    func loginAgain() {
        let userName = Defaults.currentAccountName.value!
        let passWord = Defaults.currentPassWord.value!
        
        User.loginWith(userName, passWord: passWord, usertype: UserLoginType.Employee) { (user, data, error) in
            
            
            if error == nil {
                
                if let clientId = String(user!.clientId) {
                    self.connectWithLeanCloudIMWith(clientId)    
                }
                
            }
            else {
                hideHudFrom(self.view)
                //TODO:错误分类
                let textError = error!
                let hud = showHudWith(self.view, animated: true, mode: .text, text: textError)
                hud.hide(true, afterDelay: 1.5)
            }
        }

        
    }
    
    func connectWithLeanCloudIMWith(_ clientId:String) {
        
        ChatKitExample.invokeThisMethodAfterLoginSuccess(withClientId: clientId, success: {
            
            hideHudFrom(self.view)
            NotificationCenter.default.post(name: Notification.Name(rawValue: accountHasChangedNoti), object: nil)
            self.getAgentList()
            }, failed: { (error) in
                hideHudFrom(self.view)
                
                let hud = showHudWith(self.view, animated: true, mode: .text, text: error.debugDescription)
                hud.hide(true, afterDelay: 1.5)
        })
    }
    
    
    
    
    
    
}
