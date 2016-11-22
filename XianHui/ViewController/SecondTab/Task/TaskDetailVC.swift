//
//  TaskDetailVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/11/10.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON


class TaskDetailVC: UIViewController {
    
    var tableView:UITableView!
    
    var topCellId = "ConversationCell"
    
    var bottomCellId = "typeCell"
    
    
    var task = Task()
    
    var dataListArr = [[BaseTableViewModelList]]()
    
    var data:[BaseTableViewModelList] {
        if dataListArr.count == 0 {
            return [BaseTableViewModelList()]
        }
        else {
            let list = dataListArr[currentIndex]
            return list
        }

    }
    
    var segmentView = UISegmentedControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        getTaskDetail()
        getTaskDetailList()
        setNavBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: topCellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: topCellId)
        
        let nib1 = UINib(nibName: bottomCellId, bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: bottomCellId)
        
        view.addSubview(tableView)
        
    }
    
    func setNavBarItem() {
        let rightBarItem = UIBarButtonItem(title: "查看", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TaskDetailVC.toTaskCreate))
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func toTaskCreate() {
        let vc = CreateTaskVC()
        vc.title = "资料"
        vc.isShowDetail = true
        vc.task = task
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getTaskDetail() {
        
        NetworkManager.sharedManager.getTaskDetail(task.id) { (success, json, error) in
            
            if success == true {
                self.makeTaskDetail(json!)
            }
            else {
                
            }
        }
        
    }
    
    func getTaskDetailList() {
        
        
        NetworkManager.sharedManager.getTaskDetailList(task.id) { (success, json, error) in
            
            if success == true {
                self.makeListData(json!)
            }
            else {
                
            }
        }
    }
    
    func makeTaskDetail(_ data:JSON) {
        
     
        if let text = data["range"]["text"].string {
            task.range.text = text
            
        }
        
        if let value = data["range"]["value"].string {
            task.range.value = value
            
        }
        
        if let text = data["type"]["text"].string {
            task.type.text = text
            
        }
        
        
        if let value = data["type"]["value"].string {
            task.type.value = value
            
        }
        
        if let target = data["target"].int {
            task.target = String(target)
        }
        
        if let startDate = data["start_date"].string {
            
            task.startDateString = startDate
            
        }
        
        if let endDate = data["end_date"].string {
            task.endDateString = endDate
        }
        
        if let publishDate = data["publish_date"].string {
            task.publishDateString = publishDate
        }
        
        if let userList = data["user_list"].array {
            
            for user in userList {
                let u = User()
                if let name = user["text"].string {
                    u.displayName = name
                }
                
                if let id = user["value"].int {
                    u.id = id
                }
                
                task.members.append(u)
            }
            
            
        }
        
        if let remark = data["note"].string {
            task.remark = remark
        }
        
    }
    
    func makeListData(_ data:JSON) {
        
        self.dataListArr.removeAll()
        
        let listKeyArray = ["adviser_list","engineer_list","customer_list"]
        
        for key in listKeyArray {
            
            if let homeLists = data[key].array {
                let arr = BaseTableViewModelList()
                arr.listName = ""
                for data in homeLists {
                    
                    let dayModel = BaseTableViewModel()
                    
                    if let name = data["name"].string {
                        dayModel.name = name
                    }
                    
                    if let amount = data["amount"].int {
                        dayModel.desc = String(amount)
                    }
                    
                    if let listModels = data["detail"].array {
                        
                        for listModel in listModels {
                            
                            let model = BaseTableViewModel()
                            
                            if let name = listModel["name"].string {
                                model.name = name
                            }
                            
                            if let amount = listModel["amount"].int {
                                model.desc = String(amount)
                            }
                            
                            dayModel.hasList = true
                            dayModel.listData.append(model)
                        }
                    }
                    
                    
                    arr.list.append(dayModel)
                    
                }
                dataListArr.append([arr])
            }
            
        }
        
        tableView.reloadData()

    }
    
    var currentIndex = 0
    
    func segmentVauleChanged(_ sender:UISegmentedControl) {
        currentIndex = sender.selectedSegmentIndex
        tableView.reloadData()
    }
    

}

extension TaskDetailVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return data[section - 1].list.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 76
        }
        else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            
            let containr = UIView()
            containr.frame = CGRect(x: 0, y:0, width: screenWidth, height: 46)
            let segment = UISegmentedControl(items: ["顾问","技师","客人"])
            segment.frame = CGRect(x: 16, y: 8, width: screenWidth - 16 * 2, height: 46 - 8*2)
            segment.selectedSegmentIndex = currentIndex
            segment.addTarget(self, action: #selector(TaskDetailVC.segmentVauleChanged(_:)), for: .valueChanged)
            segment.layer.borderColor = UIColor.init(hexString: "236C51").cgColor
            segment.tintColor = UIColor.init(hexString: "236C51")
            containr.addSubview(segment)
            
            return containr
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        else {
            return 46
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: topCellId, for: indexPath) as! ConversationCell
            
            cell.layoutMargins = UIEdgeInsetsMake(0, 76, 0, 0)
            cell.avatarImageView.image = UIImage(named: "TaskIcon")
            cell.progressLabel.text = task.progressText
            cell.progressView.progress = task.progress
            
            let formmat = DateFormatter()
            formmat.dateFormat = "MM-dd"
            
            cell.nameLabel.text = "范围:" + task.range.text + "  类型:" + task.type.text + "  截止:" + formmat.string(from: task.endDate)
            
            if task.isUpdated == false {
                cell.unReadView.alpha = 0.0
            }
            else {
                cell.unReadView.alpha = 1.0
            }
            
            return cell
        }
        else {

            let baseModel = data[indexPath.section - 1].list[indexPath.row]
            
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
            cell?.typeLabel.textAlignment = .left
            
            if baseModel.hasList == true {
                
                cell?.accessoryView = UIImageView.xhAccessoryView()
            }
            else {
                
                cell?.accessoryView = UIImageView.xhAccessoryViewClear()
            }
            
            return cell!

            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
        }
        else {
            
            let baseModel = data[indexPath.section - 1].list[indexPath.row]
            
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
        
    }
    
}


