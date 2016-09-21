//
//  CodeLoginVerifyVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/21.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class CodeLoginVerifyVC: UIViewController {
    
    
    var mobile: String!
   
    var code:String!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    @IBOutlet weak var codeTextField: BorderTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "验证码"

        phoneLabel.text = mobile
        
        codeTextField.placeholder = " "
        codeTextField.backgroundColor = UIColor.whiteColor()
        codeTextField.delegate = self
        codeTextField.addTarget(self, action: #selector(CodeLoginVerifyVC.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    func setNavBar() {
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        codeTextField.becomeFirstResponder()
    }
    
    func textFieldDidChange(textField:UITextField) {
        
        //检测code长度,如果达到设定长度,自动检测,登录.
        if textField.text?.characters.count == 6 {
            
            tryLogin(textField.text!)
            
        }
    }

    
    private func tryLogin(smsCode:String) {
        
        codeTextField.resignFirstResponder()
        
        //TODO:code login
        //        User.signUpOrLogin(with: mobile, smsCode: smsCode) {[weak self] (user, error) in
        //
        //            if (error == nil) {
        //                //print("登录成功")
        //
        //                //检测用户是否有姓名,如果没有,则是第一次注册.前往.信息页面.
        //
        //                if (user?.firstName == "") {
        //
        //                    self?.performSegueWithIdentifier("addUserInfo", sender: nil)
        //
        //                }
        //                else {
        //                    //是已经注册用户,进入主页面
        //                    if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
        //                        appDelegate.startMainStory()
        //                    }
        //                }
        //
        //            }
        //            else {
        //                //TODO:错误提示,无效的验证码之类.
        //                DDAlert.alert(title: "提示", message:error, dismissTitle:"OK", inViewController: self, withDismissAction: nil)
        //            }
        //        }
        
        
    }
    
    func filterError(error: NSError?) -> Bool{
        if error != nil {
            print(error)
            return false
        } else {
            return true
        }
    }

}

extension CodeLoginVerifyVC:UITextFieldDelegate {
    
}
