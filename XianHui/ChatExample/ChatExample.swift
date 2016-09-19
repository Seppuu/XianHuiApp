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
    }
    
    
    override func lcck_setFetchProfiles() {
        
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
                if callback != nil {
                    callback(nil,error)
                }
                else {
                    
                }
                
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
            
            if callback != nil {
                callback(users,nil)
            }
            else {
                
            }
            
            
        }

        
    }

    //群聊
    override class func exampleCreateGroupConversationFromViewController(viewController: UIViewController!) {
        
        let allPersonIds = allUserIds
        let users = try! LCChatKit.sharedInstance().getCachedProfilesIfExists(allPersonIds, shouldSameCount: true) as! [LCCKContact]
        
        let usersNssetArray = NSSet(array: users) as! Set<LCCKContact>
        
        let allPersonIdsSet = NSSet(array: allUserIds) as! Set<String>
        
        let currentClientID = LCChatKit.sharedInstance().clientId
        let contactListViewController = LCCKContactListViewController(contacts: usersNssetArray , userIds: allPersonIdsSet, excludedUserIds:[currentClientID], mode: LCCKContactListModeMultipleSelection)

        contactListViewController.title = "创建群聊"
        
        contactListViewController.setSelectedContactsCallback { (viewController, peerIds) in
            if (peerIds.count == 0) {
                return
            }
            
            //创建群聊 可以考虑加提示
            LCChatKit.sharedInstance().createConversationWithMembers(peerIds, type:LCCKConversationType.Group , unique: true, callback: { (conversation, error) in
                
                //创建成功
                LCChatKitExample.exampleOpenConversationViewControllerWithConversaionId(conversation.conversationId, fromNavigationController: viewController.navigationController)
                
                //TODO:创建失败
                
            })
            
            
        }
        
        let navigationViewController = UINavigationController(rootViewController: contactListViewController)
        
        viewController.presentViewController(navigationViewController, animated: true, completion: nil)
        
    }
    
    
}












