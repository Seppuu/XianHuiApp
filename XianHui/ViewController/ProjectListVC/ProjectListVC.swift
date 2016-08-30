//
//  ProjectListVC.swift
//  XianHui
//
//  Created by jidanyu on 16/8/23.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class ProjectListVC: BaseViewController {

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
    
    
    var confirmTapHandler:((projectSelected:[Project],prodsSelected:[Production])->())?
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        
        setNavBarItem()
        projects = getListOfProject()
        prods = getListOfProd()
        getGoodsLastBought()
        setTableView()
    }
    
    func getGoodsLastBought() {
    
        let pro0 = Project()
        pro0.name = "天地藏浴"
        pro0.time = "16.07.02"
        
        let pro1 = Project()
        pro1.name = "天地藏浴加强版"
        pro1.time = "16.07.05"
        
        let prod0 = Production()
        prod0.name = "牛樟芝"
        prod0.time = "16.04.08  "
        
        projectsBought = [pro0,pro1]
        prodsBought = [prod0]

        
    }
    
    func getListOfProject() -> [Project] {
        
        let listOfName = [
            "天地藏浴",
            "炸猪排",
            "日式天地藏浴",
            "泰式天地藏浴",
            "家康麻薯",
            "定海神针",
            "源氏物语",
            "赤城加贺",
            "舰队收藏",
            "山本五十六"
        ]
        
        var listOfPro = [Project]()
        
        for name in listOfName {
            let pro = Project()
            pro.name = name
            
            projectsPreSelected.forEach({ (projectPreSelected) in
                
                if name == projectPreSelected.name {
                    pro.selected = true
                }
            })
            
            
            listOfPro.append(pro)
        }
        
        
        return listOfPro
    }
    
    func getListOfProd() -> [Production] {
        
        let listOfName = [
            "牛樟芝",
            "益畅菌"
        ]
        
        var prods = [Production]()
        
        for name in listOfName {
            let pro = Production()
            pro.name = name
            
            prodsPreSelected.forEach({ (projectPreSelected) in
                
                if name == projectPreSelected.name {
                    pro.selected = true
                }
            })
            
            
            prods.append(pro)
        }
        
        
        return prods
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
        
        let rightBar = UIBarButtonItem(title: "确定", style: .Done, target: self, action: #selector(ProjectListVC.confirmTap))
        
        navigationItem.rightBarButtonItem = rightBar
        
        let leftBar = UIBarButtonItem(title: "撤销", style: .Done, target: self, action: #selector(ProjectListVC.cancelTap))
        
        navigationItem.leftBarButtonItem = leftBar
        
        segment = UISegmentedControl(items: ["项目(10)","产品(2)"])
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(ProjectListVC.segmentVauleChanged(_:)), forControlEvents: .ValueChanged)
        
        navigationItem.titleView = segment
        
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
        
        let path = NSIndexPath(forRow: 0, inSection: 1)
        tableView.scrollToRowAtIndexPath(path, atScrollPosition: .Top, animated: false)
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
    }
    
    var showDetail = false
    
    var detailCellRow:Int!
    
    func showDetailViewWithInTableView(row:Int,good:Good) {
        
        let path = NSIndexPath(forItem: row + 1, inSection: 1)
        showDetail = true
        detailCellRow = row + 1
        tableView.insertRowsAtIndexPaths([path], withRowAnimation: .Fade)
        
    }
    
    func hideDetailViewWithInTableView(row:Int,good:Good) {
        
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

extension ProjectListVC:UITableViewDelegate,UITableViewDataSource {
    
    
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
            return 80
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
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ProjectListVC.toGoodRecordVC))
            label.addGestureRecognizer(tap)
            
            container.addSubview(label)
            return container
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
            
            if showDetail == true && detailCellRow == indexPath.row && segment.selectedSegmentIndex == 0 {
                
                //show detail cell
                let cellID = "cell"
                let cell = UITableViewCell(style: .Default, reuseIdentifier: cellID)
                
                let detaileView = GoodDetailView.instanceFromNib()
                detaileView.frame = cell.bounds
                cell.contentView.addSubview(detaileView)
                
                return cell
                
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! GoodCell
                var good:Good!
                if segment.selectedSegmentIndex == 0 {
                    good = projects[indexPath.row]
                }
                else {
                    good = prods[indexPath.row]
                }
                
                
                if good.selected == false {
                    cell.accessoryType = .None
                }
                else {
                    cell.accessoryType = .Checkmark
                }
                
                cell.nameLabel.text = good.name
                
                if (good.cardType == .groupCard) {
                    cell.cardTypeImageView.backgroundColor = UIColor ( red: 1.0, green: 0.5808, blue: 0.5726, alpha: 1.0 )
                }
                else {
                    cell.cardTypeImageView.backgroundColor = UIColor ( red: 0.6638, green: 0.9043, blue: 0.9901, alpha: 1.0 )
                }
                
                
                if good.type == .project {
                    
                    cell.showDetailHandler = {
                        
                        if self.showDetail == false {
                            self.showDetailViewWithInTableView(indexPath.row, good: good)
                        }
                        else {
                            self.hideDetailViewWithInTableView(indexPath.row, good: good)
                        }
                        
                    }
                }
                else {
                    
                }
                
                return cell
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
            
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if good.selected == false {
                
                cell?.accessoryType = .Checkmark
                good.selected = true
                
            }
            else {
                cell?.accessoryType = .None
                good.selected = false
            }
        }
        else {
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}




