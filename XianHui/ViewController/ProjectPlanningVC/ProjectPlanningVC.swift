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

///项目计划
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
        view.backgroundColor = UIColor.whiteColor()
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

                    let peojectJson = json!["project"]["list"].array!
                    self.projects = self.getListOfProjectWith(peojectJson)
                    self.bottomView.listOfProject = self.projects
                    self.bottomView.tableView.reloadData()
                }
                
                if let idArr = json!["product"]["selected"].arrayObject as? [Int] {
                    
                    self.productionPlannedId = idArr
   
                    let productJson = json!["product"]["list"].array!
                    self.prods = self.getListOfProdWith(productJson)
                    self.bottomView.listOfProd = self.prods
                    self.bottomView.tableView.reloadData()
                }
            }
            else {
                
            }
        }
        
    }
    
    func getListOfProjectWith(json:[JSON]) -> [Project] {
        
        var listOfPro = [Project]()
        
        for p in json {
            
            let pro = Project()
            pro.name = p["fullname"].string!
            pro.id   = p["item_id"].int!
            
            if let cardList = p["card_list"].array {
                
                if cardList.count > 0 {
                    //有疗程卡
                    pro.hasCardList = true
                    
                    pro.cardName      = cardList[0]["fullname"].string!
                    pro.cardTimesLeft = cardList[0]["times"].int!
                    pro.cardType      = cardList[0]["card_class"].string!
                    pro.cardNo        = cardList[0]["card_num"].string!
                    pro.cardPrice     = cardList[0]["price"].string!
                }
                else  {
                    //无疗程卡
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
    
    func getListOfProdWith(json:[JSON]) -> [Production] {
        
        var listOfProd = [Production]()
        
        for p in json {
            
            let pro = Production()
            pro.name = p["fullname"].string!
            pro.id   = p["item_id"].int!
            
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
            let vc = ProjectListVC()
            vc.customer = self.customer
            vc.projectsPreSelected = self.bottomView.listOfProject
            vc.prodsPreSelected    = self.bottomView.listOfProd
            let nav = UINavigationController(rootViewController: vc)
            
            self.presentViewController(nav, animated: true, completion: nil)
            
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
    
    
    func saveGoodListSelectedInBack(goodIdList:String,projectsSelected:[Project],prodsSelected:[Production]) {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = .Text
        hud.labelText = "保存中..."
        
        NetworkManager.sharedManager.saveGoodPlanWith(customer.id, ids: goodIdList) { (success, json, error) in
            
            if success == true {
                hud.labelText = "保存成功!"
                hud.hide(true)
                
                self.bottomView.listOfProject = projectsSelected
                self.bottomView.listOfProd = prodsSelected
                self.bottomView.tableView.reloadData()
                
                self.saveGoodListCompletion?()
            }
            else {
                
            }
            
        }
        
    }
    

}


