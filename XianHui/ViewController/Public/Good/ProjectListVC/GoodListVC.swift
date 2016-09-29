//
//  ProjectListVC.swift
//  XianHui
//
//  Created by jidanyu on 16/8/23.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

//所有的产品和项目列表
class GoodListVC: BaseViewController {

    var tableView:UITableView!
    
    var goodsLastBought = [Good]()
    
    var projectsBought = [Project]()
    
    var prodsBought = [Production]()
    
    var projects = [Project]()
    
    var projectsPreSelected = [Project]()
    
    var prods = [Production]()
    
    var prodsPreSelected = [Production]()
    
    var typeCellId = "typeCell"
    
    let cellId = "GoodCell"
    
    var customer:Customer!
    
    var confirmTapHandler:((projectSelected:[Project],prodsSelected:[Production])->())?
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        
        setNavBarItem()
        
        getGoodList()
        
        setTableView()
    }
    
    func getGoodList() {
        
        NetworkManager.sharedManager.getGoodPlanListWith(customer.id) { (success, json, error) in
            
            if success == true {
                let peojectJson = json!["project"]["list"].array!
                self.projects = self.getListOfProjectWith(peojectJson)
                
                let productJson = json!["product"]["list"].array!
                self.prods = self.getListOfProdWith(productJson)
                
                let projectConsumeJson = json!["project"]["consume"].array!
                self.projectsBought = self.getLastBoughtProjectWith(projectConsumeJson)
                
                let productionConsumeJson = json!["product"]["consume"].array!
                self.prodsBought = self.getLastBoughtProductionWith(productionConsumeJson)
                
                self.updateSegmemt()
                
                self.tableView.reloadData()
                
            }
            else {
                
            }
        }
        
    }
    
    func getLastBoughtProjectWith(json:[JSON]) -> [Project] {
        
        var list = [Project]()
        
        for p in json {
            
            let pro = Project()
            pro.id = p["item_id"].int!
            pro.name = p["fullname"].string!
            pro.saledate = p["saledate"].string!
            
            list.append(pro)
            
        }
        
        return list
    }
    
    
    func getLastBoughtProductionWith(json:[JSON]) -> [Production] {
        
        var list = [Production]()
        
        for p in json {
            
            let pro = Production()
            pro.id = p["item_id"].int!
            pro.name = p["fullname"].string!
            pro.saledate = p["saledate"].string!
            
            list.append(pro)
            
        }
        
        return list
    }
    

    func getListOfProjectWith(json:[JSON]) -> [Project] {
        
        var listOfPro = [Project]()
        
        for p in json {
            
            let pro = Project()
            pro.name = p["fullname"].string!
            pro.id   = p["item_id"].int!
            
            if let cardList = p["card_list"].array {
                
                for card in cardList {
                    //有疗程卡
                    pro.hasCardList = true
                    
                    let goodCard = GoodCard()
                    
                    goodCard.cardName      = card["fullname"].string!
                    if let times = card["times"].int {
                        goodCard.cardTimesLeft = times
                    }
                    
                    goodCard.cardType      = card["card_class"].string!
                    goodCard.cardNo        = card["card_num"].string!
                    goodCard.cardPrice     = card["price"].string!
                    
                    
                    pro.cardList.append(goodCard)
                }
                
                
            }
            
            projectsPreSelected.forEach({ (projectPreSelected) in
                
                if pro.name == projectPreSelected.name {
                    pro.selected = true
                }
            })
            
            listOfPro.append(pro)
        }
        
        //将有疗程卡的项目置顶
        listOfPro.forEach{
            
            if $0.hasCardList == true {
                let index = listOfPro.indexOf($0)!
                let item = listOfPro.removeAtIndex(index)
                
                listOfPro.insert(item, atIndex: 0)
            }
            
        }
        
        //将所有已经选择的置顶.
        listOfPro.forEach{
            
            if $0.selected == true {
                let index = listOfPro.indexOf($0)!
                let item = listOfPro.removeAtIndex(index)
                
                listOfPro.insert(item, atIndex: 0)
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
            
            if let cardList = p["card_list"].array {
                
                for card in cardList {
                    //有疗程卡
                    pro.hasCardList = true
                    
                    let goodCard = GoodCard()
                    
                    goodCard.cardName      = card["fullname"].string!
                    if let times = card["times"].int {
                        goodCard.cardTimesLeft = times
                    }
                    
                    goodCard.cardType      = card["card_class"].string!
                    goodCard.cardNo        = card["card_num"].string!
                    goodCard.cardPrice     = card["price"].string!
                    
                    
                    pro.cardList.append(goodCard)
                }
                
                
            }
            
            prodsPreSelected.forEach({ (projectPreSelected) in
                
                if pro.name == projectPreSelected.name {
                    pro.selected = true
                }
            })
            
            listOfProd.append(pro)
        }
        
        //将有疗程卡的项目置顶
        listOfProd.forEach{
            
            if $0.hasCardList == true {
                let index = listOfProd.indexOf($0)!
                let item = listOfProd.removeAtIndex(index)
                
                listOfProd.insert(item, atIndex: 0)
            }
            
        }
        
        //将所有已经选择的置顶.
        listOfProd.forEach{
            
            if $0.selected == true {
                let index = listOfProd.indexOf($0)!
                let item = listOfProd.removeAtIndex(index)
                
                listOfProd.insert(item, atIndex: 0)
            }
            
        }
        
        
        return listOfProd
    }

    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        let nib = UINib(nibName: typeCellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: typeCellId)
        
        let nib2 = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib2, forCellReuseIdentifier: cellId)
        
    }
    
    var segment: UISegmentedControl!
    
    func setNavBarItem() {
        
        let rightBar = UIBarButtonItem(title: "确定", style: .Done, target: self, action: #selector(GoodListVC.confirmTap))
        
        navigationItem.rightBarButtonItem = rightBar
        
        let leftBar = UIBarButtonItem(title: "撤销", style: .Done, target: self, action: #selector(GoodListVC.cancelTap))
        
        navigationItem.leftBarButtonItem = leftBar
        
        segment = UISegmentedControl(items: ["项目","产品"])
        segment.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(GoodListVC.segmentVauleChanged(_:)), forControlEvents: .ValueChanged)
        
        navigationItem.titleView = segment
        
        
    }
    
    func updateSegmemt() {
        var projectSelectCount = 0
        var productionSelectCount = 0
        
        projects.forEach({
            if  $0.selected == true {
                
                projectSelectCount += 1
            }
        })
        
        prods.forEach({
            if  $0.selected == true {
                
                productionSelectCount += 1
            }
        })
        
        segment.setTitle("项目(\(projectSelectCount))", forSegmentAtIndex: 0)
        segment.setTitle("产品(\(productionSelectCount))", forSegmentAtIndex: 1)
    }
    
    func segmentVauleChanged(sender:UISegmentedControl) {
        
        tableView.reloadData()
    }
    
    func confirmTap() {
         passData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelTap() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        let path = NSIndexPath(forRow: 0, inSection: 1)
//        tableView.scrollToRowAtIndexPath(path, atScrollPosition: .Top, animated: false)
    }
    
    func passData() {
        
        var proSelected = [Project]()
        for pro in self.projects {
            
            if pro.selected == true {
                proSelected.append(pro)
            }
            
        }
        
        var prodsSelected = [Production]()
        for prod in self.prods {
            
            if prod.selected == true {
                prodsSelected.append(prod)
            }
            
        }
        
        self.confirmTapHandler?(projectSelected:proSelected,prodsSelected:prodsSelected)
    }
    
    func toGoodRecordVC() {
        //TOOD:去消费记录
        let vc = CustomerConsumeListVC()
        vc.title = "消费记录"
        vc.customer = customer
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var showDetail = false
    
    var detailCellRow:Int!
    
    var projectTapped:Project?
    
    func showDetailViewWithInTableView(row:Int,good:Project) {
        
        projectTapped = good
        
        let path = NSIndexPath(forItem: row + 1, inSection: 1)
        showDetail = true
        detailCellRow = row + 1
        tableView.insertRowsAtIndexPaths([path], withRowAnimation: .Fade)
        
    }
    
    func hideDetailViewWithInTableView(row:Int,good:Project) {
        projectTapped = nil
        let path = NSIndexPath(forItem: detailCellRow, inSection: 1)
        showDetail = false
        
        tableView.deleteRowsAtIndexPaths([path], withRowAnimation: .Fade)
        
        if detailCellRow == row + 1 {
            detailCellRow = nil
        }
        else {
            //show detail in row + 1
            showDetailViewWithInTableView(row, good: good)
        }
        
    }
    
   
    
}

extension GoodListVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
       return 2
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return segment.selectedSegmentIndex == 0 ? projectsBought.count : prodsBought.count
        }
        else {
            if segment.selectedSegmentIndex == 0 {
                return showDetail == true ? projects.count + 1 : projects.count
            }
            else {
                return prods.count
            }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if showDetail == true && indexPath.row == detailCellRow {
            
            if segment.selectedSegmentIndex == 0 {
                //项目
                let pro = projects[detailCellRow - 1]
                
                return 36 + CGFloat(pro.cardList.count) * 44
            }
            else {
                //产品
                let prod = prods[detailCellRow - 1]
                
                return 36 + CGFloat(prod.cardList.count) * 44

            }
        }
        else {
            return 44
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            if segment.selectedSegmentIndex == 0 {
                return projectsBought.count > 0 ? 30 + 12 : 1
            }
            else {
                return prodsBought.count > 0 ? 30 + 12 : 1
            }
        }
        else {
            return 20
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let container = UIView(frame: CGRect(x: 0, y: 0, width:screenWidth, height: 42))
            let label = UILabel(frame: CGRect(x: 15, y: 0, width:200, height: 21))
            label.center.y = container.center.y
            label.text = "更多的消费记录"
            label.userInteractionEnabled = true
            label.textAlignment = .Left
            label.textColor = UIColor ( red: 0.0, green: 0.5415, blue: 0.9962, alpha: 1.0 )
            label.font = UIFont.systemFontOfSize(14)
            label.backgroundColor = UIColor.ddViewBackGroundColor()
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(GoodListVC.toGoodRecordVC))
            label.addGestureRecognizer(tap)
            
            container.addSubview(label)
            
            
            if segment.selectedSegmentIndex == 0 {
                return projectsBought.count > 0 ? container : nil
            }
            else {
                return prodsBought.count > 0 ? container : nil
            }
        }
        else {

            return nil
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 {
            if (segment.selectedSegmentIndex == 0) {
                return "项目计划"
            }
            else {
                return "产品计划"
            }
        }
        else {
           return nil
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(typeCellId, forIndexPath: indexPath) as! typeCell
            if segment.selectedSegmentIndex == 0 {
                let good = projectsBought[indexPath.row]
                cell.leftLabel.text = good.name
                cell.typeLabel.text = good.time
            }
            else {
                let good = prodsBought[indexPath.row]
                cell.leftLabel.text = good.name
                cell.typeLabel.text = good.time
            }

            return cell
        }
        else {
            
            if showDetail == true && detailCellRow == indexPath.row {
                
                //show detail cell
                let cellID = "cell"
                let cell = UITableViewCell(style: .Default, reuseIdentifier: cellID)
                
                let detaileView = GoodDetailView.instanceFromNib()
                detaileView.frame = cell.bounds
                
                if segment.selectedSegmentIndex == 0  {
                    
                    let pro = projects[detailCellRow - 1]
                    detaileView.cardList = pro.cardList
                    
                }
                else {
                    let prod = prods[detailCellRow - 1]
                    detaileView.cardList = prod.cardList
                }
                
                cell.contentView.addSubview(detaileView)
                
                return cell
                
            }
            else {
                
                let cellID = "CheckBoxCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellID) as? CheckBoxCell
                
                if cell == nil {
                    let nib = UINib(nibName: cellID, bundle: nil)
                    tableView.registerNib(nib, forCellReuseIdentifier: cellID)
                    cell = tableView.dequeueReusableCellWithIdentifier(cellID) as? CheckBoxCell
                }
                
                
                cell?.rightButtonTapHandler = {
                    
                }
                cell!.selectionStyle = .None
                var good:Good!
                if segment.selectedSegmentIndex == 0 {
                    good = projects[indexPath.row]
                    
                    let project = projects[indexPath.row]
                    
                    if project.hasCardList == true {
                        cell!.nameLabel.textColor = UIColor ( red: 0.0, green: 0.4868, blue: 0.9191, alpha: 1.0 )
                        cell!.rightButton.alpha = 1.0
                        
                        var times = 0
                        for card in project.cardList {
                            times += card.cardTimesLeft
                        }
                        let title = String(times) + "次"
                        cell!.rightButton.setTitle(title, forState: .Normal)
                    }
                    else {
                        cell!.nameLabel.textColor = UIColor.darkTextColor()
                        cell!.rightButton.alpha = 0.0
                    }
                    
                    
                }
                else {
                    
                    
                    good = prods[indexPath.row]
                    
                    let prod = prods[indexPath.row]
                    
                    if prod.hasCardList == true {
                        cell!.nameLabel.textColor = UIColor ( red: 0.0, green: 0.4868, blue: 0.9191, alpha: 1.0 )
                        cell!.rightButton.alpha = 1.0
                        
                        var times = 0
                        for card in prod.cardList {
                            times += card.cardTimesLeft
                        }
                        let title = String(times) + "次"
                        cell!.rightButton.setTitle(title, forState: .Normal)
                    }
                    else {
                        cell!.nameLabel.textColor = UIColor.darkTextColor()
                        cell!.rightButton.alpha = 0.0
                    }
                }
                
                
                if good.selected == false {
                    cell!.isChecked = false
                }
                else {
                    cell!.isChecked = true
                }
                
                cell!.nameLabel.text = good.name

                
                if good.type == .project {
                    let project = projects[indexPath.row]
                    cell!.rightButtonTapHandler = {
                        
                        if project.hasCardList == false {return}
                        
                        if self.showDetail == false {
                            self.showDetailViewWithInTableView(indexPath.row, good: project)
                        }
                        else {
                            self.hideDetailViewWithInTableView(indexPath.row, good: project)
                        }
                        
                    }
                }
                else {
                    
                }
                
                
                
                return cell!
            }
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.section == 1 {
            var good:Good!
            if segment.selectedSegmentIndex == 0 {
                good = projects[indexPath.row]
            }
            else {
                good = prods[indexPath.row]
            }
            
            guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? CheckBoxCell else {return}
            
            if good.selected == false {
                
                cell.isChecked = true
                good.selected = true
                
            }
            else {
                cell.isChecked = false
                good.selected = false
            }
            
            //update segment title
            updateSegmemt()
            
            
        }
        else {
            
        }
        
        
    }
}




