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
                sharedUser!.name = Defaults.userName.value!
                sharedUser!.levelText = Defaults.userLevelText.value!
                sharedUser!.avatarURL = Defaults.userAvatarURL.value!
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
    
    var name = ""

    var avatarURL = ""
    
    var clientId = ""


    //Action
    class func loginWith(userName:String,passWord:String,usertype:UserType ,completion:((user:User?,error:String?)->())) {
        
        NetworkManager.sharedManager.loginWith(userName, passWord: passWord, usertype: usertype) { (success, data, error) in
            
            if success {
                
                //获取其他接口的前缀地址
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
                
                
                if let  userName = data!["display_name"].string {
                    Defaults.userName.value = userName
                }
                
                if let avatarURL = data!["avator_url"].string  {
                    Defaults.userAvatarURL.value = avatarURL
                }
                
                let currentUser = User.currentUser()
                currentUser.getUserList()
                completion(user: currentUser, error: nil)
            }
            else {
                completion(user: nil, error: error)
            }
            
        }
        
    }
    
    func getUserList() {
        
        NetworkManager.sharedManager.getUserList { (success, json, error) in
            
            if success == true {
                if let listOfData = json?.array {
                    self.saveUserListWith(listOfData)
                }
            }
        }
    }
    
    func saveUserListWith(listOfData:[JSON]) {
        
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
            
            let realm = try! Realm()
            
            try! realm.write {
                realm.add(rmUser)
            }
        }
        
        allUserIds = clientIds
        
    }
    
    class func getUserBy(id:String) ->  XHUser? {
        
        let realm = try! Realm()
        
        let rmUsersResult = realm.objects(RealmUser).filter("clientId = '\(id)' ")
        
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
                user.name = rmUser.userName
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
    
    func logOut(completion:DDResultHandler) {
        
        NetworkManager.sharedManager.userLogOut { [weak self](success,json,error) in
            
            if success {
                self?.clearUserDefaults()
                completion(success: true,json:nil,error: nil)
            }
            else {
                completion(success: false,json:nil,error: error)
            }
            
        }
        
    }
    
    private func clearUserDefaults() {
        
//        Defaults.userId.clear()
//        Defaults.userPhone.clear()
//        Defaults.userFirstName.clear()
//        Defaults.userLastName.clear()
//        Defaults.userAvatarURL.clear()
        
        if let bid = NSBundle.mainBundle().bundleIdentifier {
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(bid)
        }
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
    
    public static var lessonIdFromScheme: PalauDefaultsEntry<String> {
        get {
            return value("lessonIdFromScheme").whenNil(use: "")
        }
        set {
            
        }
    }
    
}