//
//  ChatExample.swift
//  XianHui
//
//  Created by Seppuu on 16/8/9.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation
import ChatKit
import UIKit

class ChatKitExample: LCChatKitExample {
    
    class func getAllUserIds() -> [String] {
        
        return allUserIds
    }
    

    override func exampleInit() {
        
        super.exampleInit()
        
        addCustomerCellIntoMessageList()
    }
    
    func addCustomerCellIntoMessageList() {
        
        LCChatKit.sharedInstance().conversationListService.cellForRowBlock = {
            (tableView,indexPath,conversation)  in
            
            let cellId = "cell"
            let cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
            cell.textLabel?.text = "这是一个自定义cell."
            
            return cell
        }
        
        
        LCChatKit.sharedInstance().conversationListService.configureCellBlock = {
            (cell,tableView,indexPath,conversation) in
            
            
        }
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
    
    //打开扫一扫
    class func openQRCodeVCForm(viewController:UIViewController) {
        
        let vc = QQScanViewController()
        vc.title = "扫一扫"
        viewController.navigationController?.pushViewController(vc, animated: true)
        
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
    
    //强制重连
    override func lcck_setupForceReconect() {
        
        LCChatKit.sharedInstance().forceReconnectSessionBlock = {

            (aError,granted,viewController,completionHandler) in
            
            let isSingleSignOnOffline = (aError.code == 4111)
            // - 用户允许重连请求，发起重连或强制登录
            if (granted == true) {
                var force = false
                var title = "正在重连聊天服务..."
                if (isSingleSignOnOffline) {
                    force = true
                    title = "正在强制登录..."
                }
                
                //get current viewController
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let vc = appDelegate.window?.visibleViewController!
                NSObject.lcck_showMessage(title, toView: vc!.view)
                let clientId = LCChatKit.sharedInstance().clientId
                LCChatKit.sharedInstance().openWithClientId(clientId, force: force, callback: { (succeeded, error) in
                    
                    NSObject.lcck_hideHUDForView(vc!.view)
                    completionHandler(succeeded, error)
                })
                
                return
            }
            
            // 用户拒绝了重连请求
            // - 退回登录页面
            LCChatKitExample.lcck_clearLocalClientInfo()
            
            //show intro
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.showLoginVC()

            // - 显示返回信息
            let  code = 0
            let errorReasonText = "not granted"
            let errorInfo:[NSObject:AnyObject] = [
                "code" : code,
                NSLocalizedDescriptionKey : errorReasonText
            ]
            
            let klass: AnyClass = object_getClass(self)
            
            let classString = NSStringFromClass(klass)
            let error = NSError(domain: classString, code: code, userInfo: errorInfo)
            
            completionHandler(false, error)
 
        }
        
    }
    
    
}








