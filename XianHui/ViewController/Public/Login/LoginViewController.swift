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
    
    var cellId = "UserNameCell"
    
    var singleCellId = "SingleTapCell"
    
   

    var hud = MBProgressHUD()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        let singleTapCellNib = UINib(nibName: singleCellId, bundle: nil)
        tableView.registerNib(singleTapCellNib, forCellReuseIdentifier: singleCellId)
        
        setFooterView()
    }
    
    
    func setFooterView() {
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: screenWidth, height: 20))
        
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.lightGrayColor()
        label.textAlignment = .Left
        label.text = "提示:从MyBook激活后,初次登录的密码是手机号码!"
        tableView.tableFooterView = label
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension LoginViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        }
        else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .None
        if indexPath.row == 0 {
            
            let view = LoginTopView()
            cell.contentView.addSubview(view)
            view.snp_makeConstraints(closure: { (make) in
                make.left.top.right.bottom.equalTo(cell.contentView)
            })
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserNameCell
            
            cell.textField.placeholder = "手机号码"
            cell.textField.keyboardType = .Default
            cell.codeButton.alpha = 0.0
            cell.codeButtonTapHandler = {
                cell.codeButton.setTitle("验证码已发送", forState: .Normal)
            }
            cell.textField.resignFirstResponder()
            return cell
            
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserNameCell
            cell.textField.keyboardType = .Default
            cell.textField.returnKeyType = .Go
            cell.textField.secureTextEntry = true
            cell.textFieldDidReturnHandler = {
               
                self.tryLogin()
            }
            
            cell.textField.placeholder = "密码"
            cell.codeButton.alpha = 0.0
            return cell
        }
        else  {
            let cell = tableView.dequeueReusableCellWithIdentifier(singleCellId, forIndexPath: indexPath) as! SingleTapCell
            
            cell.middleLabel.text = "忘记了密码?"
            cell.middleLabel.textAlignment = .Right
            cell.middleLabel.font = UIFont.systemFontOfSize(13)
            cell.middleLabel.textColor = UIColor ( red: 0.4079, green: 0.6937, blue: 1.0, alpha: 1.0 )
            
            let codeButton = UIButton()
            cell.addSubview(codeButton)
            codeButton.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(cell.middleLabel)
                make.left.equalTo(cell).offset(15)
                make.width.equalTo(150)
                make.height.equalTo(21)
            })
            
            codeButton.setTitle("短信验证码登陆", forState: .Normal)
            codeButton.contentHorizontalAlignment = .Left
            codeButton.titleLabel?.font = UIFont.systemFontOfSize(13)
            codeButton.setTitleColor(UIColor ( red: 0.4079, green: 0.6937, blue: 1.0, alpha: 1.0 ), forState: .Normal)
            codeButton.addTarget(self, action: #selector(LoginViewController.openCodeLoginVC), forControlEvents: .TouchUpInside)
            
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
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
    
    //login
    func tryLogin() {
        
        let indexPath0 = NSIndexPath(forRow: 1, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath0) as! UserNameCell
        let userName = cell.textField.text!
        
        let indexPath1 = NSIndexPath(forRow: 2, inSection: 0)
        let cell2 = tableView.cellForRowAtIndexPath(indexPath1) as! UserNameCell
        let passWord = cell2.textField.text!
        
        if userName == "" {
            
            showHudWith("请输入手机号")
            return
        }
        
        if passWord == "" {
            
            showHudWith("请输入密码")
            return
        }
        
        User.loginWith(userName, passWord: passWord, usertype: UserLoginType.Employee) { (user, data, error) in
            
            self.showHud()
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
                self.showHudWith(textError)
            }
        }
        
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
            let indexPath0 = NSIndexPath(forRow: 1, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath0) as! UserNameCell
            let userName = cell.textField.text!
            showHud()
            NetworkManager.sharedManager.updatePassWordWith(userName, usertype: .Employee, passWord: password, completion: { (success, json, error) in
                
                if success == true {
                    self.hideHud()
                    self.showHudWith("修改成功,请再次登录")
                    let indexPath1 = NSIndexPath(forRow: 2, inSection: 0)
                    let cell2 = self.tableView.cellForRowAtIndexPath(indexPath1) as! UserNameCell
                    cell2.textField.text = ""
                }
                else {
                    self.hideHud()
                    self.showHudWith(error!)
                }
                
            })
        }
        
        
    }
}



