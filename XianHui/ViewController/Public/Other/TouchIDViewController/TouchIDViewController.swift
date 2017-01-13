//
//  TouchIDViewController.swift
//  XianHui
//
//  Created by jidanyu on 2017/1/12.
//  Copyright © 2017年 mybook. All rights reserved.
//

import UIKit

class TouchIDViewController: UIViewController {
    
    var avatarImageView:UIImageView!
    
    var fingerprintButton:UIButton!
    
    var tapButton:UIButton!
    
    var bottomButton:UIButton!

    var isLogin = false
    
    var tapButtonTitle:String {
        return isLogin ? "点击进行指纹登陆":"点击进行指纹解锁"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        setSubView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        useTouchID()
    }

    func setSubView() {
        
        avatarImageView = UIImageView()
        view.addSubview(avatarImageView)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = UIColor.lightGray
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 40
        
        if let urlString = Defaults.userAvatarURL.value {
            if let imageUrl = URL(string:urlString) {
                avatarImageView.kf.setImage(with: imageUrl)
            }
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(64)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(80)
        }
        
        fingerprintButton = UIButton()
        view.addSubview(fingerprintButton)
        let fingerImage = UIImage(named: "TouchID")
        fingerprintButton.setImage(fingerImage, for: .normal)
        fingerprintButton.addTarget(self, action: #selector(TouchIDViewController.useTouchID), for: .touchUpInside)
        fingerprintButton.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.height.equalTo(80)
        }
        
        tapButton = UIButton()
        view.addSubview(tapButton)
        tapButton.setTitle(tapButtonTitle, for: .normal)
        tapButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tapButton.setTitleColor(UIColor.init(hexString: "D3508B"), for: UIControlState())
        tapButton.addTarget(self, action: #selector(TouchIDViewController.useTouchID), for: .touchUpInside)
        tapButton.snp.makeConstraints { (make) in
            make.top.equalTo(fingerprintButton.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
            make.left.right.equalTo(view)
            make.height.equalTo(30)
        }
        
        bottomButton = UIButton()
        view.addSubview(bottomButton)
        bottomButton.setTitle("登陆其他账户", for: .normal)
        bottomButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        bottomButton.setTitleColor(UIColor.init(hexString: "D3508B"), for: UIControlState())
        bottomButton.addTarget(self, action: #selector(TouchIDViewController.showLoginVC), for: .touchUpInside)
        bottomButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-10)
            make.centerX.equalTo(view.snp.centerX)
            make.left.right.equalTo(view)
            make.height.equalTo(30)
            
        }
        
    }
    
    
    func useTouchID() {
        
        SecurityManager.shared.authenticateWithTouchID(notSupport: { 
            
            let msg = "您的指纹信息发生变更,请在手机中重新添加指纹后返回解锁或者直接使用密码登陆。"
            let hud = showHudWith(self.view, animated: true, mode: .text, text: msg)
            hud.hide(true, afterDelay: 1.5)
            
        }, succeed: {
            if self.isLogin == true {
                self.loginWithTouchIDFromBegin()
            }
            else {
                self.dismiss()
            }
            
        }, userCancel: {
            
            //
            
        }) { (_, error) in
            let hud = showHudWith(self.view, animated: true, mode: .text, text: error!)
            hud.hide(true, afterDelay: 1.5)
            
        }
    }
    
    func dismiss() {
       self.dismiss(animated: true, completion: nil)
    }
    
    
    func loginWithTouchIDFromBegin() {
        
        XHAccountManager.shared.loginWithTouchIDFromBegin()
    }
    
    
    func showLoginVC() {
        
        //show intro
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.showGuide()
    }
    

}
