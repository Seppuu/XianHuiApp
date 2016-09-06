//
//  Customer.swift
//  XianHui
//
//  Created by jidanyu on 16/8/21.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftDate

class Customer: NSObject {
    
    var id:Int!
    //全局唯一ID,用于IM
    var guid = ""
    var name = ""
    var avatarUrlString = ""
    var type:CustomerLisType!
    var happyLevel = "6分"
    
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
    var time = ""
    //预约时间
    var scheduleTime = ""
    
    var scheduleDate:NSDate? {
        return scheduleTime.toDate("yyyy-mm-dd")
    }
    
    //项目数
    var projectTotal = 1
    //预约状态
    var scheduleStatus = ""
    //预约开始的时间
    var scheduleStartTime = ""
    //档案编号
    var number = ""
    var vipStar = "VIP6"
    var sex   = "女"
    var birthDay = "1981.09.22"
    //卡包数量
    var cardTotal = 0
    var detail:String {
        
        return "\(vipStar) | \(sex) | \(birthDay)"
    }
    
    
}
