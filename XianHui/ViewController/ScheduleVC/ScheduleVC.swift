//
//  ScheduleVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/5.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftDate
import MJRefresh

class ScheduleVC: UIViewController {
    
    var tableView:UITableView!
    
    var parentVC:UIViewController?
    
    var parentNavigationController : UINavigationController?
    
    let cellId = "CustomerCell"
    
    var listOfCustommerArr = [[Customer]]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        setTableView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: CGRectMake(0.0,0.0, self.view.frame.width, self.view.frame.height - 64 - 10), style: .Grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(ScheduleVC.topRefresh))
        tableView.mj_header.beginRefreshing()
    }
    
    var currentDate:String {
        
        let currentDate = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayString = formatter.stringFromDate(currentDate)
        
        return dayString
    }
    var nextDate = ""
    
    func getCustomList() {
        
        NetworkManager.sharedManager.getCustomerScheduleListWith(currentDate, days: 3) { (success, json, error) in
            if success == true {
                
                self.nextDate = json!["nextDate"].string!
                let jsonArr = json!["rows"].array!
                self.listOfCustommerArr = self.makeCustomerListWith(jsonArr)
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
            }
            else {
                
            }
        }

        
    }
    
    var days = [String]()
    
    func makeCustomerListWith(dataArr:[JSON]) -> [[Customer]] {
        
        var customers = [Customer]()
        
        var lastDate = ""
        
        for data in dataArr {
            
            let customer = Customer()
            customer.id = data["customer_id"].int!
            customer.guid = data["guid"].string!
            customer.name = data["fullname"].string!
            customer.avatarUrlString = data["avator_url"].string!
            
            customer.scheduleTime = data["adate"].string!
            customer.scheduleStatus = data["status"].string!
            
            //按照日期分组
            if customer.scheduleTime != lastDate {
                //add new arr
                lastDate = customer.scheduleTime
                
                days.append(lastDate)
            }
            
            
            customers.append(customer)
            
        }
        
        var listArr = [[Customer]]()
        
        for day in days {
            
            var list = [Customer]()
            
            customers.forEach({ (customer) in
                
                if customer.scheduleTime == day {
                    list.append(customer)
                }
                
            })
            
            listArr.append(list)
        }
        
        
        return listArr
        
    }
    
    
    func topRefresh() {
        
         getCustomList()
    }
    
}

extension ScheduleVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return days.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfCustommerArr[section].count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        view.backgroundColor = UIColor.ddViewBackGroundColor()
        let dayLabel = UILabel(frame: CGRect(x: 15, y: 5, width: 30, height: 20))
        dayLabel.font = UIFont.systemFontOfSize(12)
        dayLabel.textColor = UIColor.darkGrayColor()
        dayLabel.textAlignment = .Center
        dayLabel.text = days[section]
        view.addSubview(dayLabel)
        
        let rightLabel = UILabel(frame: CGRect(x: screenWidth - 15 - 150, y: 5, width: 150, height: 20))
        rightLabel.font = UIFont.systemFontOfSize(12)
        rightLabel.textColor = UIColor.darkGrayColor()
        rightLabel.textAlignment = .Right
        rightLabel.text = "3位会员 6个项目"
        view.addSubview(rightLabel)
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    //当header 高度不起作用时,需要同时设置footer的高度.
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! CustomerCell
        
        
        cell.avatarView.backgroundColor = UIColor ( red: 0.8849, green: 0.8849, blue: 0.8849, alpha: 1.0 )
        cell.avatarView.layer.cornerRadius = cell.avatarView.ddWidth/2
        cell.avatarView.layer.masksToBounds = true
        cell.happyLevel.textColor = UIColor ( red: 0.4377, green: 0.4377, blue: 0.4377, alpha: 1.0 )
        cell.stageLabel.alpha = 0.0
        
        let customer = listOfCustommerArr[indexPath.section][indexPath.row]
        
        cell.nameLabel.text = customer.name
        cell.happyLevel.text =  customer.scheduleStatus
        
        
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //let customer = listOfCustommer[indexPath.row]
        let vc = CustomerProfileVC()
        //vc.customer = customer

        self.parentNavigationController?.pushViewController(vc, animated: true)

    }
    
    
    
}
