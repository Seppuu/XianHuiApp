//
//  RealmUser.swift
//  XianHui
//
//  Created by Seppuu on 16/8/9.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUser: Object {
    
    dynamic var userId = ""
    
    dynamic var clientId = ""
    
    //账户名
    dynamic var userName = ""
    
    dynamic var displayName = ""
    
    dynamic var avatarUrl = ""
    
    //企业
    dynamic var orgName = ""
    
    dynamic var orgId = 0
    
    //设置主键
//    override static func primaryKey() -> String? {
//        return "userId"
//    }
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
