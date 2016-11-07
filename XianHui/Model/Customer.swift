//
//  Customer.swift
//  XianHui
//
//  Created by jidanyu on 16/8/21.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftDate


enum CustomerLisType:String {
    case All = "all"
    case Plan = "plan"
    case Advice = "advice"
    case Service = "service"
}

class Customer: NSObject {
    
    var id:Int!
    //全局唯一ID,用于IM
    var guid = ""
    var name = ""
    var avatarUrlString = ""
    var type:CustomerLisType!
    var happyLevel = "6分"
    var place = ""
    
    //档案编号
    var certNo = ""
    
    //顾问
    var customerManager = ""
    
    var planned = "0"
    
    //最近的项目
    var lastProject = ""
    //最近的消费产品
    var lastProduction = ""
    
    //上次消费时间
    var lastConsumeDate:String?
    //上次到店距今多久
    var time = "0"
    //预约时间
    var scheduleTime = ""
    
    var scheduleDate:Date? {
        return scheduleTime.toDate("yyyy-mm-dd")
    }
    
    //项目数
    var projectTotal = 0
    //预约状态
    var scheduleStatus = ""
    //预约开始的时间
    var scheduleStartTime = ""
    //档案编号
    var number = ""
    var vipStar = "暂无"
    var sex   = "女"
    var birthDay = "1981.09.22"
    //卡包数量
    var cardTotal = 0
    var detail:String {
        
        return "\(vipStar) | \(sex) | \(birthDay)"
    }
    
    
    //报表用 某日消费金额
    var consumeNumDay = ""
    
}

class Employee: User {
    
    var place = ""
    var projectTotal = 0
    var workTime = ""
    var status = ""
    
}
