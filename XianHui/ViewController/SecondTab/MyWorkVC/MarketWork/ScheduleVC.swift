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
        
        view.backgroundColor = UIColor.white
        
        setTableView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        //64是navbar+status 高度 40是"pageMenu"高度
        tableView = UITableView(frame: CGRect(x: 0.0,y: 0.0, width: self.view.frame.width, height: self.view.frame.height - 64 - 40), style: .grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)

        topRefresh()
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(ScheduleVC.bottomRefresh))
        
    }
    
    var currentDate:String {
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayString = formatter.string(from: currentDate)
        
        return dayString
    }
    var nextDate = ""
    
    func getCustomListWith(_ date:String) {
        
        NetworkManager.sharedManager.getCustomerScheduleListWith(date, days: 3) { (success, json, error) in
            if success == true {
                
                
                let jsonArr = json!["rows"].array!
                
                if jsonArr.count > 0 {
                    //有数据
                    if let nextDate = json!["nextDate"].string {
                        self.nextDate = nextDate
                        
                        self.makeCustomerListWith(jsonArr)
                        self.tableView.reloadData()
                        self.tableView.mj_footer.endRefreshing()
                    }
                }
                else {
                    //已经没有数据
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                
                
                
            }
            else {
                //TODO:错误处理
            }
        }

        
    }
    
    var days = [String]()
    
    func makeCustomerListWith(_ dataArr:[JSON]) {
        
        var customers = [Customer]()
        
        var lastDate = ""
        
        //做一下倒序排列.原来的顺序是反的
        for data in dataArr.reversed() {
            
            let customer = Customer()
            if let id = data["customer_id"].int {
                customer.id = id
            }
            if let guid = data["guid"].string {
                customer.guid = guid
            }
            if let name = data["fullname"].string {
                customer.name = name
            }
            
            if let avatarUrlString = data["avator_url"].string {
                customer.avatarUrlString = avatarUrlString
            }
            
            if let projectTotal = data["project_total"].int {
                customer.projectTotal = projectTotal
            }
            if let scheduleTime = data["adate"].string {
                 customer.scheduleTime = scheduleTime
            }
            if let scheduleStatus = data["status"].string {
                customer.scheduleStatus = scheduleStatus
            }
            if let scheduleStartTime = data["start_time"].string {
                customer.scheduleStartTime = scheduleStartTime
            }
            //按照日期分组
            if customer.scheduleTime != lastDate {
                //add new arr
                lastDate = customer.scheduleTime
                
                days.append(lastDate)
            }
            
            customers.append(customer)
        }
        
        
        
        for day in days {
            
            var list = [Customer]()
            
            customers.forEach({ (customer) in
                
                if customer.scheduleTime == day {
                    list.append(customer)
                }
                
            })
            
            if list.count > 0 {
                self.listOfCustommerArr.append(list.reversed())
            }
            else {
                //上一页的日期,不需要,添加.
            }
            
            
        }
        
    }
    
    
    func topRefresh() {
        
         getCustomListWith(currentDate)
    }
    
    
    func bottomRefresh() {
        getCustomListWith(nextDate)
    }
    
    func avatarTap(_ sender:UITapGestureRecognizer) {
        
        let point = sender.location(in: tableView)
        
        let cellIndex = tableView.indexPathForRow(at: point)!
        
        let customer = listOfCustommerArr[(cellIndex as NSIndexPath).section][(cellIndex as NSIndexPath).row]
        
        let vc = CustomerProfileVC()
        vc.title = "详细资料"
        vc.customer = customer
        
        self.parentNavigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ScheduleVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfCustommerArr[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        view.backgroundColor = UIColor.ddViewBackGroundColor()
        let dayLabel = UILabel(frame: CGRect(x: 15, y: 5, width: 150, height: 20))
        dayLabel.font = UIFont.systemFont(ofSize: 12)
        dayLabel.textColor = UIColor.darkGray
        dayLabel.textAlignment = .left
        dayLabel.text = days[section]
        view.addSubview(dayLabel)
        
        let rightLabel = UILabel(frame: CGRect(x: screenWidth - 15 - 150, y: 5, width: 150, height: 20))
        rightLabel.font = UIFont.systemFont(ofSize: 12)
        rightLabel.textColor = UIColor.darkGray
        rightLabel.textAlignment = .right
        
        
        let customers = listOfCustommerArr[section]
        var projectNumber = 0
        
        customers.forEach { projectNumber += $0.projectTotal }
        
        
        rightLabel.text = "\(customers.count)位会员 \(projectNumber)个项目"
        view.addSubview(rightLabel)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    //当header 高度不起作用时,需要同时设置footer的高度.
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomerCell
        
        
        cell.avatarView.backgroundColor = UIColor ( red: 0.8849, green: 0.8849, blue: 0.8849, alpha: 1.0 )
        cell.avatarView.layer.cornerRadius = cell.avatarView.ddWidth/2
        cell.avatarView.layer.masksToBounds = true
        cell.happyLevel.textColor = UIColor ( red: 0.4377, green: 0.4377, blue: 0.4377, alpha: 1.0 )
        
        
        cell.avatarView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ScheduleVC.avatarTap(_:)))
        cell.avatarView.addGestureRecognizer(tap)
        
        let customer = listOfCustommerArr[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        
        cell.nameLabel.text = customer.name
        cell.happyLevel.text =  customer.scheduleStatus
        //开始时间+项目数
        cell.stageLabel.text = customer.scheduleStartTime + "(\(customer.projectTotal))"
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let customer = listOfCustommerArr[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]

        let vc = ProjectPlannedVC()
        vc.title = "预约信息"
        vc.customer = customer
        self.parentNavigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)

    }

}
