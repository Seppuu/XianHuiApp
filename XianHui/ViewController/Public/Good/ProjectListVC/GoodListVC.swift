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
    
    var confirmTapHandler:((_ projectSelected:[Project],_ prodsSelected:[Production])->())?
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        
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
    
    func getLastBoughtProjectWith(_ json:[JSON]) -> [Project] {
        
        var list = [Project]()
        
        for p in json {
            
            let pro = Project()
            if let id = p["item_id"].int {
                pro.id = id
            }
            if let name = p["fullname"].string {
                pro.name = name
            }
            if let saledate = p["saledate"].string {
                pro.saledate = saledate
            }
            
            list.append(pro)
            
        }
        
        return list
    }
    
    
    func getLastBoughtProductionWith(_ json:[JSON]) -> [Production] {
        
        var list = [Production]()
        
        for p in json {
            
            let pro = Production()
            if let id = p["item_id"].int {
                pro.id = id
            }
            if let name = p["fullname"].string {
                pro.name = name
            }
            if let saledate = p["saledate"].string {
                pro.saledate = saledate
            }
            
            list.append(pro)
            
        }
        
        return list
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
                        goodCard.cardType = cardNo
                    }
                    if let cardPrice = card["price"].string {
                        goodCard.cardPrice = cardPrice
                    }
                    
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
                let index = listOfPro.index(of: $0)!
                let item = listOfPro.remove(at: index)
                
                listOfPro.insert(item, at: 0)
            }
            
        }
        
        //将所有已经选择的置顶.
        listOfPro.forEach{
            
            if $0.selected == true {
                let index = listOfPro.index(of: $0)!
                let item = listOfPro.remove(at: index)
                
                listOfPro.insert(item, at: 0)
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
            if let id   = p["item_id"].int {
                pro.id = id
            }
            
            if let cardList = p["card_list"].array {
                
                for card in cardList {
                    //有疗程卡
                    pro.hasCardList = true
                    
                    let goodCard = GoodCard()
                    
                    if let cardName = card["fullname"].string {
                        goodCard.cardName = cardName
                    }
                    if let times = card["times"].int {
                        goodCard.cardTimesLeft = times
                    }
                    
                    if let cardType = card["card_class"].string {
                        goodCard.cardType = cardType
                    }
                    if let cardNo = card["card_num"].string {
                        goodCard.cardType = cardNo
                    }
                    
                    if let cardPrice = card["price"].string {
                        goodCard.cardPrice = cardPrice
                    }
                    
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
                let index = listOfProd.index(of: $0)!
                let item = listOfProd.remove(at: index)
                
                listOfProd.insert(item, at: 0)
            }
            
        }
        
        //将所有已经选择的置顶.
        listOfProd.forEach{
            
            if $0.selected == true {
                let index = listOfProd.index(of: $0)!
                let item = listOfProd.remove(at: index)
                
                listOfProd.insert(item, at: 0)
            }
            
        }
        
        
        return listOfProd
    }

    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        let nib = UINib(nibName: typeCellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: typeCellId)
        
        let nib2 = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: cellId)
        
    }
    
    var segment: UISegmentedControl!
    
    func setNavBarItem() {
        
        let rightBar = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(GoodListVC.confirmTap))
        
        navigationItem.rightBarButtonItem = rightBar
        
        let leftBar = UIBarButtonItem(title: "撤销", style: .done, target: self, action: #selector(GoodListVC.cancelTap))
        
        navigationItem.leftBarButtonItem = leftBar
        
        segment = UISegmentedControl(items: ["项目","产品"])
        segment.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(GoodListVC.segmentVauleChanged(_:)), for: .valueChanged)
        
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
        
        segment.setTitle("项目(\(projectSelectCount))", forSegmentAt: 0)
        segment.setTitle("产品(\(productionSelectCount))", forSegmentAt: 1)
    }
    
    func segmentVauleChanged(_ sender:UISegmentedControl) {
        
        tableView.reloadData()
    }
    
    func confirmTap() {
         passData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelTap() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        self.confirmTapHandler?(proSelected,prodsSelected)
    }
    
    func toGoodRecordVC() {
        //去消费记录
        let vc = CustomerConsumeListVC()
        vc.title = "消费记录"
        vc.customer = customer
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var showDetail = false
    
    var detailCellRow:Int!
    
    var projectTapped:Project?
    
    func showDetailViewWithInTableView(_ row:Int,good:Project) {
        
        projectTapped = good
        
        let path = IndexPath(item: row + 1, section: 1)
        showDetail = true
        detailCellRow = row + 1
        tableView.insertRows(at: [path], with: .fade)
        
    }
    
    func hideDetailViewWithInTableView(_ row:Int,good:Project) {
        projectTapped = nil
        let path = IndexPath(item: detailCellRow, section: 1)
        showDetail = false
        
        tableView.deleteRows(at: [path], with: .fade)
        
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
       return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if showDetail == true && (indexPath as NSIndexPath).row == detailCellRow {
            
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let container = UIView(frame: CGRect(x: 0, y: 0, width:screenWidth, height: 42))
            let label = UILabel(frame: CGRect(x: 15, y: 0, width:200, height: 21))
            label.center.y = container.center.y
            label.text = "更多的消费记录"
            label.isUserInteractionEnabled = true
            label.textAlignment = .left
            label.textColor = UIColor ( red: 0.0, green: 0.5415, blue: 0.9962, alpha: 1.0 )
            label.font = UIFont.systemFont(ofSize: 14)
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: typeCellId, for: indexPath) as! typeCell
            if segment.selectedSegmentIndex == 0 {
                let good = projectsBought[(indexPath as NSIndexPath).row]
                cell.leftLabel.text = good.name
                cell.typeLabel.text = good.time
            }
            else {
                let good = prodsBought[(indexPath as NSIndexPath).row]
                cell.leftLabel.text = good.name
                cell.typeLabel.text = good.time
            }

            return cell
        }
        else {
            
            if showDetail == true && detailCellRow == (indexPath as NSIndexPath).row {
                
                //show detail cell
                let cellID = "cell"
                let cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
                
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
                var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? CheckBoxCell
                
                if cell == nil {
                    let nib = UINib(nibName: cellID, bundle: nil)
                    tableView.register(nib, forCellReuseIdentifier: cellID)
                    cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? CheckBoxCell
                }
                
                
                cell?.rightButtonTapHandler = {
                    
                }
                cell!.selectionStyle = .none
                var good:Good!
                if segment.selectedSegmentIndex == 0 {
                    good = projects[(indexPath as NSIndexPath).row]
                    
                    let project = projects[(indexPath as NSIndexPath).row]
                    
                    if project.hasCardList == true {
                        cell!.nameLabel.textColor = UIColor ( red: 0.0, green: 0.4868, blue: 0.9191, alpha: 1.0 )
                        cell!.rightButton.alpha = 1.0
                        
                        var times = 0
                        for card in project.cardList {
                            times += card.cardTimesLeft
                        }
                        let title = String(times) + "次"
                        cell!.rightButton.setTitle(title, for: UIControlState())
                    }
                    else {
                        cell!.nameLabel.textColor = UIColor.darkText
                        cell!.rightButton.alpha = 0.0
                    }
                    
                    
                }
                else {
                    
                    
                    good = prods[(indexPath as NSIndexPath).row]
                    
                    let prod = prods[(indexPath as NSIndexPath).row]
                    
                    if prod.hasCardList == true {
                        cell!.nameLabel.textColor = UIColor ( red: 0.0, green: 0.4868, blue: 0.9191, alpha: 1.0 )
                        cell!.rightButton.alpha = 1.0
                        
                        var times = 0
                        for card in prod.cardList {
                            times += card.cardTimesLeft
                        }
                        let title = String(times) + "次"
                        cell!.rightButton.setTitle(title, for: UIControlState())
                    }
                    else {
                        cell!.nameLabel.textColor = UIColor.darkText
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
                    let project = projects[(indexPath as NSIndexPath).row]
                    cell!.rightButtonTapHandler = {
                        
                        if project.hasCardList == false {return}
                        
                        if self.showDetail == false {
                            self.showDetailViewWithInTableView((indexPath as NSIndexPath).row, good: project)
                        }
                        else {
                            self.hideDetailViewWithInTableView((indexPath as NSIndexPath).row, good: project)
                        }
                        
                    }
                }
                else {
                    
                }
                
                
                
                return cell!
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if (indexPath as NSIndexPath).section == 1 {
            var good:Good!
            if segment.selectedSegmentIndex == 0 {
                good = projects[(indexPath as NSIndexPath).row]
            }
            else {
                good = prods[(indexPath as NSIndexPath).row]
            }
            
            guard let cell = tableView.cellForRow(at: indexPath) as? CheckBoxCell else {return}
            
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




