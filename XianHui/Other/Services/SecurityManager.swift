//
//  SecurityManager.swift
//  XianHui
//
//  Created by jidanyu on 2017/1/12.
//  Copyright © 2017年 mybook. All rights reserved.
//

import Foundation
import LocalAuthentication

typealias XHBaseResult = (()->())

typealias XHBaseBoolResult = ((_ bool:Bool)->())

typealias SecurityBaseResult = (_ success:Bool,_ error:String?) -> Void

class  SecurityManager {
    
    static var shared = SecurityManager() // This is singleton
    
    // TouchID进行验证
    func authenticateWithTouchID(notSupport:@escaping XHBaseResult,succeed:@escaping XHBaseResult,userCancel:@escaping XHBaseResult,falied:@escaping SecurityBaseResult){
        
        //Create Local Authentication Context
        let authenticationContext = LAContext()
        
        //注意,需要在主线程中进行UI变更.
        var error:NSError?
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            OperationQueue.main.addOperation {
                notSupport()
            }
            
            //print("No Biometric Sensor Has Been Detected. This device does not support Touch Id.")
            return
        }
        
        authenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Only device owner is allowed", reply: { (success, error) -> Void in
            
            if( success ) {
                
                OperationQueue.main.addOperation {
                    succeed()
                }
                
                //print("Fingerprint recognized. You are a device owner!")
            } else {
                
                // Check if there is an error
                if let error = error {
                    switch error {
                    //case LAError.authenticationFailed:
                      //  print("授权失败")
                    //case LAError.passcodeNotSet:
                      //  print("没有设置")
                    //case LAError.systemCancel:
                      //  print("验证被系统取消")
                    case LAError.userCancel:
                        OperationQueue.main.addOperation {
                            userCancel()
                        }
                        
                        //print("验证被用户取消")
                    //case LAError.touchIDNotEnrolled:
                      //  print("验证无法开启，没有登记的手指认证ID")
                    //case LAError.touchIDNotAvailable:
                      //  print("验证无法开启，TouchID不可用")
                    case LAError.userFallback:
                        // 用户点击了取消按钮，要进行登录/输入密码等操作
                        // 在错误列表都应该输入密码来进行操作
                        // 点击输入密码也是进入这里
                        OperationQueue.main.addOperation {
                           userCancel()
                        }
                        
                        //print("用户取消了操作")
                    default:
                        OperationQueue.main.addOperation {
                           falied(false,error.localizedDescription)
                        }
                        
                        //print(error.localizedDescription)
                    }
                    
                }
            }
                
            
        })
    }

}
