//
//  XHConfigs.swift
//  XianHui
//
//  Created by jidanyu on 2017/1/11.
//  Copyright © 2017年 mybook. All rights reserved.
//

import Foundation
import SwiftyJSON
import MBProgressHUD

class XHTableViewDataManager {
    
    static var shared = XHTableViewDataManager() // This is singleton
    
    var myWorkCustomerTableViewData = [MyWorkObject]()
    
    var myWorkEmployeeTableViewData = [MyWorkObject]()
    
    var myWorkProjectTableViewData = [MyWorkObject]()
    
    var myWorkProductionTableViewData = [MyWorkObject]()
    
}


class XHAccountManager {
    
    static var shared = XHAccountManager() // This is singleton
    
    var currentVC:UIViewController? {
        
        let delegate =  UIApplication.shared.delegate as? AppDelegate
        
        return delegate?.window?.visibleViewController
    }
    
    //超时情况,在当前页面重新登陆
    func loginWhenTimeOut() {
        
        let alert = UIAlertController(title: "提示", message: "登陆超时,需要重新登陆", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
            textField.isSecureTextEntry = true
        }
        
        let passWordTextField = alert.textFields?.first!
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (alert) in
            
            //回到登陆界面
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.showGuide()
            
        }
        
        let submitButton = UIAlertAction(title: "确认", style: .default) { (action) in
            
            let password = passWordTextField?.text
            
            self.loginWithPassWord(password!,isTimeOut:true)
            
        }
        
        let anotherButton = UIAlertAction(title: "指纹登陆", style: .default) { (action) in
            
            SecurityManager.shared.authenticateWithTouchID(notSupport: {
                //不支持
                let msg = "您的指纹信息发生变更,请在手机中重新添加指纹后返回解锁或者直接使用密码登陆。"
                let hud = showHudWith((self.currentVC!.view)!, animated: true, mode: .text, text: "提示")
                hud.detailsLabelText = msg
                hud.hide(true, afterDelay: 3.0)
                self.loginWhenTimeOut()
            }, succeed: {
                //成功
                self.loginWithCurrentAccount()
                
            }, userCancel: {
                //用户取消
                self.loginWhenTimeOut()
            }, falied: { (_, error) in
                let hud = showHudWith((self.currentVC!.view)!, animated: true, mode: .text, text: "提示")
                hud.detailsLabelText = error!
                hud.hide(true, afterDelay: 3.0)
                self.loginWhenTimeOut()
                //print(error)
            })
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(submitButton)
        //如果没有开启指纹登陆功能(不显示该选项)
        if Defaults.useTouchIDLogIn.value! == true {
            alert.addAction(anotherButton)
        }
        
        if currentVC != nil {
            currentVC!.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //超时下重新登陆
    func loginWithCurrentAccount() {
        
        let passWord = Defaults.currentPassWord.value!
        self.loginWithPassWord(passWord,isTimeOut:true)
    }
    
    //非超时下,指纹登陆.使用保存在沙盒的密码和账户
    func loginWithTouchIDFromBegin() {
        
        let passWord = Defaults.currentPassWord.value!
        self.loginWithPassWord(passWord,isTimeOut:false)
    }
    
    func loginWithPassWord(_ passWord:String,isTimeOut:Bool) {
        
        let userName = Defaults.currentAccountName.value!
        let passWord = passWord
        
        let hud = showHudWith((currentVC!.view)!, animated: true, mode: .indeterminate, text: "")
        
        User.loginWith(userName, passWord: passWord, usertype: UserLoginType.Employee) { (user, data, error) in
            
            if error == nil {
                
                if let clientId = String(user!.clientId) {
                    //self.connectWithLeanCloudIMWith(clientId,hud:hud)
                    if isTimeOut == false {
                        //指纹登陆
                        NotificationCenter.default.post(name:OwnSystemLoginSuccessNoti, object: clientId)
                    }
                    else {
                        //指纹解锁.什么都不做.
                    }
                    
                }
                
                hud.mode = .text
                hud.labelText = "登陆成功"
                hud.hide(true, afterDelay: 1.5)
                
            }
            else {
                
                hud.mode = .text
                hud.labelText = error!
                hud.hide(true, afterDelay: 1.5)
                
                //继续显示
                self.loginWhenTimeOut()
            }
            
            
        }
    }
    
    //    func connectWithLeanCloudIMWith(_ clientId:String,hud:MBProgressHUD) {
    //
    //        ChatKitExample.invokeThisMethodAfterLoginSuccess(withClientId: clientId, success: {
    //            hud.mode = .text
    //            hud.labelText = "登陆成功"
    //            hud.hide(true, afterDelay: 1.5)
    //
    //        }, failed: { (error) in
    //
    //            hud.mode = .text
    //            hud.labelText = error.debugDescription
    //            hud.hide(true, afterDelay: 1.5)
    //            self.reLogin()
    //            
    //        })
    //    }
    
    
}
