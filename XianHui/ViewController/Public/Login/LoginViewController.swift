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
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(22 + 10)
            make.centerX.equalTo(self)
            make.width.height.equalTo(80)
        }
        
        topLabel = UILabel()
        addSubview(topLabel)
        topLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(21)
        }
        topLabel.textAlignment = .center
        topLabel.text = "闲惠-商家版"
        topLabel.textColor = UIColor.lightGray
        topLabel.font = UIFont.systemFont(ofSize: 15)
        
    }
}



class LoginViewController: UIViewController {
    
    var tableView:UITableView!
    
    var hud = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "登陆"
        //setNavBarItem()
        setNoti()
        setSubView()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    var logoImageView:UIImageView!
    
    var phoneTextField:UITextField!
    var passWordTextField:UITextField!
    
    var tryButton:UIButton!
    var loginButton:UIButton!
    
    var helpLabel:UILabel!
    
    func setNoti() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.showChangePassWordAlert), name: XHAppNewUserFirstLoginNoti, object: nil)
    }
    
    func setSubView() {
        
        view.backgroundColor = UIColor.white
        
        logoImageView = UIImageView()
        view.addSubview(logoImageView)
        
        let width:CGFloat = Ruler.iPhoneHorizontal(126, 148, 164).value
        
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(70)
            make.width.height.equalTo(width)
        }
        logoImageView.image = UIImage(named: "logoIcon")
        logoImageView.contentMode = .scaleAspectFit
        
        phoneTextField = UITextField()
        view.addSubview(phoneTextField)
        phoneTextField.delegate = self
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        phoneTextField.leftView = paddingView1;
        phoneTextField.leftViewMode = .always
        phoneTextField.placeholder = "电话号码"
        phoneTextField.keyboardType = .numberPad
        phoneTextField.backgroundColor = UIColor.init(hexString: "EDEDED")
        phoneTextField.layer.cornerRadius = 5
        phoneTextField.layer.masksToBounds = true
        
        phoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom).offset(34)
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.height.equalTo(40)
        }
        
        passWordTextField = UITextField()
        view.addSubview(passWordTextField)
        passWordTextField.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        passWordTextField.leftView = paddingView;
        passWordTextField.leftViewMode = .always
        passWordTextField.placeholder = "密码"
        passWordTextField.keyboardType = .numbersAndPunctuation
        passWordTextField.returnKeyType = .go
        passWordTextField.isSecureTextEntry = true
        passWordTextField.backgroundColor = UIColor.init(hexString: "EDEDED")
        passWordTextField.layer.cornerRadius = 5
        passWordTextField.layer.masksToBounds = true
        
        passWordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom).offset(15)
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
        loginButton.setTitle("登陆", for: UIControlState())
        loginButton.setTitleColor(UIColor.init(hexString: "928181"), for: UIControlState())
        loginButton.backgroundColor = UIColor.init(hexString: "D2B580")
        loginButton.addTarget(self, action: #selector(LoginViewController.login), for: .touchUpInside)
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        
        let buttonWidth = (screenWidth - 30 - 10) / 2
        
//        tryButton.snp_makeConstraints { (make) in
//            make.top.equalTo(passWordTextField.snp_bottom).offset(30)
//            make.left.equalTo(view).offset(15)
//            make.width.equalTo(buttonWidth)
//            make.height.equalTo(40)
//        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passWordTextField.snp.bottom).offset(30)
            make.width.equalTo(buttonWidth)
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.height.equalTo(40)
        }
        
        let tip = UILabel()
        view.addSubview(tip)
        
        tip.font = UIFont.systemFont(ofSize: 12)
        tip.textColor = UIColor.lightGray
        tip.textAlignment = .left
        tip.text = "提示:从MyBook激活后,使用短信中的临时密码登陆!"
        
        tip.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.height.equalTo(21)
            make.top.equalTo(loginButton.snp.bottom).offset(15)
        }
        
        
        helpLabel = UILabel()
        view.addSubview(helpLabel)
        helpLabel.textAlignment = .center
        helpLabel.text = "需要帮助?"
        helpLabel.alpha = 0.0
        helpLabel.font = UIFont.systemFont(ofSize: 14)
        helpLabel.textColor = UIColor.ddBasicBlueColor()
        helpLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.showHelperAlert))
        helpLabel.addGestureRecognizer(tap)
        helpLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        
    }
    
    func showHelperAlert() {
        
        let title = "提示"
        let message = "前往帮助中心获取帮助"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let helperAction = UIAlertAction(title: "帮助中心", style: .default) { (action) in
            let vc = HelpCenterViewController()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(helperAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension LoginViewController:UITextFieldDelegate {
    
    
}

extension LoginViewController {
    
    func openCodeLoginVC() {
        
        let vc = LoginByPhoneVC()
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true, completion: nil)
        
    }
    
    
    func loginWithTry() {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = .text
        hud?.labelText = "暂未开通"
        
        hud?.hide(true, afterDelay: 2.0)
        
    }
    
    //login
    func login() {
        

        let userName = phoneTextField.text!
        

        let passWord = passWordTextField.text!
        
        if userName == "" {
            
            let hud = showHudWith(view, animated: true, mode: .text, text: "请输入手机号")
            hud.hide(true, afterDelay: 1.5)
            return
        }
        
        if passWord == "" {
            
            let hud = showHudWith(view, animated: true, mode: .text, text: "请输入密码")
            hud.hide(true, afterDelay: 1.5)
            return
        }
        
        let hud = showHudWith(view, animated: true, mode: .indeterminate, text: "")
        
        User.loginWith(userName, passWord: passWord, usertype: UserLoginType.Employee) { (user, data, error) in
            
            hud.hide(true)
            if error == nil {
                
                
                let clientId = String(user!.clientId)
                NotificationCenter.default.post(name:OwnSystemLoginSuccessNoti, object: clientId)
            }
            else {
                //TODO:错误分类
                let textError = error!
                self.showLoginErrorAlert(textError)
            }
        }
        
    }
    
    func showLoginErrorAlert(_ error:String) {
        
        let alert = UIAlertController(title:"提示" , message: error, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "重试", style: .cancel, handler: nil)
        
        let trySms = UIAlertAction(title: "短信登陆", style: .default) { (alert) in
            
            self.openCodeLoginVC()
        }
        
        alert.addAction(cancel)
        alert.addAction(trySms)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showChangePassWordAlert() {
        
        let title = "提示"
        let message = "初次登录请更换默认密码"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
            textField.isSecureTextEntry = true
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
            let hud = showHudWith(view, animated: true, mode: .text, text: "请输入新的密码")
            hud.hide(true, afterDelay: 1.5)
            
            //show alert anagin
            self.showChangePassWordAlert()
        }
        else {
            //update password
            
            let userName = phoneTextField.text
            if userName == nil {return}
            let hud = showHudWith(view, animated: true, mode: .indeterminate, text: "")
            NetworkManager.sharedManager.updatePassWordWith(userName!, usertype: .Employee, passWord: password, completion: { (success, json, error) in
                
                if success == true {
                    hud.labelText = "修改成功!"
                    hud.hide(true, afterDelay: 1.0)
                    
                    self.passWordTextField.text = password
                    self.login()
                }
                else {
                    hud.labelText = error!
                    hud.hide(true, afterDelay: 1.0)
                }
                
            })
        }
        
        
    }
}



