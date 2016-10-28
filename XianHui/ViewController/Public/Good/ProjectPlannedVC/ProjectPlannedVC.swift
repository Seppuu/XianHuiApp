//
//  ProjectPlannedVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/5.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

class ProjectPlannedVC: UIViewController {
    
    var customer:Customer!
    
    var datasArray = [[Project]]()
    
    var days = [String]()

    var bottomView:ChattingTableView!
    
    var allPlan = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
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
                    //预约完成.提示一些信息
                    self.showSomeMessageAndButtons()
                }
                
            }
            else {
                
            }
            
        }
    }
    
    
    func showSomeMessageAndButtons() {
        
        let topContainer = UIView()
        topContainer.backgroundColor = UIColor.clear
        view.addSubview(topContainer)
        topContainer.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo((view.ddHeight) / 2)
            make.centerY.equalTo(view).offset(32)
        }
        
        
        let topLabel = UILabel()
        topLabel.text = "该顾客已经结单."
        topLabel.textColor = UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25 )
        topLabel.font = UIFont.systemFont(ofSize: 14)
        topLabel.textAlignment = .center
        topContainer.addSubview(topLabel)
        
        topLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topContainer)
            make.centerX.equalTo(topContainer)
            make.left.right.equalTo(topContainer)
            make.height.equalTo(21)
        }
        
        
        let topButton = UIButton()
        topButton.setTitle("添加新计划", for: UIControlState())
        topButton.setTitleColor(UIColor ( red: 0.5, green: 0.4201, blue: 0.3681, alpha: 1.0 ), for: UIControlState())
        topButton.addTarget(self, action: #selector(ProjectPlannedVC.addNewPlan), for: .touchUpInside)
        topButton.layer.cornerRadius = 5.0
        topButton.layer.borderWidth = 1.0
        topButton.layer.borderColor = UIColor ( red: 0.5, green: 0.4201, blue: 0.3681, alpha: 1.0 ).cgColor
        topContainer.addSubview(topButton)
        
        topButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(topContainer)
            make.top.equalTo(topLabel.snp.bottom).offset(50)
            make.left.equalTo(topContainer).offset(50)
            make.right.equalTo(topContainer).offset(-50)
            make.height.equalTo(44)
        }
        
        let secondButton = UIButton()
        secondButton.setTitle("查看消费记录", for: UIControlState())
        secondButton.setTitleColor(UIColor ( red: 0.5, green: 0.4201, blue: 0.3681, alpha: 1.0 ), for: UIControlState())
        secondButton.addTarget(self, action: #selector(ProjectPlannedVC.pushToConsumeListView), for: .touchUpInside)
        secondButton.layer.cornerRadius = 5.0
        secondButton.layer.borderWidth = 1.0
        secondButton.layer.borderColor = UIColor ( red: 0.5, green: 0.4201, blue: 0.3681, alpha: 1.0 ).cgColor
        topContainer.addSubview(secondButton)
        
        secondButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(topContainer)
            make.top.equalTo(topButton.snp.bottom).offset(20)
            make.left.equalTo(topContainer).offset(50)
            make.right.equalTo(topContainer).offset(-50)
            make.height.equalTo(44)
        }
    }
    
    
    func addNewPlan() {
        
        let vc = ProjectPlanningVC()
        vc.customer = customer
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func pushToConsumeListView() {
        
        let vc = CustomerConsumeListVC()
        vc.title = "消费记录"
        vc.customer = customer
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getListOfProjectPlannedWith(_ json:[JSON]) -> [[Project]] {
        
        var allProject = [Project]()
    
        //先改数组排序
        for data in json.reversed() {
            
            let p = Project()
            if let name = data["fullname"].string {
                p.name = name
            }
            p.planType = .customer
            if let addDate = data["adate"].string {
                p.addDate = addDate
            }
            
            if let startTime = data["start_time"].string {
                
                if let endTime = data["end_time"].string {
                   p.time = "\(startTime) - \(endTime)"
                }
            }
            
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
            listArray.append(list.reversed())
        }
        
        return listArray
    }
}




