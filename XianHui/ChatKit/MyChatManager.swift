//
//  MyChatManager.swift
//  MyChat
//
//  Created by Seppuu on 16/7/18.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

private let appID = "wciU4iW0lEVmc9EJ9WzmhyGw-gzGzoHsz"
private let appKey = "eXUtSMYSxVCJhE4IHOiGWabv"

private let username = "username"
private let objectId = "objectId"
private let updatedAt = "updatedAt"

class MyChatManager: LCCKSingleton {
    
    //胶水函数
    func invokeThisMethodInDidFinishLaunching() {
        AVOSCloud.registerForRemoteNotification()
        AVIMClient.setTimeoutIntervalInSeconds(20)
    }
    
    func invokeThisMethodInDidRegisterForRemoteNotificationsWithDeviceToken(deviceToken:NSData) {
        AVOSCloud.handleRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    //退出账号前
    func invokeThisMethodBeforeLogoutSuccess(success:LCCKVoidBlock,failed:LCCKErrorBlock) {
        
        LCChatKit.sharedInstance().removeAllCachedProfiles()
        LCChatKit.sharedInstance().closeWithCallback { (succeed, error) in
            if succeed == true {
                 LCCKUtil.showNotificationWithTitle("退出成功", subtitle: nil, type: LCCKMessageNotificationTypeSuccess)
                success()
            }
            else {
                LCCKUtil.showNotificationWithTitle("退出成功", subtitle: nil, type: LCCKMessageNotificationTypeError)
                failed(error)
            }
        }
    }
    
    //登录成功前
    func invokeThisMethodAfterLoginSuccessWithClientId(clientId:String,success:LCCKVoidBlock,failed:LCCKErrorBlock) {
        
        self.initIM()
        
        LCChatKit.sharedInstance().openWithClientId(clientId) { (succeed, error) in
            
            if succeed == true {
                let userID = "用户ID是:" + clientId
                LCCKUtil.showNotificationWithTitle("登录成功", subtitle: userID, type: LCCKMessageNotificationTypeSuccess)
                success()
            }
            else {
                LCCKUtil.showNotificationWithTitle("登录失败", subtitle: nil, type: LCCKMessageNotificationTypeError)
                failed(error)
            }
        }
        
        //TODO:
    }
    
    
    
    func initIM() {
        
        LCChatKit.setAppId(appID, appKey: appKey)
        
        LCChatKit.sharedInstance().fetchProfilesBlock = { (userIds,callback) in
            
            if userIds.count == 0 {
                
                let code = 0
                let errorReasonText = "User ids is nil"
                let errorInfo:[NSObject:AnyObject] = [
                    "code":code,
                    NSLocalizedDescriptionKey:errorReasonText
                ]
                
                let error = NSError(domain: "LCChatKit", code: code, userInfo: errorInfo)
                callback(nil,error)
                
            }
            else {
                var users = [LCCKUser]()
                
                userIds.forEach({ (clientId) in
                    //模拟从服务器搜索用户.如果失败,则保存一个client
                    //clientId 是 用户ID.
                    let q = AVUser.query()
                    q.cachePolicy = .CacheThenNetwork
                    q.whereKey(objectId, equalTo: clientId)
                    q.findObjectsInBackgroundWithBlock({ (objs, error) in
                        
                        if error == nil {
                            
                            if let avUsers = objs as? [AVUser] {
                                let avUser = avUsers[0]
                                var avatarUrl = NSURL()
                                if let avatarFile = avUser["avatar"]  as? AVFile {
                                    
                                    avatarUrl = NSURL(string:avatarFile.url)!
                                }
                                let user = LCCKUser(userId: avUser.objectId, name: avUser.username, avatarURL: avatarUrl, clientId: clientId)
                                users.append(user)
                            }
                            
                        }
                        else {
                            let user = LCCKUser(objectId: clientId)
                            users.append(user)
                            print(error.description)
                        }
                    })
                    
                })
                
                callback(users,nil)
            }
        }
    
        //联系人列表被点击
        LCChatKit.sharedInstance().didSelectConversationsListCellBlock = {
            (indexPath,conv,controller) in
            
        }
        
        //联系人列表被删除
        LCChatKit.sharedInstance().didDeleteConversationsListCellBlock = {
            (indexPath,conv,controller) in
            
        }
        
        //预览图片消息
        LCChatKit.sharedInstance().previewImageMessageBlock = {
            (index,allVisibleImages,allVisibleThumbs,userInfo) in
            
        }
        
        //长按信息
//        LCChatKit.sharedInstance().longPressMessageBlock = {
//            (message,userInfo) -> [UIMenuItem] in
//            
//            return [UIMenuItem()]
//        }
        
        LCChatKit.sharedInstance().HUDActionBlock = {
            (viewController,title,type) in
            
        }
        
        //打开聊天页面右上角用户主页
        LCChatKit.sharedInstance().openProfileBlock = {
            (userId,user,parentController) in
            
            
        }
        
        LCChatKit.sharedInstance().avatarImageViewCornerRadiusBlock = {
            (avatarImageViewSize) -> CGFloat in
            
            if (avatarImageViewSize.height > 0) {
                return avatarImageViewSize.height/2
            }
            return 5;
        }
        
        //自定义Cell
        LCChatKit.sharedInstance().conversationEditActionBlock = {
            (indexPath,editActions,conversation,controller) -> [AnyObject] in
            
            return [AnyObject]()
        }
        
        LCChatKit.sharedInstance().markBadgeWithTotalUnreadCountBlock = {
            (totalUnreadCount,controller) in
            
        }
        
        LCChatKit.sharedInstance().previewLocationMessageBlock = {
            (location,geolocations,userInfo) in
            
        }
        
        LCChatKit.sharedInstance().sessionNotOpenedHandler = {
            (viewController,callback) in
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
