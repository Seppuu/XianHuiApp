//
//  LoginByPhoneVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/21.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class LoginByPhoneVC: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: BorderTextField!
    
    @IBOutlet weak var codeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "手机号码"
        
        setNavBarItem()
        
        phoneNumberTextField.placeholder = "手机号"
        phoneNumberTextField.backgroundColor = UIColor.whiteColor()
        phoneNumberTextField.delegate = self
        phoneNumberTextField.addTarget(self, action: #selector(LoginByPhoneVC.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginByPhoneVC.tryShowLoginVerifyMobile))
        codeView.addGestureRecognizer(tap)
        codeView.userInteractionEnabled = true
        
        enAbleCodeVerifyView(false)
    }
    
    func enAbleCodeVerifyView(bool:Bool){
        let codeLabell = codeView.viewWithTag(11) as! UILabel
        let codeArrow  = codeView.viewWithTag(12) as! UIImageView
        if bool {
            codeLabell.textColor = UIColor ( red: 0.0, green: 0.4627, blue: 1.0, alpha: 1.0 )
            codeArrow.image? = (codeArrow.image?.imageWithRenderingMode(.AlwaysTemplate))!
            codeArrow.tintColor = UIColor ( red: 0.0, green: 0.4627, blue: 1.0, alpha: 1.0 )
        }else {
            codeLabell.textColor = UIColor ( red: 0.747, green: 0.747, blue: 0.747, alpha: 1.0 )
            codeArrow.image? = (codeArrow.image?.imageWithRenderingMode(.AlwaysTemplate))!
            codeArrow.tintColor = UIColor ( red: 0.747, green: 0.747, blue: 0.747, alpha: 1.0 )
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        phoneNumberTextField.becomeFirstResponder()
    }
    
    
    func setNavBarItem() {
        
        let rightBar = UIBarButtonItem(title: "返回", style: .Done, target: self, action: #selector(LoginByPhoneVC.back))
        
        navigationItem.leftBarButtonItem = rightBar
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidChange(textField: UITextField) {
        
        guard let mobile = phoneNumberTextField.text else {
            return
        }
        
        let bool = !mobile.isEmpty
        
        if mobile.characters.count == 11 {
            enAbleCodeVerifyView(bool)
        }
        else {
            enAbleCodeVerifyView(false)
        }
        
        
    }
    
    //验证码>>
    func tryShowLoginVerifyMobile() {
        
        guard let mobile = phoneNumberTextField.text else {
            return
        }
        
        
        //检测是否是手机号码.
        if mobile.characters.count != 11  {
            
            DDAlert.alert(title: "提示", message: "请输入11位手机号码", dismissTitle: "OK", inViewController: self, withDismissAction: nil)
            
            return
        }
        
        if mobile.isPhoneNumber() == false {
            
            DDAlert.alert(title: "提示", message: "请输入正确的手机号码", dismissTitle: "OK", inViewController: self, withDismissAction: nil)
            
            return
        }
        
        //        NetworkManager.sharedManager.requestVerifyCodeWith(.sms, phone: mobile) { (success,_,error) in
        //
        //
        //            if success {
        //
        //                self.showLoginVerifyMobile()
        //            }
        //            else {
        //
        //                DDAlert.alert(title: "提示", message:error! , dismissTitle: "OK", inViewController: self, withDismissAction: nil)
        //            }
        //            
        //        }
        
        showLoginVerifyMobile()
        
    }
    
    func showLoginVerifyMobile() {
        guard let mobile = phoneNumberTextField.text else {
            return
        }
        
        let vc = CodeLoginVerifyVC()
        vc.mobile = mobile
        self.navigationController?.pushViewController(vc, animated: true)
    }



}

extension LoginByPhoneVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        guard let mobile = phoneNumberTextField.text else {
            return true
        }
        
        if !mobile.isEmpty {
            //tryShowLoginVerifyMobile()
        }
        
        return true
    }
}