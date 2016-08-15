//
//  ChatExample.swift
//  XianHui
//
//  Created by Seppuu on 16/8/9.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation
import ChatKit

class ChatKitExample: LCChatKitExample {
    
    class func getAllUserIds() -> [String] {
        
        return allUserIds
    }
    

    override func exampleInit() {
        
        super.exampleInit()
        
        LCChatKit.sharedInstance().fetchProfilesBlock = {
            (userIds,callback) in
            
            if userIds.count == 0 {
                let code = 0
                let errorReasonText = "User ids is nil"
                let errorInfo = [
                    "code" :code,
                    NSLocalizedDescriptionKey:errorReasonText,
                    
                    ]
                
                let error = NSError(domain: "LCChatKit", code: code, userInfo: errorInfo as [NSObject : AnyObject])
                
                callback(nil,error)
                return
            }
            var users = [XHUser]()
            userIds.forEach({ (userId) in
                
                if let user = User.getUserBy(userId) {
                    users.append(user)
                }
                else {
                    let user = XHUser(clientId: userId)
                    users.append(user)
                }
                
            })
            
            callback(users,nil)
            
        }
        
    }
    

    
}
    
