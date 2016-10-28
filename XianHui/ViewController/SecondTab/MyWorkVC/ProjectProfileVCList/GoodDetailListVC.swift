//
//  GoodDetailListVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/10/5.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

//详细信息 报表参数 销售权限
enum GoodProfileType:Int {
    case first = 0
    case second
    case third
}

class GoodDetailListVC: BaseTableViewController {
    
    var isProject = false
    
    var json:JSON!
    
    var goodProfileType:GoodProfileType = .first

    override func viewDidLoad() {
        super.viewDidLoad()

        switch goodProfileType {
        case .first:
            makeDetailModel()
        case .second:
            makeReportModel()
        case .third:
            makeMarketModel()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func makeDetailModel() {
        
        title = "详细信息"
        if isProject == true {
            
            let m0 = BaseTableViewModel()
            m0.name = "项目部位"
            if let project_type = json["project_type"].string {
                m0.desc = project_type
            }
            
            let m1 = BaseTableViewModel()
            m1.name = "针对部位"
            if let project_class = json["project_class"].string {
                m1.desc = project_class
            }
            
            let m2 = BaseTableViewModel()
            m2.name = "单价"
            if let retail_price = json["retail_price"].string {
                m2.desc = retail_price
            }
            
            let m3 = BaseTableViewModel()
            m3.name = "操作时长"
            if let hours = json["hours"].string {
                m3.desc = hours + "小时"
            }
            
            let m4 = BaseTableViewModel()
            m4.name = "操作类型"
            if let op_type = json["op_type"].string {
                m4.desc = op_type
            }
            
            let m5 = BaseTableViewModel()
            m5.name = "产品配料"
            
            if let formulas = json["formula"].array {
                m5.desc = String(formulas.count) + "种"
                
                if formulas.count > 0 {
                    m5.hasList = true
                    
                    for formula in formulas{
                        
                        let nextModel = BaseTableViewModel()
                        if let fullName = formula["fullname"].string {
                            nextModel.name = fullName
                        }
                        
                        
                        m5.listData.append(nextModel)
                    }
                    
                }
            }

            
            let list = BaseTableViewModelList()
            list.listName = ""
            list.list = [m0,m1,m2,m3,m4,m5]
            
            self.listArray = [list]
            
        }
        else {
            let m0 = BaseTableViewModel()
            m0.name = "货品类型"
            if let item_class = json["item_class"].string {
                m0.desc = item_class
            }
            
            let m1 = BaseTableViewModel()
            m1.name = "包装单位"
            if let spec = json["spec"].string {
                m1.desc = spec
            }
            
            let m2 = BaseTableViewModel()
            m2.name = "消耗单位"
            if  let use_spec  = json["use_spec"].string {
                m2.desc = use_spec
            }
            
            let m3 = BaseTableViewModel()
            m3.name = "规格"
            if let use_unit  = json["use_unit"].string {
                m3.desc = use_unit
            }
            
            let list = BaseTableViewModelList()
            list.listName = ""
            list.list = [m0,m1,m2,m3]
            
            self.listArray = [list]

        }
        
        self.tableView.reloadData()
    }
    
    //报表参数
    func makeReportModel() {
        
        title = "报表参数"
        if isProject == true {
            
            let m0 = BaseTableViewModel()
            m0.name = "报表系数"
            if let report_ratio = json["report_ratio"].string {
                m0.desc = report_ratio
            }
            
            let m1 = BaseTableViewModel()
            m1.name = "手工费计算方式"
            if let manual_type = json["manual_type"].string {
                m1.desc = manual_type
            }
            
            let m2 = BaseTableViewModel()
            m2.name = "手工费"
            if let retail_price = json["manual_fee"].string {
                m2.desc = retail_price
            }
            
            let list = BaseTableViewModelList()
            list.listName = ""
            list.list = [m0,m1,m2]
            
            self.listArray = [list]
            
        }
        else {
            let m0 = BaseTableViewModel()
            m0.name = "报表系数"
            if let volume = json["volume"].string {
                m0.desc = volume
            }
            
            let m1 = BaseTableViewModel()
            m1.name = "货品分类"
            if let item_class = json["item_class"].string {
                m1.desc = item_class
            }
            
            let list = BaseTableViewModelList()
            list.listName = ""
            list.list = [m0,m1]
            
            self.listArray = [list]
            
        }
        
        self.tableView.reloadData()
    }
    

    //销售权限
    func makeMarketModel() {
        
        title = "销售权限"
    
            let m0 = BaseTableViewModel()
            m0.name = "销售门店"
            if let orgs = json["org_list"].array {
                m0.desc = String(orgs.count) + "家"
                
                if orgs.count > 0 {
                    m0.hasList = true
                    
                    for org in orgs{
                        
                        let nextModel = BaseTableViewModel()
                        nextModel.name = org.string!
                        
                        m0.listData.append(nextModel)
                    }
                    
                }
            }
            
            let m1 = BaseTableViewModel()
            m1.name = "付费方式"
            
            var showAnother = false
            if let fee_type = json["fee_type"].array {
                fee_type.forEach({ (type) in
                    
                    m1.desc += type.string! + ","
                    
                    if type.string == "卡扣" { showAnother = true }
                })
                
                _ = m1.desc.removeCharsFromEnd(1)
            }
            
            if showAnother == false {
                
                let list = BaseTableViewModelList()
                list.listName = ""
                list.list = [m0,m1]
                
                self.listArray = [list]
                return
            }
            
            let m2 = BaseTableViewModel()
            m2.name = "随卡打折"
            if let card_discount = json["card_discount"].string {
                m2.desc = card_discount
            }
            
            let m3 = BaseTableViewModel()
            m3.name = "可用卡项"
        if let cardArr = json["vipcard_type"].array {
            
            m3.desc = String(cardArr.count) + "张"
            if cardArr.count > 0 {
                m3.hasList = true
                
                for card in cardArr{
                    
                    let nextModel = BaseTableViewModel()
                    nextModel.name = card.string!
                    
                    m3.listData.append(nextModel)
                }
            }
        }
        
        
            let list = BaseTableViewModelList()
            list.listName = ""
            list.list = [m0,m1,m2,m3]
            
            self.listArray = [list]
            
        
        
        self.tableView.reloadData()
    }
    
}
