//
//  Form.swift
//  XianHui
//
//  Created by jidanyu on 16/9/8.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation
import SwiftyJSON

class Form: NSObject {
    
    //日期 yyyy-MM-dd
    var date = "" {
        didSet {
            let year = date.substring(0, length: 5)
            dateWithOutYear = date.chompLeft(year)
        }
    }
    
    var dateWithOutYear = ""
    
    //man
    var totalScore:Double = 5
    
    //维度数量
    var viewCount:Int {
        return pointArray.count
    }

    var pointArray = [RadarModel]()
    
    
    //雷达图七日平均

    var avgPointArray = [RadarModel]()
    
    //当月累计
    var monthlyTotalProject  = 0
    
    var monthlyTotalCash     = 0
    
    var monthlyTotalProduct  = 0
    
    var monthlyTotalCustomer = 0
    
    var monthlyTotalEmployee = 0
    
    
    //当月平均
    var monthlyAvgProject  = 0
    
    var monthlyAvgCash     = 0
    
    var monthlyAvgProduct  = 0
    
    var monthlyAvgCustomer = 0
    
    var monthlyAvgEmployee = 0
    
    //雷达图下面列表
    var tableListArray = [BaseTableViewModel]()
    
    //饼图
    var chartListArray = [ChartList]()
}

class RadarModel: NSObject {
    
    var name = ""
    var point = 0
    
    var amount:Float = 0
    
    //下属饼图(一般有多个)
    var chartListArr = [ChartModel]()
}



class ChartList: NSObject {
    
    var name = ""
    var charts = [ChartModel]()
}

enum XHChartType :String {
    case pie = "pie"
}

class ChartModel: NSObject {
    var type:XHChartType = .pie
    var name = ""
    var model = [XHChartData]()
    
}



