//
//  ProjectPlanningVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/5.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

///添加项目计划和产品计划
class ProjectPlanningVC: UIViewController {

    var tableView:UITableView!
    
    let topCellId = "CustomerLargeCell"
    
    let typeCellId = "typeCell"
    
    //Data
    var customer:Customer!
    
    var saveGoodListCompletion:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "项目计划"
        view.backgroundColor = UIColor.white
        getGoodList()
        setTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    var projects = [Project]()
    
    var prods = [Production]()
    
    var projectPlannedId = [Int]()
    
    var productionPlannedId = [Int]()
    
    func getGoodList() {
        
        NetworkManager.sharedManager.getGoodPlanListWith(customer.id) { (success, json, error) in
            
            if success == true {
                
                if let idArr = json!["project"]["selected"].arrayObject as? [Int] {
                    
                    self.projectPlannedId = idArr

                    if let peojectJson = json!["project"]["list"].array {
                        self.projects = self.getListOfProjectWith(peojectJson)
                        self.bottomView.listOfProject = self.projects
                        self.bottomView.tableView.reloadData()
                    }
                    
                }
                
                if let idArr = json!["product"]["selected"].arrayObject as? [Int] {
                    
                    self.productionPlannedId = idArr
                    if let productJson = json!["product"]["list"].array {
                        
                        self.prods = self.getListOfProdWith(productJson)
                        self.bottomView.listOfProd = self.prods
                        self.bottomView.tableView.reloadData()
                    }
                    
                }
            }
            else {
                
            }
        }
        
    }
    
    func getListOfProjectWith(_ json:[JSON]) -> [Project] {
        
        var listOfPro = [Project]()
        
        for p in json {
            
            let pro = Project()
            if let name = p["fullname"].string {
                pro.name = name
            }
            if let id   = p["item_id"].int {
                pro.id = id
            }
            
            if let cardList = p["card_list"].array {
                
                for card in cardList {
                    //有疗程卡
                    pro.hasCardList = true
                    
                    let goodCard = GoodCard()
                    
                    if let cardName      = card["fullname"].string {
                        goodCard.cardName = cardName
                    }
                    if let times = card["times"].int {
                        goodCard.cardTimesLeft = times
                    }
                    
                    if let cardType = card["card_class"].string {
                        goodCard.cardType = cardType
                    }
                    if let cardNo = card["card_num"].string {
                        goodCard.cardNo = cardNo
                    }
                    if let cardPrice = card["price"].string {
                        goodCard.cardPrice = cardPrice
                    }
                    pro.cardList.append(goodCard)
                }
                
                
            }
            
            
            var planned = false
            
            projectPlannedId.forEach {
                
                if $0 == pro.id {
                    
                    planned = true
                }
                
            }
            
            if planned == true {
                
                listOfPro.append(pro)
            }
            else {
                
            }
        }
        
        
        return listOfPro
    }
    
    func getListOfProdWith(_ json:[JSON]) -> [Production] {
        
        var listOfProd = [Production]()
        
        for p in json {
            
            let pro = Production()
            if let name = p["fullname"].string {
                pro.name = name
            }
            if let id = p["item_id"].int {
                 pro.id = id
            }
            
            if let cardList = p["card_list"].array {
                
                for card in cardList {
                    //有疗程卡
                    pro.hasCardList = true
                    
                    let goodCard = GoodCard()
                    
                    if let cardName      = card["fullname"].string {
                        goodCard.cardName = cardName
                    }
                    if let times = card["times"].int {
                        goodCard.cardTimesLeft = times
                    }
                    
                    if let cardType = card["card_class"].string {
                        goodCard.cardType = cardType
                    }
                    if let cardNo = card["card_num"].string {
                        goodCard.cardNo = cardNo
                    }
                    if let cardPrice = card["price"].string {
                        goodCard.cardPrice = cardPrice
                    }
                    
                    pro.cardList.append(goodCard)
                }
                
                
            }
            
            var planned = false
            
            productionPlannedId.forEach {
                
                if $0 == pro.id {
                    
                    planned = true
                }
                
            }
            
            if planned == true {
                
                listOfProd.append(pro)
            }
            else {
               
            }
        }
        return listOfProd
    }
    
    var bottomView:PlanningTableView!
    
    func setTableView() {
        
        bottomView = PlanningTableView(frame:view.bounds)
        bottomView.addRowTapHandler = {
            let vc = GoodListVC()
            vc.customer = self.customer
            vc.projectsPreSelected = self.bottomView.listOfProject
            vc.prodsPreSelected    = self.bottomView.listOfProd
            let nav = UINavigationController(rootViewController: vc)
            
            self.present(nav, animated: true, completion: nil)
            
            vc.confirmTapHandler = {
                (projectsSelected,prodsSelected) in
                
                var goodIdList = ""
                
                projectsSelected.forEach{
                    goodIdList += String($0.id) + ","
                }
                
                prodsSelected.forEach{
                    goodIdList += String($0.id) + ","
                }
                
                self.saveGoodListSelectedInBack(goodIdList, projectsSelected: projectsSelected, prodsSelected: prodsSelected)
                
            }
        }
        
        view.addSubview(bottomView)
        
    }
    
    
    func saveGoodListSelectedInBack(_ goodIdList:String,projectsSelected:[Project],prodsSelected:[Production]) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.mode = .text
        hud?.labelText = "保存中..."
        
        NetworkManager.sharedManager.saveGoodPlanWith(customer.id, ids: goodIdList) { (success, json, error) in
            
            if success == true {
                hud!.labelText = "保存成功!"
                hud!.hide(true)
                
                self.bottomView.listOfProject = projectsSelected
                self.bottomView.listOfProd = prodsSelected
                self.bottomView.tableView.reloadData()
                let plannedNum = projectsSelected.count + prodsSelected.count
                NotificationCenter.default.post(name: CustomerPlannHasAddNoti, object: plannedNum)
                self.saveGoodListCompletion?()
            }
            else {
                
            }
            
        }
        
    }
    

}


