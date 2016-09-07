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
    
    //card list if has
    var hasCardList = false
    
    var cardTimesLeft:Int = 0
    var cardName = ""
    var cardType = ""
    var cardNo = ""
    var cardPrice = ""
    
    //跟踪
    var remainingTime:CGFloat = 0.0
    var remainingTimeString = ""
}


class Good: NSObject {
    
    var id:Int!
    
    var name = ""
    
    var selected = false
    
    //持续时间
    var time = ""
    
    //预约的日期
    var addDate = ""
    
    //结单的日期
    var saledate = ""
    
    //结单价格
    var amount = ""
    
    var type:GoodType = .project
    
    
}