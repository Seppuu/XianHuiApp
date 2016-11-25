//
//  CustomerCardDetailVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/29.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh


class CustomerCardDetailVC: CustomerConsumeListVC {

    var cardNum = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    override func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        let nib  = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            
            self.getCardDetail()
            
        })
        
        tableView.mj_footer.beginRefreshing()
        
        self.tableView.mj_footer.endRefreshingCompletionBlock = {
            self.hasLoadData = true
        }
    }
    
    func getCardDetail() {
        
        NetworkManager.sharedManager.getCustomerCardDetailWith(cardNum) { (success, json, error) in
            
            if success == true {
                let jsonData = json!["rows"].array!
                
                self.goodListArray = self.makeGoodListWith(jsonData)
                
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_footer.isHidden = true
                
                
            }
            else {
                
            }
        }
        
    }
    
    
    
    override func makeGoodListWith(_ jsons:[JSON]) -> [[Good]] {
        
        var list = [Good]()
        
        for g in jsons {
            
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
            if let saledate = g["date"].string {
                good.saledate = saledate
            }
            
            if let cardNum = g["card_num"].string {
                good.cardNum = cardNum
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! typeCell
        cell.selectionStyle = .none
        
        let good = goodListArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        
        cell.leftLabel.text = good.name
        cell.typeLabel.text = good.amount + "元"
        
        if good.cardNum == "" {
            cell.accessoryView = UIImageView.xhAccessoryViewClear()
        }
        else {
            cell.accessoryView = UIImageView.xhAccessoryView()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let good = goodListArray[indexPath.section][indexPath.row]
        
        let vc = CustomerCardDetailVC()
        vc.cardNum = good.cardNum
        vc.title = good.name
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}

