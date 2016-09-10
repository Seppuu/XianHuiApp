//
//  DailyFormVC.swift
//  XianHui
//
//  Created by Seppuu on 16/8/12.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON

//日报表
class DailyFormVC: RadarChartVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDailyReportDataWith(date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    var date:String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        let date = NSDate()
        
        return formatter.stringFromDate(date)
    }
    
    
    var formToday:Form {
        if formList.count > 0 {
            return formList[0]
        }
        else {
            return Form()
        }
    }
    
    var formList = [Form]()
    
    func getDailyReportDataWith(date:String) {
        
        NetworkManager.sharedManager.getDailyReportDataWith(date) { (success, json, error) in
            
            if success == true {
                self.formList = self.makeFormDataWith(json!)
                
                self.numbers = self.setNumbers()
                self.names = ["现金","实操","产品","客流","客单价","人均项目数","项目均价"]
                
                self.form = self.formToday
                
                self.setChartData()
                self.tableView.reloadData()
                
            }
            else {
                
            }
        }
    }
    
    func makeFormDataWith(json:JSON) -> [Form] {
        
        var formList = [Form]()
        
        let daysData = json["weekly_daily"].array!
        //今天的数据是数组第一个.
        for dailyData in daysData {
            
            let form = Form()
            
            form.date = dailyData["date"].string!
            
            //雷达图单日分数
            form.cashPoint = dailyData["radar_data"]["today"]["cash"].int!
            form.projectPoint = dailyData["radar_data"]["today"]["project"].int!
            form.productionPoint = dailyData["radar_data"]["today"]["product"].int!
            form.customerCountPoint = dailyData["radar_data"]["today"]["customer"].int!
            form.employeePoint = dailyData["radar_data"]["today"]["employee"].int!
            
            //雷达图七日均价
            form.cashAvgPoint = dailyData["radar_data"]["avg"]["cash"].int!
            form.projectAvgPoint = dailyData["radar_data"]["avg"]["project"].int!
            form.productionAvgPoint = dailyData["radar_data"]["avg"]["product"].int!
            form.customerCountAvgPoint = dailyData["radar_data"]["avg"]["customer"].int!
            form.employeeAvgPoint = dailyData["radar_data"]["avg"]["employee"].int!
            
            //下方列表
            //现金
            form.cashList.amount = dailyData["cash_amount"].int!
            
            if let cashList = dailyData["cash_list"].array {
                
                for unit in cashList {
                    let p = Good()
                    p.name = unit["fullname"].string!
                    p.amount = unit["amount"].string!
                    form.cashList.list.append(p)
                }
            }
            
            //项目
            form.projectList.amount = dailyData["project_amount"].int!
            
            if let projectList = dailyData["project_list"].array {
                
                for unit in projectList {
                    let p = Project()
                    p.name = unit["fullname"].string!
                    p.amount = unit["amount"].string!
                    form.projectList.list.append(p)
                }
            }
            
            //产品
            form.productList.amount = dailyData["product_amount"].int!
            if let productList = dailyData["product_list"].array {
                
                for unit in productList {
                    let p = Project()
                    p.name = unit["fullname"].string!
                    p.amount = unit["amount"].string!
                    form.productList.list.append(p)
                }
            }
            
            //客流
            form.customerList.amount = dailyData["customer_num"].int!
            if let customerList = dailyData["customer_list"].array {
                
                for unit in customerList {
                    let p = Customer()
                    p.name = unit["fullname"].string!
                    p.consumeNumDay = unit["num"].string!
                    form.customerList.list.append(p)
                }
            }
            
            //客单价
            form.customerUnitPriceList.amount = dailyData["customer_price"].int!
            if let dict = dailyData["customer_price_list"].dictionary {
                form.customerUnitPriceList.dict = dict
                
            }
            
            //员工项目数
            form.employeeList.amount = dailyData["employee_project_num"].int!
            
            if let dict = dailyData["employee_project_list"].dictionary {
                form.employeeList.dict = dict
                
            }
            
            //项目均价
            form.projectPriceList.amount = dailyData["project_avg_price"].int!
            
            if let dict = dailyData["project_avg_list"].dictionary {
                form.projectPriceList.dict = dict
                
            }
            
            
            
            formList.append(form)
        }
        
       return formList
    }
    
    func setNumbers() -> [String] {
        
        var nums = [Int]()
        
        let form = formToday
        
        nums = [
            form.cashList.amount,
            form.projectList.amount,
            form.productList.amount,
            form.customerList.amount,
            form.customerUnitPriceList.amount,
            form.employeeList.amount,
            form.projectPriceList.amount,
        ]
        //将数字转换成千位代逗号
        var numsString = [String]()
        
        for num in nums {
            let fmt = NSNumberFormatter()
            fmt.numberStyle = .DecimalStyle
            let numString = fmt.stringFromNumber(num)!
            
            numsString.append(numString)
        }
        
        return numsString
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        var dataArray = [[FormData]]()
        
        let title = self.names[indexPath.row]
        
        var sections = [String]()
        
        var names = [[String]]()
        
        var details = [[String]]()
        
        if indexPath.row == 0 {
            
            sections = ["会员卡","产品"]
            
            names = [
                
                ["A卡","B卡","C卡"],
                ["产品A","产品B"]
                         ]
            details = [
                
                ["10,000","20,000","100,000"],
                       
                ["500","500"]
                           ]
            
        }
        else if indexPath.row == 1 {
            
            sections = ["会员卡","产品"]
            
            names = [
                
                ["A卡","B卡"],
                ["产品A","产品B"]
            ]
            details = [
                
                ["10,000","20,000"],
                
                ["500","500"]
            ]
            
        }
        else if indexPath.row == 2 {
            
            sections = ["产品"]
            
            names = [
                
                ["产品A","产品B","产品C"]
            ]
            details = [
                
                ["8000","3000","3000"]
                
            ]

            
        }
        else if indexPath.row == 3 {
            
            sections = [" "]
            
            names = [
                
                ["客户A","客户B","客户C"]
            ]
            details = [
                
                ["8000","3000","3000"]
                
            ]
            
        }
        else if indexPath.row == 4 {
            
            sections = [" "]
            
            names = [
                
                ["1000元以内","1000-2000元","2000元以上"]
            ]
            details = [
                
                ["2人","2人","5人"]
                
            ]
            
        }
        else if indexPath.row == 5 {
            
            sections = [" "]
            
            names = [
                
                ["1个","2个","3个"]
            ]
            details = [
                
                ["2人","2人","2人"]
                
            ]
        }
        else {
            
            sections = [" "]
            
            names = [
                
                ["500元以内","500-1000元","1000元以上"]
            ]
            details = [
                
                ["3个","10个","15个"]
                
            ]
        }
        
        
        for section in 0..<sections.count {
            var sectionData = [FormData]()
            for row in 0..<names[section].count {
                let data = FormData()
                data.name = names[section][row]
                data.detail = details[section][row]
                
                sectionData.append(data)
                
            }
            dataArray.append(sectionData)
        }
        
        let vc = FormDetailVC()
        vc.title = title
        vc.sections = sections
        vc.dataArray = dataArray
        
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

class FormData: NSObject {
    
    var name = ""
    
    var detail = ""
    
}

class FormDetailVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    var titleName = ""
    
    var tableView:UITableView!
    
    var sections = [String]()
    
    var dataArray = [[FormData]]()
    
    let cellId = "typeCell"
    
    override func viewDidLoad() {
        
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        view.backgroundColor = UIColor.whiteColor()
        
    }
    
    
   func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let datas = dataArray[section]
        return datas.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! typeCell
        cell.selectionStyle = .None
        let datas = dataArray[indexPath.section]
        cell.leftLabel.text = datas[indexPath.row].name
        cell.typeLabel.text = datas[indexPath.row].detail
        
        return cell
        
    }
    
    
    
}


class  PieViewController: PieChartViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    var rightBarItem = UIBarButtonItem()
    
    func setBarItem() {
        
        rightBarItem = UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FormVC.settingTap(_:)))
        navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    
    func settingTap(sender:UIBarButtonItem) {
        
        let vc = FormSettingVC()
        vc.title = "设置"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
