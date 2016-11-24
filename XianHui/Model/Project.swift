//
//  Project.swift
//  XianHui
//
//  Created by jidanyu on 16/8/22.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

enum ProjectPlanType:Int {
    case customer = 0
    case salesman = 1
}

enum GoodType:Int {
    case project = 0
    case production = 1
}

enum Cardtype:Int {
    case groupCard = 0
    case singleCard = 1
}

//消费项目
class Project: Good {
    
    override init() {
        super.init()
        self.type = .project
    }

    var planType = ProjectPlanType.salesman
    
    //跟踪
    var remainingTime:CGFloat = 0.0
    var remainingTimeString = ""
    
    //今日预约人数
    var scheduleNum = 0
    
    //今日结单人数
    var paidNum = 0
}


//卡项
class GoodCard:NSObject {
    
    var cardTimesLeft:Int = 0
    var cardName = ""
    var cardType = ""
    var cardNo = ""
    var cardPrice = ""
}

class Good: NSObject {
    
    var id:Int!
    
    var name = ""
    
    var place = ""
    
    var avatarUrl = ""
    
    var selected = false
    
    var cardNum = ""
    
    //库存
    var stockNum = "0"
    
    //当日销售数量
    var saleNum = "0"
    
    //持续时间
    var time = ""
    
    //预约的日期
    var addDate = ""
    
    //结单的日期
    var saledate = ""
    
    //结单价格
    var amount = ""
    
    var type:GoodType = .project
    
    //card list if has
    var hasCardList = false
    
    var cardList = [GoodCard]()
    
}
