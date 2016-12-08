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
import SwiftyJSON

class ChatKitExample: LCChatKitExample {
    
    class func getAllUserIds() -> [String] {

        return allUserIds
    }
    

    override func exampleInit() {
        
        super.exampleInit()
        
        addCustomerCellIntoMessageList()
        
        addSaveConvIdNoti()
        
    }
    
    
    //监听,LCCKNotificationConversationListDataSourceUpdated来获取最新的最近消息列表IDs.保存至服务器
    func addSaveConvIdNoti() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatKitExample.saveConversationListID(_:)), name: NSNotification.Name(rawValue: LCCKNotificationConversationListDataSourceUpdated), object: nil)
    }
    
    func saveConversationListID(_ noti:Notification) {
        
        guard let conversationService  = noti.object as? LCCKConversationService else {return}
        
        guard let convs = conversationService.allRecentConversations() as? [AVIMConversation] else {return}
        
        var idsParam = ""
        
        for conv in convs {
            
            guard let id = conv.conversationId else {return}
            idsParam += id + ","
        }
        if convs.count == 0 {
           return
        }
        
        idsParam.characters.removeLast()
        
        NetworkManager.sharedManager.saveConversationListwith(convIds: idsParam) { (success, json, error) in
            
            if success == true {
                
            }
            else {
                
            }
        }
        
    }
    
    public class func updateMessageListVC() {
        
        
//        if isFirstLaunch == true {
//            
//        }
//        else {
//            return
//        }
        
        NetworkManager.sharedManager.getConversationList { (success, json, error) in
            
            if success == true {
                var convIDs = [String]()
                if let datas = json?.array {
                    for data in datas {
                        if let id = data["conv_id"].string {
                            
                            convIDs.append(id)
                            
                        }
                    }

                    self.updateConvsListInLocal(with:convIDs)

                }
                
            }
            else {
                
            }
        }
        
        
    }
    
    class func updateConvsListInLocal(with conversationIDs:[String]) {
        
        let idSet = NSSet(array: conversationIDs)
        let param = idSet as! Set<String>
        LCChatKit.sharedInstance().conversationService.fetchConversations(withConversationIds: param) { (results, error) in
            
            if error == nil {
                
                /*我直接更新最近联系人会话，应该可以吧，因为 [[LCCKConversationService sharedInstance] updateRecentConversation:objects];
                 这个方法最后会发送一个通知， [[NSNotificationCenter defaultCenter] postNotificationName:LCCKNotificationConversationListDataSourceUpdated object:self]，
                 然后LCCKConversationListViewModel会Refresh tableView*/
                LCChatKit.sharedInstance().conversationService.updateRecentConversation(results, shouldRefreshWhenFinished: true)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LCCKNotificationConversationListDataSourceUpdated), object: nil)
                
                
               // [[LCCKConversationService sharedInstance] updateRecentConversation:objects];
                
                if let convs = results as? [AVIMConversation] {
                    for conv in convs.reversed() {
                        LCChatKit.sharedInstance().conversationService.insertRecentConversation(conv)
                    }
                    
                }
            }
            else {
                
            }
        }
    }
    
    func addCustomerCellIntoMessageList() {
        
        LCChatKit.sharedInstance().conversationListService.configureCellBlock = {
            (cell,tableView,indexPath,conversation) in
            
            tableView?.separatorStyle = .singleLine
            //tableView?.cellLayoutMarginsFollowReadableWidth = false
            tableView?.separatorInset = UIEdgeInsetsMake(0, 64, 0, 0)
            cell?.layoutMargins = UIEdgeInsetsMake(0, 64, 0, 0)
            let messageCell = cell as? LCCKConversationListCell
            if let conv = conversation {
                if let lastMessage = conv.lcck_lastMessage {
                    
                    if let attr = lastMessage.attributes {
                        
                        if let _ = attr["notice_id"] as? String {
                            messageCell?.messageTextLabel.text = lastMessage.text
                            
                            //因为ChatKit中将系统消息按群聊处理了,所以这了对文本做些处理
                            
                            let mutableText = LCCKLastMessageTypeManager.attributedString(with: lastMessage, conversation: conv, userName: "") as? NSMutableAttributedString
                            let range = NSMakeRange(0, 1)
                            mutableText?.deleteCharacters(in: range)
                            //TODO:警告处理
                            if let text = mutableText as? NSAttributedString {
                                messageCell?.messageTextLabel.attributedText = text
                            }
                            
                            if let avatarUrl = attr["avator"] as? String {
                                if let url = URL(string: avatarUrl) {
                                    messageCell?.avatarImageView.kf.setImage(with: url)
                                }
                                
                            }
                            
        
                        }
                    }
                    
                    
                }
                
                
            }
        }
    }
    
    override func lcck_setupConversationsCellOperation() {
        
        //选中某个对话后的回调,设置事件响应函数
        LCChatKit.sharedInstance().didSelectConversationsListCellBlock = {
            (indexPath,conversation,controller) in
            //conversation?.markAsReadInBackground()
            
            if let conv = conversation {
                if let lastMessage = conv.lcck_lastMessage {

                    if let attr = lastMessage.attributes {

                        if let noticeType = attr["notice_type"] as? String {
                            if noticeType == "daily_report" || noticeType == "project_plan" {
                                let vc = HelperVC()
                                vc.title = "助手"
                                LCChatKitExample.lcck_push(to: vc)
                            }
                            else if noticeType == "process" {
                                //进度的推送
                                if let taskId = attr["extra_id"] as? String {
                                    
                                    let task = Task()
                                    task.id = Int(taskId)!
                                    
                                    let vc = TaskDetailVC()
                                    vc.title = "进度详细"
                                    task.isUpdated = false
                                    vc.task = task
                                    LCChatKitExample.lcck_push(to: vc)
                                }
                                
                            }
                            else {
                                let vc = NoticeListVC()
                                vc.title = "提醒"
                                LCChatKitExample.lcck_push(to: vc)
                            }
                            //设置当前对话,为了消除未读标记.chatKit默认点击系统消息进入会话界面.
                            LCChatKit.sharedInstance().conversationService.currentConversation = conversation
                            LCChatKit.sharedInstance().conversationService.updateConversationAsRead()

                            return
                        }
                    }
                    else {
                        
                    }
                    
                    
                }
            
        }
            
            //非系统消息,选中某个对话后的回调,设置事件响应函数
            ChatKitExample.exampleOpenConversationViewController(withConversaionId: conversation?.conversationId, from: controller?.navigationController)
            
        }
        
        //删除某个对话后的回调 (一般不需要做处理)
        LCChatKit.sharedInstance().didDeleteConversationsListCellBlock = {
            (indexPath,conversation,controller) in
            //TODO:
        }

    }
    
    
    override func lcck_setFetchProfiles() {
        
        LCChatKit.sharedInstance().fetchProfilesBlock = {
            (clientIds,callback) in
            
            if clientIds?.count == 0 {
                let code = 0
                let errorReasonText = "User ids is nil"
                let errorInfo = [
                    "code" :code,
                    NSLocalizedDescriptionKey:errorReasonText,
                    
                    ] as [String : Any]
                
                let error = NSError(domain: "LCChatKit", code: code, userInfo: errorInfo as [AnyHashable: Any])
                if callback != nil {
                    callback!(nil,error)
                }
                else {
                    
                }
                
                return
            }
            var users = [XHUser]()
            clientIds?.forEach({ (id) in
                
                if let user = User.getUserBy(id) {
                    users.append(user)
                }
                else {
                    let user = XHUser(clientId: id)
                    users.append(user!)
                }
                
            })
            
            if callback != nil {
                callback!(users,nil)
            }
            else {
                
            }
        }
    }
    
    //打开扫一扫
    class func openQRCodeVCForm(_ viewController:UIViewController) {
        
        let vc = QQScanViewController()
        vc.title = "扫一扫"
        viewController.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //群聊
    override class func exampleCreateGroupConversation(from viewController: UIViewController!) {
        
        let allPersonIds = allUserIds
        let users = try! LCChatKit.sharedInstance().getCachedProfilesIfExists(allPersonIds, shouldSameCount: true) as! [LCCKContact]
        
        let usersNssetArray = NSSet(array: users) as! Set<LCCKContact>
        
        let allPersonIdsSet = NSSet(array: allUserIds) as! Set<String>
        
        let currentClientID = LCChatKit.sharedInstance().clientId
        let contactListViewController = LCCKContactListViewController(contacts: usersNssetArray , userIds: allPersonIdsSet, excludedUserIds:[currentClientID!], mode: LCCKContactListModeMultipleSelection)

        contactListViewController.title = "创建群聊"
        
        contactListViewController.setSelectedContactsCallback { (viewController, peerIds) in
            if (peerIds.count == 0) {
                return
            }
            
            //创建群聊 可以考虑加提示
            LCChatKit.sharedInstance().createConversation(withMembers: peerIds, type:LCCKConversationType.group , unique: true, callback: { (conversation, error) in
                
                //创建成功
                LCChatKitExample.exampleOpenConversationViewController(withConversaionId: conversation!.conversationId, from: viewController.navigationController)
                
                //TODO:创建失败
            })
        }
        
        let navigationViewController = UINavigationController(rootViewController: contactListViewController)
        
        viewController.present(navigationViewController, animated: true, completion: nil)
        
    }
    
    //强制重连
    override func lcck_setupForceReconect() {
        
        LCChatKit.sharedInstance().forceReconnectSessionBlock = {

            (aError,granted,viewController,completionHandler) in
            
            
            // - 用户允许重连请求，发起重连或强制登录
            if (granted == true) {
                var force = false
                var title = "正在重连聊天服务..."
                
                if aError == nil {
                    
                }
                else {
                    
                    let isSingleSignOnOffline = (aError?._code == 4111)
                    
                    if (isSingleSignOnOffline) {
                        force = true
                        title = "正在强制登录..."
                    }

                }
                
                //get current viewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let vc = appDelegate.window?.visibleViewController!
                NSObject.lcck_showMessage(title, to: vc!.view)
                let clientId = LCChatKit.sharedInstance().clientId
                LCChatKit.sharedInstance().open(withClientId: clientId, force: force, callback: { (succeeded, error) in
                    
                    NSObject.lcck_hideHUD(for: vc!.view)
                    completionHandler!(succeeded, error)
                })
                
                return
            }
            
            // 用户拒绝了重连请求
            // - 退回登录页面
            LCChatKitExample.lcck_clearLocalClientInfo()
            
            //show intro
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.showGuide()

            // - 显示返回信息
            let  code = 0
            let errorReasonText = "not granted"
            let errorInfo:[AnyHashable: Any] = [
                "code" : code,
                NSLocalizedDescriptionKey : errorReasonText
            ]
            
            let klass: AnyClass = object_getClass(self)
            
            let classString = NSStringFromClass(klass)
            let error = NSError(domain: classString, code: code, userInfo: errorInfo)
            
            completionHandler!(false, error)
 
        }
        
    }
    
    //会话点击左右头像
    override func lcck_exampleOpenProfile(forUser user: LCCKUserDelegate!, userId: String!, parentController: UIViewController!) {
        let clientId = userId
        if let user = User.getUserBy(clientId!) {
            
            if let id = user.userId.toInt() {
                NetworkManager.sharedManager.getEmployeeDetailWith(id, completion: { (success, json, error) in
                    // hud.hide(true)
                    if success == true {
                        let vc = EmployeeProfileVC()
                        vc.isShowRightBar = false
                        vc.title = "详细资料"
                        vc.type = .employee
                        vc.profileJSON = json!
                        vc.profileDetailJSON = json!
                        
                        parentController.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                })
            }
        }
        
        
    }
    
    //会话点击右上icon,进入详细资料.
    override func lcck_setupOpenConversation() {
        
        LCChatKit.sharedInstance().fetchConversationHandler = {
            (conversation,aConversationController) in
            
            if conversation?.createAt == nil {return}
            
            if conversation?.members == nil {return}
            
            if ((conversation?.members?.count)! > 2) {
                super.lcck_setupOpenConversation()
            }
            else if conversation?.members?.count == 2 {
                
                aConversationController?.configureBarButtonItemStyle(.singleProfile, action: { (sender, event) in
                    
                   // let hud = showHudWith(aConversationController.view, animated: true, mode: .Indeterminate, text: "")
                    if let memebers = conversation?.members as? [String] {
                        let currentUserClientId = LCChatKit.sharedInstance().clientId
                        var clientId = ""
                        
                        memebers.forEach({ (id) in
                            if id != currentUserClientId {
                                clientId = id
                            }
                        })
                        
                        if let user = User.getUserBy(clientId) {
                            
                            if let id = user.userId.toInt() {
                                NetworkManager.sharedManager.getEmployeeDetailWith(id, completion: { (success, json, error) in
                                   // hud.hide(true)
                                    if success == true {
                                        let vc = EmployeeProfileVC()
                                        vc.isShowRightBar = false
                                        vc.title = "详细资料"
                                        vc.type = .employee
                                        vc.profileJSON = json!
                                        vc.profileDetailJSON = json!
                                        
                                        aConversationController?.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    
                                })
                            }
                        }
                        
                    }
                    
                })
                
                
            }
            else {
                
            }
            
        }
        
    }
    
   
}








