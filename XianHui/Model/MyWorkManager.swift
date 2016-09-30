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
    func getBasicInfo(type:MyWorkType) -> ProfileModel {
        //TODO:network
        //var model = ProfileModel()
        
        
        let data = JSON(arrayLiteral: ["aa"])
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
        
        model.avatarUrl = ""
        model.firstLabelString = "张三"
        model.secondLabelString = "会员级别:V"
        model.thirdLabelString = "档案编号:3333"
        
        return model
    }
    
    private func converEmployeeInfo(data:JSON) -> ProfileModel {
        let model = ProfileModel()
        
        model.avatarUrl = ""
        model.firstLabelString = "佳佳"
        model.secondLabelString = "职务:人事专员"
        model.thirdLabelString = "工号:88888"
        
        return model
    }
    
    private func converProjectInfo(data:JSON) -> ProfileModel {
        let model = ProfileModel()
        
        model.avatarUrl = ""
        model.firstLabelString = "回春仪"
        model.secondLabelString = "品牌:戴妃"
        model.thirdLabelString = "编号:3333"
        
        return model
    }
    
    private func converProdInfo(data:JSON) -> ProfileModel {
        let model = ProfileModel()
        
        model.avatarUrl = ""
        model.firstLabelString = "益畅菌"
        model.secondLabelString = "品牌:戴妃"
        model.thirdLabelString = "编号:3333"
        
        return model
    }
    
    
    //获取客户列表信息
    func getBasicTableViewData(type:MyWorkType) -> [BaseTableViewModelList] {
        //var listOfArr = [BaseTableViewModelList]()
        switch type {
        case .customer: return getCustomerSettingData()
        case .employee: return getEmployeeSettingData()
        case .project : return getProjectSettingData()
        case .prod    : return getProdSettingData()
            
        }
        
    }
    
    private func getCustomerSettingData()  -> [BaseTableViewModelList] {
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
                model.desc = "陈旭"
            case "他的卡包":
                model.desc = "共4张卡"
            case "消费记录":
                model.desc = "16/08/10"
            case "项目计划":
                model.desc = "3项"
            case "预约信息":
                model.desc = "16/09/10"
            default:break;
            }
            
            
            list0.list.append(model)
        }
        
        
        listOfArr = [list0]
        
        return listOfArr
    }
    
    private func getEmployeeSettingData()  -> [BaseTableViewModelList] {
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
                model.desc = "海景"
            case "入职日期":
                model.desc = "13/05/02"
            case "手机号码":
                model.desc = "13131313131"
            case "级别":
                model.desc = "AAA"
            default:break;
            }
            
            
            list0.list.append(model)
        }
        
        
        listOfArr = [list0]
        
        return listOfArr
    }
    
    private func getProjectSettingData()  -> [BaseTableViewModelList] {
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
                model.desc = "20人"
            case "满意率":
                model.desc = "72%"
                model.hasList = false
            default:break;
            }
            
            
            list1.list.append(model)
        }
        
        
        listOfArr = [list0,list1]
        
        return listOfArr
    }
    
    private func getProdSettingData()  -> [BaseTableViewModelList] {
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
                model.desc = "20人"
            default:break;
            }
            
            list1.list.append(model)
        }
        
        
        listOfArr = [list0,list1]
        
        return listOfArr
    }
    
    
    
    
    
    
    
    
    
    
}
