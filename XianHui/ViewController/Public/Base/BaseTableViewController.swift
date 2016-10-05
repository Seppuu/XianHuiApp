//
//  BaseProfileViewController.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/30.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseTableViewModel: NSObject {
    
    var name = ""
    var desc = ""
    //有列表 需要展开
    var hasList = false
    
    var listData = [BaseTableViewModel]()
}

class BaseTableViewModelList:NSObject {
    
    var listName = ""
    var list = [BaseTableViewModel]()
}

typealias CellForRowHandler = ((UITableView,NSIndexPath) -> (UITableViewCell))


typealias CellSelectedRowHandler = ((UITableView,NSIndexPath) -> ())

class BaseTableViewController: UIViewController {
    
    var tableView:UITableView!
    
    
    let typeCellId = "typeCell"
    
    var dataID:Int!

//    var cellForRowHandler:CellForRowHandler?
//    
//    var cellSelectedHandler:CellSelectedRowHandler?
    
    var cellHeight:CGFloat = 44
    
    var listArray = [BaseTableViewModelList]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func setTableView() {
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
}

extension BaseTableViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return listArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray[section].list.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listArray[section].listName
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        let baseModel = listArray[indexPath.section].list[indexPath.row]
        
        let cellId = "typeCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? typeCell
        cell?.selectionStyle = .None
        if cell == nil {
            let nib = UINib(nibName: cellId, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: cellId)
            cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? typeCell
        }
        
        cell?.leftLabel.text = baseModel.name
        cell?.typeLabel.text = baseModel.desc
        cell?.typeLabel.textAlignment = .Right
        
        if baseModel.hasList == true {
            cell?.accessoryType = .DisclosureIndicator
        }
        else {
            cell?.accessoryType = .None
        }
        
        return cell!
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        

        let baseModel = listArray[indexPath.section].list[indexPath.row]
        
        if baseModel.hasList == true {
            let vc = BaseTableViewController()
            let listArr = BaseTableViewModelList()
            listArr.listName = ""
            listArr.list = baseModel.listData
            vc.listArray = [listArr]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            return
        }
    }
}













