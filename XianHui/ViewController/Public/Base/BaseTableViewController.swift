//
//  BaseProfileViewController.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/30.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON
import DZNEmptyDataSet

class BaseTableViewModel: NSObject {
    
    var name = ""
    var desc = ""
    var id:Int?
    var num = ""
    //有列表 需要展开
    var hasList = false
    
    var listData = [BaseTableViewModel]()
}

class BaseTableViewModelList:NSObject {
    
    var listName = ""
    var list = [BaseTableViewModel]()
}

typealias CellForRowHandler = ((UITableView,IndexPath) -> (UITableViewCell))


typealias CellSelectedRowHandler = ((UITableView,IndexPath) -> ())

class BaseTableViewController: UIViewController,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var tableView:UITableView!
    
    let typeCellId = "typeCell"
    
    var dataID:Int!
    
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
        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
    }
    
    
    
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "暂无数据"
        
        let attrString = NSAttributedString(string: text)
        
        return attrString
    }
    
    var hasLoadData = false {
        didSet {
            if hasLoadData == true {
                self.tableView.reloadData()
            }
            
        }
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return hasLoadData
    }
    
    
}

extension BaseTableViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray[section].list.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listArray[section].listName
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let baseModel = listArray[(indexPath as NSIndexPath).section].list[(indexPath as NSIndexPath).row]
        
        let cellId = "typeCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? typeCell
        cell?.selectionStyle = .none
        if cell == nil {
            let nib = UINib(nibName: cellId, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: cellId)
            cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? typeCell
        }
        
        cell?.leftLabel.text = baseModel.name
        cell?.typeLabel.text = baseModel.desc
        cell?.typeLabel.textAlignment = .right
        
        
        
        if baseModel.hasList == true {
            cell?.accessoryView = UIImageView.xhAccessoryView()
        }
        else {
            cell?.accessoryView = UIImageView.xhAccessoryViewClear()
        }
        
        return cell!
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        let baseModel = listArray[(indexPath as NSIndexPath).section].list[(indexPath as NSIndexPath).row]
        
        if baseModel.hasList == true {
            let vc = BaseTableViewController()
            let listArr = BaseTableViewModelList()
            listArr.listName = ""
            listArr.list = baseModel.listData
            vc.listArray = [listArr]
            vc.title = baseModel.name
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            return
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if hasLoadData == false {
            hasLoadData = true
        }
        
    }
}













