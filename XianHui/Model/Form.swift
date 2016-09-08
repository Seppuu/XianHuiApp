//
//  Form.swift
//  XianHui
//
//  Created by jidanyu on 16/9/8.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation


class Form: NSObject {
    
    //日期
    var date = ""
    
    //现金
    var cash = 0
    
    //项目/实操
    var project = 0
    
    //产品
    var product = 0
    
    //员工
    var employee = 0
    
    //客流
    var customerCount = 0
    
    //TODO:雷达图计分
    var cashPoint = 0
    var projectPoint = 0
    var productionPoint = 0
    var customerCountPoint = 0
    var employeePoint = 0
    
    
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
    
}