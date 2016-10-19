//
//  LoginViewController.swift
//  XianHui
//
//  Created by Seppuu on 16/7/28.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SnapKit
import UITextView_Placeholder
import SwiftString
import MBProgressHUD
import SwiftyJSON
import Ruler
import IQKeyboardManagerSwift

class LoginTopView: UIView {
    
    var imageView:UIImageView!
    
    var topLabel:UILabel!
    
    override func layoutSubviews() {
        
        imageView = UIImageView()
        imageView.image = UIImage(named: "logoIcon")
        imageView.contentMode = .ScaleAspectFit
        addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(22 + 10)
            make.centerX.equalTo(self)
            make.width.height.equalTo(80)
        }
        
        topLabel = UILabel()
        addSubview(topLabel)
        topLabel.snp_makeConstraints { (make) in
            make.top.equalTo(imageView.snp_bottom).offset(8)
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(21)
        }
        topLabel.textAlignment = .Center
        topLabel.text = "闲惠-商家版"
        topLabel.textColor = UIColor.lightGrayColor()
        topLabel.font = UIFont.systemFontOfSize(15)
        
    }
}



class LoginViewController: UIViewController {
    
    var tableView:UITableView!
    
    var hud = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
        
    }
    
    var logoImageView:UIImageView!
    
    var phoneTextField:UITextField!
    var passWordTextField:UITextField!
    
    var tryButton:UIButton!
    var loginButton:UIButton!
    
    var helpLabel:UILabel!
    
    func setSubView() {
        
        view.backgroundColor = UIColor.whiteColor()
        
        logoImageView = UIImageView()
        view.addSubview(logoImageView)
        
        let width:CGFloat = Ruler.iPhoneHorizontal(126, 148, 164).value
        
        logoImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(70)
            make.width.height.equalTo(width)
        }
        logoImageView.image = UIImage(named: "logoIcon")
        logoImageView.contentMode = .ScaleAspectFit
        
        phoneTextField = UITextField()
        view.addSubview(phoneTextField)
        phoneTextField.delegate = self
        phoneTextField.placeholder = "  电话号码"
        phoneTextField.keyboardType = .NumberPad
        phoneTextField.backgroundColor = UIColor.init(hexString: "EDEDED")
        phoneTextField.layer.cornerRadius = 5
        phoneTextField.layer.masksToBounds = true
        
        phoneTextField.snp_makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp_bottom).offset(34)
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.height.equalTo(40)
        }
        
        passWordTextField = UITextField()
        view.addSubview(passWordTextField)
        passWordTextField.delegate = self
        passWordTextField.placeholder = "  密码"
        passWordTextField.keyboardType = .NumbersAndPunctuation
        passWordTextField.returnKeyType = .Go
        passWordTextField.secureTextEntry = true
        passWordTextField.backgroundColor = UIColor.init(hexString: "EDEDED")
        passWordTextField.layer.cornerRadius = 5
        passWordTextField.layer.masksToBounds = true
        
        passWordTextField.snp_makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp_bottom).offset(15)
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.height.equalTo(40)
        }
        
//        tryButton = UIButton()
//        view.addSubview(tryButton)
//        tryButton.setTitle("试用", forState: .Normal)
//        tryButton.setTitleColor(UIColor.init(hexString: "928181"), forState: .Normal)
//        tryButton.backgroundColor = UIColor.init(hexString: "E5DED1")
//        tryButton.addTarget(self, action: #selector(LoginViewController.loginWithTry), forControlEvents: .TouchUpInside)
//        tryButton.layer.cornerRadius = 5
//        tryButton.layer.masksToBounds = true
        
        loginButton = UIButton()
        view.addSubview(loginButton)
        loginButton.setTitle("登陆", forState: .Normal)
        loginButton.setTitleColor(UIColor.init(hexString: "928181"), forState: .Normal)
        loginButton.backgroundColor = UIColor.init(hexString: "D2B580")
        loginButton.addTarget(self, action: #selector(LoginViewController.login), forControlEvents: .TouchUpInside)
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        
        let buttonWidth = (screenWidth - 30 - 10) / 2
        
//        tryButton.snp_makeConstraints { (make) in
//            make.top.equalTo(passWordTextField.snp_bottom).offset(30)
//            make.left.equalTo(view).offset(15)
//            make.width.equalTo(buttonWidth)
//            make.height.equalTo(40)
//        }
        
        loginButton.snp_makeConstraints { (make) in
            make.top.equalTo(passWordTextField.snp_bottom).offset(30)
            make.width.equalTo(buttonWidth)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
            make.height.equalTo(40)
        }
        
        let tip = UILabel()
        view.addSubview(tip)
        
        tip.font = UIFont.systemFontOfSize(12)
        tip.textColor = UIColor.lightGrayColor()
        tip.textAlignment = .Left
        tip.text = "提示:从MyBook激活后,使用短信中的临时密码登陆!"
        
        tip.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.height.equalTo(21)
            make.top.equalTo(loginButton.snp_bottom).offset(15)
        }
        
        
        helpLabel = UILabel()
        view.addSubview(helpLabel)
        helpLabel.textAlignment = .Center
        helpLabel.text = "需要帮助?"
        helpLabel.alpha = 0.0
        helpLabel.font = UIFont.systemFontOfSize(14)
        helpLabel.textColor = UIColor.ddBasicBlueColor()
        helpLabel.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.showHelperAlert))
        helpLabel.addGestureRecognizer(tap)
        helpLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        
    }
    
    func showHelperAlert() {
        
        let title = "提示"
        let message = "前往帮助中心获取帮助"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        let helperAction = UIAlertAction(title: "帮助中心", style: .Default) { (action) in
            let vc = HelpCenterViewController()
            let nav = UINavigationController(rootViewController: vc)
            self.presentViewController(nav, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        alert.addAction(helperAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension LoginViewController:UITextFieldDelegate {
    
    
    
}

extension LoginViewController {
    
    func openCodeLoginVC() {
        
        let vc = LoginByPhoneVC()
        let nav = UINavigationController(rootViewController: vc)
        
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func showHudWith(text:String) {
        
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = .Text
        hud.labelText = text
        hud.hide(true, afterDelay: 2.0)
    }
    
    func showHud() {
        
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = .Indeterminate
    }
    
    func hideHud() {
        hud.hide(true)
        hud = MBProgressHUD()
    }
    
    func loginWithTry() {
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = .Text
        hud.labelText = "暂未开通"
        
        hud.hide(true, afterDelay: 2.0)
        
    }
    
    //login
    func login() {
        

        let userName = phoneTextField.text!
        

        let passWord = passWordTextField.text!
        
        if userName == "" {
            
            showHudWith("请输入手机号")
            return
        }
        
        if passWord == "" {
            
            showHudWith("请输入密码")
            return
        }
        
        self.showHud()
        
        User.loginWith(userName, passWord: passWord, usertype: UserLoginType.Employee) { (user, data, error) in
            
            
            if error == nil {
                self.hideHud()
                //检车是否是默认密码,如果是,需要强制修改.否则无法登陆
                if let no = data!["init_login_password"].int {
                    if no == 1 {
                        
                        self.showChangePassWordAlert()
                    }
                    else {
                        let clientId = String(user!.clientId)
                        NSNotificationCenter.defaultCenter().postNotificationName(OwnSystemLoginSuccessNoti, object: clientId)
                    }
                }
                else {
                    
                }
            }
            else {
                self.hideHud()
                //TODO:错误分类
                let textError = error!
                self.showLoginErrorAlert(textError)
            }
        }
        
    }
    
    func showLoginErrorAlert(error:String) {
        
        let alert = UIAlertController(title:"提示" , message: error, preferredStyle: .Alert)
        
        let cancel = UIAlertAction(title: "重试", style: .Cancel, handler: nil)
        
        let trySms = UIAlertAction(title: "短信登陆", style: .Default) { (alert) in
            
            self.openCodeLoginVC()
        }
        
        alert.addAction(cancel)
        alert.addAction(trySms)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showChangePassWordAlert() {
        
        let title = "提示"
        let message = "初次登录请更换默认密码"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            
            textField.placeholder = "新密码"
        }
        
        let passWordTextField = alert.textFields?.first!
        
        let submitButton = UIAlertAction(title: "确认", style: .Default) { (action) in
            
            let password = passWordTextField?.text
            
            self.updatePassWord(with: password!)
            
        }
        
        alert.addAction(submitButton)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
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
            
            let userName = phoneTextField.text
            if userName == nil {return}
            showHud()
            NetworkManager.sharedManager.updatePassWordWith(userName!, usertype: .Employee, passWord: password, completion: { (success, json, error) in
                
                if success == true {
                    self.hideHud()
                    self.showHudWith("修改成功,请再次登录")
                    self.passWordTextField.text = ""
                }
                else {
                    self.hideHud()
                    self.showHudWith(error!)
                }
                
            })
        }
        
        
    }
}



