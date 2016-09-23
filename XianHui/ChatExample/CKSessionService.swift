//
//  CKSessionService.swift
//  XianHui
//
//  Created by jidanyu on 16/9/22.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation
import ChatKit

//ChatKit 会话服务

extension LCCKSessionService {
    
    
}


class CKSessionService: LCCKSessionService {
    

//    var XH_isRequestingSingleSignOn:Bool {
//        return requestingSingleSignOn
//    }
//    
//    //强制登陆弹窗
//    override func requestForceSingleSignOnAuthorizationWithCallback(callback: LCCKRequestAuthorizationBoolResultBlock!) {
//        
//        
//        if (self.XH_isRequestingSingleSignOn == true) {
//            return
//        }
//        self.requestingSingleSignOn = true
//
//        let title = "当前账号已在其它设备登录，请问是否强制登录？或者冻结账户。强制登录会踢掉当前已经登录的设备。"
//        
//        let alert = LCCKAlertController(title: title, message: "", preferredStyle: .Alert)
//        
//        let cancelActionTitle = "取消"
//        let cancelAction = LCCKAlertAction(title: cancelActionTitle, style: .Default) { (action) in
//            
//            let  code = 0
//            let errorReasonText = "request force single sign on failed"
//            let errorInfo:[NSObject : AnyObject] = [
//                "code":(code),
//                NSLocalizedDescriptionKey : errorReasonText
//            ]
//            
//            let error = NSError(domain: LCCKSessionServiceErrorDomain, code: code, userInfo: errorInfo)
//            
//            callback(false, error);
//            self.requestingSingleSignOn = false
//            
//        }
//
//        alert.addAction(cancelAction)
//        
//        let forceOpenActionTitle = "确认"
//        let forceOpenAction = LCCKAlertAction(title: forceOpenActionTitle, style: .Default) { (action) in
//            
//            callback(true, nil)
//            self.requestingSingleSignOn = false
//
//        }
//        
//        alert.addAction(forceOpenAction)
//        alert.showWithSender(nil, controller: nil, animated: true, completion: nil)
//
//    }
    
    
}
