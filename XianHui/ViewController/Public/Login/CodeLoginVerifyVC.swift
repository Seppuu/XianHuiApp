//
//  CodeLoginVerifyVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/21.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class CodeLoginVerifyVC: UIViewController {
    
    var mobile: String!
   
    var code:String!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var codeTextField: BorderTextField!
    
    @IBOutlet weak var phoneComingLabel: UILabel!
    
    @IBOutlet weak var PhoneCallLabel: UILabel!
    
    @IBOutlet weak var callCountLabel: UILabel!
    
    fileprivate var callMeInSeconds = 60 //60s
    
    fileprivate lazy var callMeTimer: Timer = {
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CodeLoginVerifyVC.tryCallMe(_:)), userInfo: nil, repeats: true)
        return timer
    }()
    
    var agentId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "验证码"
        phoneLabel.text = mobile
        codeTextField.placeholder = " "
        codeTextField.backgroundColor = UIColor.white
        codeTextField.delegate = self
        codeTextField.addTarget(self, action: #selector(CodeLoginVerifyVC.textFieldDidChange(_:)), for: .editingChanged)
        
        phoneComingLabel.alpha = 0.0
        PhoneCallLabel.alpha = 1.0
        callCountLabel.alpha = 1.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    func setNavBar() {
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        callMeTimer.fire()
        codeTextField.becomeFirstResponder()
    }
    
    func textFieldDidChange(_ textField:UITextField) {
        
        //检测code长度,如果达到设定长度,自动检测,登录.
        if textField.text?.characters.count == 6 {
            
            tryLogin(textField.text!)
            
        }
    }
    
    func tryCallMe(_ timer:Timer){
        
        if callMeInSeconds > 1 {
            
            UIView.performWithoutAnimation {
                self.callCountLabel.text = String(self.callMeInSeconds) + "秒"
                self.callCountLabel.layoutIfNeeded()
            }
            
        } else {
            UIView.performWithoutAnimation {
                
                self.callCountLabel.alpha = 0.0
                
                self.callCountLabel.layoutIfNeeded()
            }
            
            //call code phone
            timer.invalidate()
            phoneComingLabel.alpha = 1.0
            PhoneCallLabel.alpha = 0.0
            callCountLabel.alpha = 0.0
            CallMe()
        }
        
        if (callMeInSeconds > 1) {
            callMeInSeconds -= 1
        }
        
    }
    
    func CallMe() {
        
        NetworkManager.sharedManager.getPhoneCodeWith(mobile, usertype: .Employee, codeType: .voice) { (success, json, error) in
            
            if success == true {
                
                
                
            }
            else {
                
                //TODO:电话失败
            }
            
        }
        
    }

    
    var hud = MBProgressHUD()
    
    func showHudWith(_ text:String) {
        
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.labelText = text
        hud.hide(true, afterDelay: 2.0)
    }
    
    func showHud() {
        
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
    }
    
    func hideHud() {
        hud.hide(true)
        hud = MBProgressHUD()
    }

    
    fileprivate func tryLogin(_ smsCode:String) {
        
        codeTextField.resignFirstResponder()
        
        User.loginWithCode(mobile, code: smsCode, usertype: UserLoginType.Employee) { (user, data, error) in
            
            self.showHud()
            if error == nil {
                self.hideHud()
                self.callMeTimer.invalidate()
                
                //检车是否是默认密码,如果是,需要强制修改.否则无法登陆
                if let no = data!["init_login_password"].int {
                    if no == 1 {
                        self.showChangePassWordAlert()
                    }
                    else {
                        let clientId = String(user!.clientId)
                        NotificationCenter.default.post(name: OwnSystemLoginSuccessNoti, object: clientId)
                    }
                }
                else {
                    
                }
                
            }
            else {
                self.hideHud()
                //TODO:错误分类
                if let errorCode = data!["errorCode"].string {
                    
                    if errorCode == "1002" {
                        
                        //让用户选择门店
                        self.makeAgentListWith(data!)
                        
                        return
                    }
                    else {
                        
                    }
                    
                }
                
                let textError = error!
                self.showHudWith(textError)
                self.agentId = nil
            }
            
            
        }

    }
    
    
    func makeAgentListWith(_ data:JSON) {
        
        var list = [Agent]()
        
        if let agentList = data["agent_list"].array {
            
            for agent in agentList {
                
                let a = Agent()
                if let name = agent["agent_name"].string{
                    a.name = name
                }
                if let id = agent["agent_id"].string{
                    a.id = id
                }
                
                list.append(a)
            }
            
            self.showAgentListAlertViewWith(list)
            
        }
        else {
            
        }
        
    }
    
    func showAgentListAlertViewWith(_ agentList:[Agent]) {
        
//        let alert = UIAlertController(title: "选择门店", message: "您的账号目前属于多个门店", preferredStyle: .ActionSheet)
//        
//        for agent in agentList {
//            
//            
//            let action = UIAlertAction(title: agent.name, style: .Default, handler: { (alert) in
//                
//                self.agentId = agent.id.toInt()
//                
//                self.tryLogin()
//            })
//            
//            alert.addAction(action)
//        }
//        
//        self.presentViewController(alert, animated: true, completion: nil)
//        
    }
    
    
    
    func filterError(_ error: NSError?) -> Bool{
        if error != nil {
            //print(error)
            return false
        } else {
            return true
        }
    }

    
    func showChangePassWordAlert() {
        
        let title = "提示"
        let message = "初次登录请更换默认密码"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
            textField.placeholder = "新密码"
        }
        
        let passWordTextField = alert.textFields?.first!
        
        let submitButton = UIAlertAction(title: "确认", style: .default) { (action) in
            
            let password = passWordTextField?.text
            
            self.updatePassWord(with: password!)
            
        }
        
        alert.addAction(submitButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func updatePassWord(with password:String) {
        
        
        if password == "" {
            //show hud password is ""
            showHudWith("请输入新的密码")
            
            //show alert anagin
            self.showChangePassWordAlert()
        }
        else {
            //update password
            let userName = mobile
            showHud()
            NetworkManager.sharedManager.updatePassWordWith(userName!, usertype: .Employee, passWord: password, completion: { (success, json, error) in
                
                if success == true {
                    self.hideHud()
                    self.showHudWith("修改成功,请再次登录")
                }
                else {
                    self.hideHud()
                    self.showHudWith(error!)
                }
                
            })
        }
        
        
    }
}

extension CodeLoginVerifyVC:UITextFieldDelegate {
    
}
