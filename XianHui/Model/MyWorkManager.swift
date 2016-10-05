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
    func getBasicInfo(type:MyWorkType,data:JSON) -> ProfileModel {
        //不需要请求了,数据在之前页面的接口中
        return converBasicInfoBy(type, data:data)
        
    }
    
    private func converBasicInfoBy(type:MyWorkType,data:JSON) -> ProfileModel {
    
        switch type {
        case .customer: return converCustomerInfo(data)
        case .employee: return converEmployeeInfo(data)
        case .project : return converProjectInfo(data)
        case .prod    : return converProdInfo(data)

        }
        
    }
    
    private func converCustomerInfo(data:JSON) -> ProfileModel {
        let model = ProfileModel()
        
        model.avatarUrl = data["avator_url"].string!
        model.firstLabelString = data["fullname"].string!
        if let vip = data["vip_star"].string {
            model.secondLabelString = "会员级别:" + vip
        }
        else {
            model.secondLabelString = "会员级别:" + "暂无"
        }
        
        model.thirdLabelString = "档案编号:" + data["cert_no"].string!
        
        return model
    }
    
    private func converEmployeeInfo(data:JSON) -> ProfileModel {
        let model = ProfileModel()
        
        model.avatarUrl = data["avator_url"].string!
        model.firstLabelString = data["display_name"].string!
        model.secondLabelString = "职务:" + data["job"].string!
        model.thirdLabelString = "工号:" + data["user_code"].string!
        
        return model
    }
    
    private func converProjectInfo(data:JSON) -> ProfileModel {
        let model = ProfileModel()
        
        model.avatarUrl = ""
        model.firstLabelString = data["fullname"].string!
        model.secondLabelString = "品牌:" + data["brand_name"].string!
        model.thirdLabelString = "编号:" + data["project_code"].string!
        
        return model
    }
    
    private func converProdInfo(data:JSON) -> ProfileModel {
        let model = ProfileModel()
        
        model.avatarUrl = ""
        model.firstLabelString = data["fullname"].string!
        model.secondLabelString = "品牌:" + data["brand_name"].string!
        model.thirdLabelString = "编号:" + data["item_code"].string!
        
        return model
    }
    
    
    //获取客户列表信息
    func getBasicTableViewData(type:MyWorkType,data:JSON) -> [BaseTableViewModelList] {
        //var listOfArr = [BaseTableViewModelList]()
        switch type {
            
        case .customer: return getCustomerSettingDataWith(data)
        case .employee: return getEmployeeSettingData(data)
        case .project : return getProjectSettingData(data)
        case .prod    : return getProdSettingData(data)
            
        }
        
    }
    
    private func getCustomerSettingDataWith(data:JSON)  -> [BaseTableViewModelList] {
        
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
    
    private func getEmployeeSettingData(data:JSON)  -> [BaseTableViewModelList] {
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
                model.desc = data["org_name"].string!
            case "入职日期":
                model.desc = data["entry_date"].string!
            case "手机号码":
                model.desc = data["mobile"].string!
            case "级别":
                model.desc = "缺失"
            default:break;
            }
            
            
            list0.list.append(model)
        }
        
        
        listOfArr = [list0]
        
        return listOfArr
    }
    
    private func getProjectSettingData(data:JSON)  -> [BaseTableViewModelList] {
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
    
    private func getProdSettingData(data:JSON)  -> [BaseTableViewModelList] {
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
                model.desc = String(data["card_total"].int!) + "人"
                
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
                
            default:break;
            }
            
            list1.list.append(model)
        }
        
        
        listOfArr = [list0,list1]
        
        return listOfArr
    }
    
    
    
    
    
    
    
    
    
    
}
