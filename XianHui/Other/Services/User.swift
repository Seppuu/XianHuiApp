//
//  User.swift
//  DingDong
//
//  Created by Seppuu on 16/6/20.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import Foundation
import Palau
import SwiftyJSON
import RealmSwift
import ChatKit

//雇员
enum UserType:String {
    
    case Default = "default"
    case Manager = "manager"
    case Market  = "market"
    case Worker  = "worker"
    case Boss    = "Boss"
    
}

class User:NSObject {
    
    private static var sharedUser : User?
    
    class func currentUser() -> User! {
        // change class to final to prevent override
        guard let uwShared = sharedUser else {
            
            //use disk data to create a user if we can
            if let id = Defaults.userId.value {
                
                sharedUser = User()
                sharedUser!.id = id
                sharedUser!.clientId = Defaults.clientId.value!
                sharedUser!.userName = Defaults.userName.value!
                sharedUser!.displayName = Defaults.userDisplayName.value!
                sharedUser!.levelText = Defaults.userLevelText.value!
                sharedUser!.avatarURL = Defaults.userAvatarURL.value!
                sharedUser!.reportType = Defaults.userReportType.value!
                return sharedUser!
                
            }
            else {
                return nil
            }
            
        }
        return uwShared
    }
    
    
    //property
    
    var id = 0
    
    var levelText = ""
    
    //账户名
    var userName = ""
    
    var displayName = ""

    var avatarURL = ""
    
    var clientId = ""
    
    //报表类型（1技师2顾问3店长4老板）
    var reportType = 0
    
    var userType = UserType.Default

    var passWord = ""
    
    class func loginWithCode(mobile:String,code:String,usertype:UserLoginType,completion:((user:User?,data:JSON?,error:String?)->())) {
        
        NetworkManager.sharedManager.verifyPhoneCodeWith(mobile, usertype: usertype, code: code) { (success, data, error) in
            
            if success {
                
                //获取其他接口的前缀地址  拼接 代理ID
                if let apiUrl = data!["api_url"].string {
                    
                    Defaults.actualApiUrl.value = apiUrl
                }
                
                if let token = data!["token"].string {
                    Defaults.userToken.value = token
                }
                
                if let id = data!["user_id"].int {
                    Defaults.userId.value = id
                }
                
                
                if let clientId = data!["guid"].string {
                    Defaults.clientId.value = clientId
                }
                
                if let user_report_type = data!["user_report_type"].int {
                    Defaults.userReportType.value = user_report_type
                }
                
                
                //账户名
                if let  userName = data!["user_name"].string {
                    Defaults.userName.value = userName
                }
                
                
                if let  userDisplayName = data!["display_name"].string {
                    Defaults.userDisplayName.value = userDisplayName
                }
                
                if let avatarURL = data!["avator_url"].string  {
                    Defaults.userAvatarURL.value = avatarURL
                }
                
                //获取联系人列表之后,完成登陆
                
                NetworkManager.sharedManager.getUserList { (success, json, error) in
                    
                    if success == true {
                        if let listOfData = json?.array {
                            
                            self.saveUserListWith(listOfData)
                            completion(user: User.currentUser(),data: data, error: nil)
                            
                        }
                    }
                    else {
                        //TODO:获取联系人失败.
                        completion(user: nil, data: json, error: error)
                    }
                }
                
                
            }
            else {
                
                completion(user: nil, data: data, error: error)
                
            }
            
        }
        
        
    }
    
    
    class func getContactList(completion:DDResultHandler) {
        
        NetworkManager.sharedManager.getUserList { (success, json, error) in
            
            if success == true {
                if let listOfData = json?.array {
                    self.saveUserListWith(listOfData)
                    completion(success: true, json: nil, error: nil)
                }
            }
            else {
                //获取联系人失败.
                completion(success: false, json: nil, error: error)
            }
        }
    }
    

    //Action
    class func loginWith(mobile:String,passWord:String,usertype:UserLoginType ,completion:((user:User?,data:JSON?,error:String?)->())) {
        
        NetworkManager.sharedManager.loginWith(mobile, passWord: passWord,usertype: usertype) { (success, data, error) in
            
            if success {
                
                //获取其他接口的前缀地址  拼接 代理ID
                if let apiUrl = data!["api_url"].string {
                    
                    Defaults.actualApiUrl.value = apiUrl
                }
                
                if let token = data!["token"].string {
                    Defaults.userToken.value = token
                }
                
                if let id = data!["user_id"].int {
                    Defaults.userId.value = id
                }
                
                if let clientId = data!["guid"].string {
                    Defaults.clientId.value = clientId
                }
                
                if let user_report_type = data!["user_report_type"].int {
                    Defaults.userReportType.value = user_report_type
                }
                
                
                //账户名
                if let  userName = data!["user_name"].string {
                    Defaults.userName.value = userName
                }
                
                
                if let  userDisplayName = data!["display_name"].string {
                    Defaults.userDisplayName.value = userDisplayName
                }
                
                if let avatarURL = data!["avator_url"].string  {
                    Defaults.userAvatarURL.value = avatarURL
                }
                
                //save passWord and account for auto change account
                Defaults.currentPassWord.value = passWord
                Defaults.currentAccountName.value = mobile
                
                //获取联系人列表之后,完成登陆
                NetworkManager.sharedManager.getUserList { (success, json, error) in
                    
                    if success == true {
                        if let listOfData = json?.array {
                            
                            self.saveUserListWith(listOfData)
                            completion(user: User.currentUser(),data: data, error: nil)
                            
                        }
                    }
                    else {
                        //TODO:获取联系人失败.
                        completion(user: nil, data: json, error: error)
                    }
                }
                
                
            }
            else {
                
                completion(user: nil, data: data, error: error)
            
        }
        
    }
    
    }
    
    func getUserList() {
        
        
    }
    
    class func saveUserListWith(listOfData:[JSON]) {
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
        var clientIds = [String]()
        
        for data in listOfData {
            
            let rmUser = RealmUser()
            if let id = data["user_id"].int {
                let stringID = String(id)
                rmUser.userId = stringID
            }
            
            if let clientId = data["guid"].string {
                rmUser.clientId = clientId
                clientIds.append(clientId)
            }
            
            if let name = data["display_name"].string {
                rmUser.userName = name
            }
            
            if let avatarUrl = data["avator_url"].string {
                rmUser.avatarUrl = avatarUrl
            }
            
            try! realm.write {
                realm.add(rmUser)
            }
        }
        
        allUserIds = clientIds
        
    }
    
    class func getUserBy(clientId:String) ->  XHUser? {
        
        let realm = try! Realm()
        
        let rmUsersResult = realm.objects(RealmUser).filter("clientId = '\(clientId)' ")
        
        if rmUsersResult.count > 0 {
            let rmUser = rmUsersResult[0]
            guard let url = NSURL(string: rmUser.avatarUrl) else { return nil  }
            
            let user = XHUser(userId: rmUser.clientId, name: rmUser.userName, avatarURL:url, clientId: rmUser.clientId)
            
            return user
        }
        else {
            return nil
        }
        
    }
    
    class func setAlluserId(){
        
        var clientIds = [String]()
        
        let realm = try! Realm()
        
        let rmUsersResult = realm.objects(RealmUser)
        
        if rmUsersResult.count > 0 {
            
            for rmUser in rmUsersResult {
                
                 clientIds.append(rmUser.clientId)
            }
        }
        
        allUserIds = clientIds
    }
    
    
    class func getAllUser() -> [User] {
        
        var users = [User]()
        
        let realm = try! Realm()
        
        let rmUsersResult = realm.objects(RealmUser)
        
        if rmUsersResult.count > 0 {
            
            for rmUser in rmUsersResult {
                let user = User()
                user.id = Int(rmUser.userId)!
                user.clientId = rmUser.clientId
                user.userName = rmUser.userName
                user.displayName = rmUser.displayName
                user.avatarURL = rmUser.avatarUrl
                
                users.append(user)
            }
        }
        
        return users
        
    }
    
    func saveUserInfoInBack(with firstName:String,lastName:String,avatar:NSData?,completion:DDResultHandler) {
        
        //TODO:
        NetworkManager.sharedManager.updateUserInfo(with: firstName, lastName: lastName, avatarData: avatar) { (success, json,error) in
            
            if success {
                let user = User.currentUser()
                
                user.avatarURL = json!["avator"].string!
                
                completion(success: true,json: nil,error: nil)
            }
            else {
                completion(success: false,json: nil,error: nil)
            }
            
        }
        
    }
    
    class func saveAvatarWith(image:UIImage,completion:((success:Bool)->())) {
        
        NetworkManager.sharedManager.updateUserAvatarWith(image) { (success, avatarUrlString, error) in
            
            if success == true {
                
                let user = User.currentUser()
                user.avatarURL = (avatarUrlString?.string)!
                
                Defaults.userAvatarURL.value = user.avatarURL
                
                completion(success: true)
            }
            else {
                completion(success: false)
            }
            
        }
        
    }
    
    class func logOut(completion:DDResultHandler ,failed:LCCKErrorBlock) {
        
        //先退出IM
        ChatKitExample.invokeThisMethodBeforeLogoutSuccess({
            //log out xianhui server
            let user = User.currentUser()
            user.logOut(completion)
            }, failed: failed)
        
    }
    
    
    func logOut(completion:DDResultHandler) {
        
        NetworkManager.sharedManager.userLogOut { [weak self](success,json,error) in
            
            if success {
                self?.clearUserDefaults()
                //clean files
                cleanRealmAndCaches()
                completion(success: true,json:nil,error: nil)
            }
            else {
                completion(success: false,json:nil,error: error)
            }
            
        }
        
    }
    
    private func clearUserDefaults() {
        
        Defaults.userId.clear()
        Defaults.clientId.clear()
        Defaults.userName.clear()
        Defaults.userDisplayName.clear()
        Defaults.userAvatarURL.clear()
        Defaults.userLevelText.clear()
        Defaults.userReportType.clear()
        
        User.sharedUser = nil
        
        
        self.userName = ""
    
        self.id = 0
        
        self.levelText = ""
        
        self.displayName = ""
        
        self.avatarURL = ""
        
        self.clientId = ""
        
    }
    
}

extension PalauDefaults {
    
    public static var userId: PalauDefaultsEntry<Int> {
        get {
            return value("userId")
        }
        set {
            
        }
    }
    
    public static var clientId: PalauDefaultsEntry<String> {
        get {
            return value("clientId").whenNil(use: "")
        }
        set {
            
        }
    }
    
    public static var userName: PalauDefaultsEntry<String> {
        get {
            return value("userName").whenNil(use: "")
        }
        set {
            
        }
    }
    
    
    public static var userDisplayName: PalauDefaultsEntry<String> {
        get {
            return value("userDisplayName").whenNil(use: "")
        }
        set {
            
        }
    }
    
    
    public static var userAvatarURL: PalauDefaultsEntry<String> {
        get {
            return value("userAvatarURL").whenNil(use: "")
        }
        set {
            
        }
    }
    
    public static var userLevelText: PalauDefaultsEntry<String> {
        get {
            return value("userLevelText").whenNil(use: "普通用户")
        }
        set {
            
        }
    }
    
    public static var userReportType: PalauDefaultsEntry<Int> {
        get {
            return value("userReportType").whenNil(use: 0)
        }
        set {
            
        }
    }
    
    
    //多企业的时候.共享密码
    public static var currentPassWord: PalauDefaultsEntry<String> {
        get {
            return value("currentPassWord").whenNil(use: "")
        }
        set {
            
        }
    }
    
    public static var currentAccountName: PalauDefaultsEntry<String> {
        get {
            return value("currentAccountName").whenNil(use: "")
        }
        set {
            
        }
    }
    
    
}
