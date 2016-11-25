//
//  CustomerConsumeListVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/6.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh
import DZNEmptyDataSet

//顾客消费记录列表(分页)
class CustomerConsumeListVC: UIViewController,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var tableView:UITableView!

    var customer:Customer!
    
    var goodListArray = [[Good]]()
    
    var dateList = [String]()
    
    var pageSize = 10
    
    var pageNumber = 1
    
    var totalPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func getListWith(_ id:Int,pageSize:Int,pageNumber:Int) {
        
        NetworkManager.sharedManager.getCustomerConsumeListWith(id, pageSize: pageSize, pageNumber: pageNumber) { (success, json, error) in
            
            if success == true {
                let jsonData = json!["rows"].array!
                
                if jsonData.count == 0 {

                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                else {
                    if let totalPage = json!["totalPage"].int {
                        self.totalPage = totalPage
                        self.goodListArray += self.makeGoodListWith(jsonData)
                        self.pageNumber += 1
                        self.tableView.reloadData()
                        self.tableView.mj_footer.endRefreshing()
                    }
                    
                }
                
                
            }
            else {
                
            }
            
        }
    }
    
    var data = [JSON]()
    
    func makeGoodListWith(_ jsons:[JSON]) -> [[Good]] {
        
        for json in jsons {
            
            data.append(json)
            
        }
        
        var list = [Good]()
        
        for g in data {
            
            let good = Good()
            if let name = g["fullname"].string {
                good.name  = name
            }
            if let id   = g["item_id"].int {
                good.id = id
            }
            if let amount = g["amount"].string {
                good.amount = amount
            }
            if let saledate = g["saledate"].string {
                good.saledate = saledate
            }
            
            list.append(good)
        }
        
        var lastDate = ""
        
        list.forEach {
            
            if $0.saledate != lastDate {
                lastDate = $0.saledate
                
                dateList.append(lastDate)
            }
        }
        
        var listArray = [[Good]]()
        
        for date in dateList {
            
            var aList = [Good]()
            
            list.forEach{
                if $0.saledate == date {
                    aList.append($0)
                }
            }
            
            listArray.append(aList)
        }
        
        return listArray
    }
    
    let cellId = "typeCell"
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        view.addSubview(tableView)
        
        let nib  = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            
            self.getListWith(self.customer.id, pageSize: self.pageSize, pageNumber: self.pageNumber)
            
        })
        
        tableView.mj_footer.beginRefreshing()
        
        self.tableView.mj_footer.endRefreshingCompletionBlock = {
            self.hasLoadData = true
        }
        
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "无历史记录"
        
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

extension CustomerConsumeListVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dateList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodListArray[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateList[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! typeCell
        cell.selectionStyle = .none
        
        let good = goodListArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        
        cell.leftLabel.text = good.name
        cell.typeLabel.text = good.amount + "元"
        
        return cell
        
    }
   
}






