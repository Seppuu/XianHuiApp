//
//  Customer.swift
//  XianHui
//
//  Created by jidanyu on 16/8/21.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class Customer: NSObject {

    var name = ""
    var avatarUrlString = ""
    var stage = "" //消费阶段 (待计划,待咨询,待售后)
    var happyLevel = "6分"
    
    var lastProject = "" //最近的项目
    var lastProduction = ""//最近的消费产品
    
    var time = "" //上次到店距今多久
    
    
    var level = "VIP6"
    var sex   = "女"
    var birthDay = "1981.09.22"
    
    var detail:String {
        
        return "\(level) | \(sex) | \(birthDay)"
    }
    
    
}
