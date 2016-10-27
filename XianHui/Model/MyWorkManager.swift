//
//  MyWorkManager.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/30.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation
import SwiftyJSON

enum MyWorkType:String {
    
    case customer = "customer"
    case employee = "employee"
    case project  = "project"
    case prod     = "prod"
}

class MyWorkManager {
    
    static var sharedManager = MyWorkManager()
    
    
    //获取基本信息
    func getBasicInfo(_ type:MyWorkType,data:JSON) -> ProfileModel {
        //不需要请求了,数据在之前页面的接口中
        return converBasicInfoBy(type, data:data)
        
    }
    
    fileprivate func converBasicInfoBy(_ type:MyWorkType,data:JSON) -> ProfileModel {
    
        switch type {
        case .customer: return converCustomerInfo(data)
        case .employee: return converEmployeeInfo(data)
        case .project : return converProjectInfo(data)
        case .prod    : return converProdInfo(data)

        }
        
    }
    
    fileprivate func converCustomerInfo(_ data:JSON) -> ProfileModel {
        let model = ProfileModel()
        
        if let avatarUrl = data["avator_url"].string {
            model.avatarUrl = avatarUrl
        }
        
        if let fullName = data["fullname"].string {
            model.firstLabelString = fullName
        }
        
        if let vip = data["vip_star"].string {
            model.secondLabelString = "会员级别:" + vip
        }
        else {
            model.secondLabelString = "会员级别:" + "暂无"
        }
        
        if let certNo =  data["cert_no"].string {
            model.thirdLabelString = "档案编号:" + certNo
        }
        
        
        return model
    }
    
    fileprivate func converEmployeeInfo(_ data:JSON) -> ProfileModel {
        let model = ProfileModel()
        if let avatarUrl = data["avator_url"].string {
            model.avatarUrl = avatarUrl
        }
        
        if let displayName = data["display_name"].string {
            model.firstLabelString = displayName
        }
        
        if let job = data["job"].string {
            model.secondLabelString = "职务:" + job
        }
        
        if let userCode = data["user_code"].string {
            model.thirdLabelString = "工号:" + userCode
        }
    
        
        return model
    }
    
    fileprivate func converProjectInfo(_ data:JSON) -> ProfileModel {
        let model = ProfileModel()
        
        if let fullName = data["fullname"].string {
            model.firstLabelString = fullName
        }
        
        if let avatarUrl = data["avator_url"].string {
            model.avatarUrl = avatarUrl
        }
        
        if let brandName = data["brand_name"].string {
            model.secondLabelString = "品牌:" + brandName
        }
        
        if let projectCode = data["project_code"].string {
            model.thirdLabelString = "编号:" + projectCode
        }
        
        return model
    }
    
    fileprivate func converProdInfo(_ data:JSON) -> ProfileModel {
        let model = ProfileModel()
        
        if let fullName = data["fullname"].string {
            model.firstLabelString = fullName
        }
        
        if let avatarUrl = data["avator_url"].string {
            model.avatarUrl = avatarUrl
        }
        
        if let brandName = data["brand_name"].string {
            model.secondLabelString = "品牌:" + brandName
        }
        
        if let itemCode = data["item_code"].string {
            model.thirdLabelString = "编号:" + itemCode
        }

        return model
    }
    
    
    //获取客户列表信息
    func getBasicTableViewData(_ type:MyWorkType,data:JSON) -> [BaseTableViewModelList] {
        //var listOfArr = [BaseTableViewModelList]()
        switch type {
            
        case .customer: return getCustomerSettingDataWith(data)
        case .employee: return getEmployeeSettingData(data)
        case .project : return getProjectSettingData(data)
        case .prod    : return getProdSettingData(data)
            
        }
        
    }
    
    fileprivate func getCustomerSettingDataWith(_ data:JSON)  -> [BaseTableViewModelList] {
        
        var listOfArr = [BaseTableViewModelList]()
        
        var titlesArr = [
            ["客服经理","他的卡包","消费记录","项目计划","预约信息"]
        ]
        
        let list0 = BaseTableViewModelList()
        list0.listName = ""
        
        for title in titlesArr[0] {
            let model = BaseTableViewModel()
            
            model.hasList = true
            model.name = title
            
            switch title {
            case "客服经理":
                if let customer_manager = data["customer_manager"].string {
                    model.desc = customer_manager
                }
                
            case "他的卡包":
                if let cardTotal = data["card_total"].int {
                    model.desc = "共" + String(cardTotal)
                }
                
            case "消费记录":
                if let last_consume_date = data["last_consume_date"].string {
                    model.desc = last_consume_date
                }
                
            case "项目计划":
                
                if let planned = data["planed"].int {
                    model.desc = String(planned)
                    
                }
                
            case "预约信息":
                if let schedule_date = data["schedule_date"].string {
                    model.desc = schedule_date
                }
                
            default:break;
            }
            
            list0.list.append(model)
        }
        
        listOfArr = [list0]
        
        return listOfArr
    }
    
    fileprivate func getEmployeeSettingData(_ data:JSON)  -> [BaseTableViewModelList] {
        var listOfArr = [BaseTableViewModelList]()
        
        var titlesArr = [
            ["所属店铺","入职日期","手机号码","级别"]
        ]
        
        let list0 = BaseTableViewModelList()
        list0.listName = ""
        
        for title in titlesArr[0] {
            let model = BaseTableViewModel()
            
            model.hasList = false
            model.name = title
            
            switch title {
            case "所属店铺":
                if let orgName = data["org_name"].string {
                   model.desc = orgName
                }
                
            case "入职日期":
                if let date = data["entry_date"].string {
                   model.desc = date
                }
                
            case "手机号码":
                if let mobile = data["mobile"].string {
                   model.desc = mobile
                }
                
            case "级别":
                if let level =  data["user_level"].string {
                    model.desc = level
                }
                
            default:break;
            }
            
            
            list0.list.append(model)
        }
        
        
        listOfArr = [list0]
        
        return listOfArr
    }
    
    fileprivate func getProjectSettingData(_ data:JSON)  -> [BaseTableViewModelList] {
        var listOfArr = [BaseTableViewModelList]()
        
        var titlesArr = [
            ["详细信息","报表参数","销售权限"],
            ["持卡顾客","满意率"]
        ]
        
        let list0 = BaseTableViewModelList()
        list0.listName = "信息与设置"
        
        for title in titlesArr[0] {
            let model = BaseTableViewModel()
            
            model.hasList = true
            model.name = title
            
            switch title {
            case "详细信息":
                model.desc = ""
            case "报表参数":
                model.desc = ""
            case "销售权限":
                model.desc = ""
            default:break;
            }
            
            
            list0.list.append(model)
        }
        
        let list1 = BaseTableViewModelList()
        list1.listName = "数据"
        
        for title in titlesArr[1] {
            let model = BaseTableViewModel()
            
            model.hasList = true
            model.name = title
            
            switch title {
            case "持卡顾客":
                if let cardTotal = data["card_total"].int {
                    model.desc = String(cardTotal) + "人"
                    
                    if cardTotal > 0 {
                        model.hasList = true
                        
                        if let card_customer_list = data["card_customer_list"].array {
                            
                            for customer in card_customer_list {
                                let nextModel = BaseTableViewModel()
//                                "fullname" : "黄葵",
//                                "customer_id" : 26500
                                nextModel.name = customer["fullname"].string!
                                
                                model.listData.append(nextModel)
                            }
                        }
                        
                        
                    }
                    
                }
                
            case "满意率":
                if let satisfy = data["satisfy_rate"].string {
                    model.desc = satisfy
                }
                
                model.hasList = false
            default:break;
            }
            
            
            list1.list.append(model)
        }
        
        
        listOfArr = [list0,list1]
        
        return listOfArr
    }
    
    fileprivate func getProdSettingData(_ data:JSON)  -> [BaseTableViewModelList] {
        var listOfArr = [BaseTableViewModelList]()
        
        var titlesArr = [
            ["详细信息","报表参数","销售权限"],
            ["持卡顾客"]
        ]
        
        let list0 = BaseTableViewModelList()
        list0.listName = "信息与设置"
        
        for title in titlesArr[0] {
            let model = BaseTableViewModel()
            
            model.hasList = true
            model.name = title
            
            switch title {
            case "详细信息":
                model.desc = ""
            case "报表参数":
                model.desc = ""
            case "销售权限":
                model.desc = ""
            default:break;
            }
            
            
            list0.list.append(model)
        }
        
        let list1 = BaseTableViewModelList()
        list1.listName = "数据"
        
        for title in titlesArr[1] {
            let model = BaseTableViewModel()
            
            model.hasList = true
            model.name = title
            
            switch title {
            case "持卡顾客":
                if let cardTotal = data["card_total"].int {
                    model.desc = String(cardTotal) + "人"
                    
                    if data["card_total"].int!   == 0 {
                        model.hasList = false
                    }
                    else {
                        model.hasList = true
                        
                        if let card_customer_list = data["card_customer_list"].array {
                            
                            for customer in card_customer_list {
                                let nextModel = BaseTableViewModel()
                                nextModel.name = customer["fullname"].string!
                                
                                model.listData.append(nextModel)
                            }
                        }   
                    }
                }
                
            default:break;
            }
            
            list1.list.append(model)
        }
        
        
        listOfArr = [list0,list1]
        
        return listOfArr
    }
    
    
}
