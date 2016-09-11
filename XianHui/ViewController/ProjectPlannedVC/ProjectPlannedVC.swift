//
//  ProjectPlannedVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/5.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProjectPlannedVC: UIViewController {
    
    var customer:Customer!
    
    var datasArray = [[Project]]()
    
    var days = [String]()

    var bottomView:ChattingTableView!
    
    var allPlan = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        getListData()
        setTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        bottomView = ChattingTableView(frame:view.bounds)
        bottomView.listOfProject = datasArray
        bottomView.days = days
        
        view.addSubview(bottomView)

        
    }
    
    func getListData() {
        
        let dateString = allPlan == true ? "" : customer.scheduleTime
        
        NetworkManager.sharedManager.getCustomerSchedulesUrlWith(customer.id,date:dateString) { (success, json, error) in
            
            if success == true {
                
                if let dataArr = json!.array {
                    self.datasArray = self.getListOfProjectPlannedWith(dataArr)
                    self.bottomView.listOfProject = self.datasArray
                    self.bottomView.days = self.days
                    self.bottomView.tableView.reloadData()
                }
                else {
                    //TODO:无数据
                }
                
            }
            else {
                
            }
            
        }
    }
    
    func getListOfProjectPlannedWith(json:[JSON]) -> [[Project]] {
        
        var allProject = [Project]()
    
        //先改数组排序
        for data in json.reverse() {
            
            let p = Project()
            p.name = data["fullname"].string!
            p.planType = .customer
            p.addDate = data["adate"].string!
            
            let startTime = data["start_time"].string!
            let endTime = data["end_time"].string!
            
            
            p.time = "\(startTime) - \(endTime)"
            
            allProject.append(p)
            
        }
        
        var lastDate = ""
        
        for p in allProject {
            
            if lastDate != p.addDate {
                lastDate = p.addDate
                days.append(p.addDate)
            }
            
        }
        
        
        var listArray = [[Project]]()
        
        //根据日期重新分组
        for day in days {
            
            var list = [Project]()
            
            allProject.forEach({
                
                if $0.addDate == day {
                    list.append($0)
                }
            })
            listArray.append(list.reverse())
        }
        
        return listArray
    }
}



















