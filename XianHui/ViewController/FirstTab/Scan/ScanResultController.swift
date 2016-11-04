//
//  ScanResultController.swift
//  XianHui
//
//  Created by jidanyu on 16/9/21.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import swiftScan
import SnapKit
import MBProgressHUD

//扫码成功界面



class ScanResultController: UIViewController {

    var codeResult:LBXScanResult!
    
    var topLabel = UILabel()
    
    var isLogInMyBook = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //self.edgesForExtendedLayout = UIRectEdge.None
        
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(21)
        }
        
        if isLogInMyBook == true {
            topLabel.text = "点击确认登陆Mybook系统."
        }
        else {
            topLabel.text = "点击确认退出Mybook系统."
        }
        
        
        topLabel.textColor = UIColor.lightGray
        topLabel.textAlignment = .center
        
        let confirmButton = UIButton()
        view.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(10)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(44)
        }
        var title = ""
        if isLogInMyBook == true {
            title = "确认登陆"
        }
        else {
            title = "确认退出"
        }
        confirmButton.setTitle(title, for: UIControlState())
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        confirmButton.layer.cornerRadius = 5.0
        confirmButton.setTitleColor(UIColor.white, for: UIControlState())
        confirmButton.backgroundColor = UIColor ( red: 1.0, green: 0.6947, blue: 0.6038, alpha: 1.0 )
        confirmButton.addTarget(self, action: #selector(ScanResultController.confirmTap), for: .touchUpInside)
        
    }
    
    
    
    func confirmTap() {
        if isLogInMyBook == true {
       //确认登陆.向后台发送二维码
        if codeResult.strScanned != nil {
            
            
                let qrCode = codeResult.strScanned!
                LCCKUtil.showProgressText("登陆中", duration: 10.0)
                NetworkManager.sharedManager.logInERPWith(qrCode, completion: { (success, json, error) in
                    
                    if success == true {
                        LCCKUtil.hideProgress()
                        Defaults.MyBookLogInToken.value = qrCode
                        self.backToTopViewController()
                        
                    }
                    else{
                        //TODO: error
                        LCCKUtil.showProgressText("登陆失败", duration: 2.0)
                    }
                    
                })
            
            
        }
        else {
            //解码错误
        
            }
        }
        else {
            LCCKUtil.showProgressText("退出中", duration: 10.0)
            let code = Defaults.MyBookLogInToken.value
            NetworkManager.sharedManager.logOutERPWith(code!, completion: { (success, json, error) in
                
                if success == true {
                    LCCKUtil.hideProgress()
                    Defaults.MyBookLogInToken.clear()
                    self.backToTopViewController()
                    
                }
                else{
                    //TODO: error
                    LCCKUtil.showProgressText("退出失败", duration: 2.0)
                }
                
            })
        }
        
        
    }

    
    func backToTopViewController() {
        
       _ =  self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
