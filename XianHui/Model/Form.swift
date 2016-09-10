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
    
    //日期
    var date = ""
    
    //man
    var totalScore:Double = 5
    
    //维度数量
    var viewCount = 5
    
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
    
    //雷达图计分
    var cashPoint = 0
    var projectPoint = 0
    var productionPoint = 0
    var customerCountPoint = 0
    var employeePoint = 0
    
    var pointArray:[Int] {
        return [cashPoint,projectPoint,productionPoint,customerCountPoint,employeePoint]
    }
    
    
    
    //雷达图七日平均
    var cashAvgPoint = 0
    var projectAvgPoint = 0
    var productionAvgPoint = 0
    var customerCountAvgPoint = 0
    var employeeAvgPoint = 0
    
    var avgPointArray:[Int] {
        return [cashAvgPoint,projectAvgPoint,productionAvgPoint,customerCountAvgPoint,employeeAvgPoint]
    }
    
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
    //现金
    var cashList = CashList()
    
    //项目
    var projectList = ProjectList()
    
    //产品
    var productList = ProductList()
    
    //客流
    var customerList = CustomerList()
    
    
    //客单价
    var customerUnitPriceList = CustomerUnitPriceList()
    
    //员工人均项目
    var employeeList = EmployeeList()
    
    
    //项目均价
    var projectPriceList = ProjectPriceList()
    
}

class FormDetailList: NSObject {
    
    var name = ""
    
    var amount = ""
    
}

//项目均价和分布列表
class ProjectPriceList: NSObject {
    
    var amount = 0
    
    var dict = [String:JSON]()
}

//员工项目数和分布列表
class EmployeeList: NSObject {
    
    var amount = 0
    
    var dict = [String:JSON]()
}


//客单价和分布列表
class CustomerUnitPriceList: NSObject {
    
    var amount = 0
    
    var dict = [String:JSON]()
}

//客流
class CustomerList: NSObject {
    
    var amount = 0
    
    var list = [Customer]()
}

//产品列表
class ProductList: NSObject {
    
    var amount = 0
    
    //fullname amount
    var list = [Good]()
}


//项目列表
class ProjectList: NSObject {
    
    var amount = 0
    
    //fullname amount
    var list = [Good]()
}

//现金列表
class CashList: NSObject {
    
    var amount = 0
    
    var list = [Good]()
}






