//
//  Production.swift
//  XianHui
//
//  Created by jidanyu on 16/8/23.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftDate


//口服类产品
class Production: Good {
    
    override init() {
        super.init()
        self.type = .production
    }
    
    //规格
    var total:Double = 0.0//总量
    var unit  = "" //单位
    var oneTimeUse:Double = 0.0 //每日用量
    
    var frequency:Double = 1.0 //使用频率(天)
    
    
    var startDay = ""
    var endDay   = ""
    
    
    var startTime: Date {
        
        return startDay.toDate("yyyy年MM月dd日") != nil ? startDay.toDate("yyyy年MM月dd日")! : Date()
    }
    
    var endTime: Date {
        
        let date = startTime
        
        let timeInterval = (total / oneTimeUse) * frequency * (60*60*24)
        let endDate = Date(timeInterval: timeInterval, since: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        endDay =  dateFormatter.string(from: endDate)
        
        return endDate
        
    }
    
    //产品服用完所需的天数
    var durationDay: String? {
        
        let day = startTime.differenceInDaysWithDate(endTime)
        
        return String(day)
    }
    
    //从今日起剩余的天数
    var remainedDay:String {

        if startTime > Date() {
            return "未开始"
        }
        else {
            
            let day = Date().differenceInDaysWithDate(endTime)
            
            return String(day)
        }
    }
    
    
    
    //跟踪
    var remainingTime:CGFloat {
        
        if durationDay == nil {
            
            return 0.0
        }
        else {
            
            return CGFloat( (remainedDay.toFloat())!/(durationDay?.toFloat())! )
        }
        
    }
    
}


extension Date {
    
    //计算日期差
    func differenceInDaysWithDate(_ date: Date) -> Int {
        let calendar: Calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        
        let components = (calendar as NSCalendar).components(.day, from: date1, to: date2, options: [])
        return components.day!
    }
    
}
