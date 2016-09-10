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
    
    var jsonData:JSON!
    
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
                
                self.jsonData = json!
                
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
            
            form.cash = dailyData["cash_amount"].int!
            
            if let cashList = dailyData["cash_list"].array {
                
                for unit in cashList {
                    let p = FormDetailList()
                    p.name = unit["fullname"].string!
                    p.amount = unit["amount"].string!
                    form.customerList.list.append(p)
                }
            }
            
            //项目
            form.projectList.amount = dailyData["project_amount"].int!
            
            form.project = dailyData["project_amount"].int!
            
            if let projectList = dailyData["project_list"].array {
                
                for unit in projectList {
                    let p = FormDetailList()
                    p.name = unit["fullname"].string!
                    p.amount = unit["amount"].string!
                    form.customerList.list.append(p)
                }
            }
            
            //产品
            form.productList.amount = dailyData["product_amount"].int!
            
            form.product = dailyData["product_amount"].int!
            
            if let productList = dailyData["product_list"].array {
                
                for unit in productList {
                    let p = FormDetailList()
                    p.name = unit["fullname"].string!
                    p.amount = unit["amount"].string!
                    form.customerList.list.append(p)
                }
            }
            
            //客流
            form.customerList.amount = dailyData["customer_num"].int!
            
            form.customerCount = dailyData["customer_num"].int!
            
            if let customerList = dailyData["customer_list"].array {
                
                for unit in customerList {
                    let p = FormDetailList()
                    p.name = unit["fullname"].string!
                    p.amount = unit["amount"].string!
                    form.customerList.list.append(p)
                }
            }
            
            //客单价
            form.customerUnitPriceList.amount = dailyData["customer_price"].int!
            
            if let data = dailyData["customer_price_list"].array {
                
                for unit in data {
                    let p = FormDetailList()
                    p.name = unit["fullname"].string!
                    p.amount = unit["amount"].string!
                    form.customerList.list.append(p)
                }
                
            }
            
            //员工项目数
            form.employeeList.amount = dailyData["employee_project_num"].int!
            
            form.employee = dailyData["employee_project_num"].int!
            
            if let data = dailyData["employee_project_list"].array {
                
                for unit in data {
                    let p = FormDetailList()
                    p.name = unit["fullname"].string!
                    p.amount = unit["amount"].string!
                    form.customerList.list.append(p)
                }
                
            }
            
            //项目均价
            form.projectPriceList.amount = dailyData["project_avg_price"].int!
            
            if let data = dailyData["project_avg_list"].array {
                
                for unit in data {
                    let p = FormDetailList()
                    p.name = unit["fullname"].string!
                    p.amount = unit["amount"].string!
                    form.customerList.list.append(p)
                }
                
            }
            
            
            //五个维度,当月平均和累计
            let monthlyAvg = json["monthly_avg"]
            let today = formList[0]
            today.monthlyAvgCash = monthlyAvg["cash"].int!
            
            today.monthlyAvgProject = monthlyAvg["project"].int!
            
            today.monthlyAvgProduct = monthlyAvg["product"].int!
            
            today.monthlyAvgCustomer = monthlyAvg["customer"].int!
            
            today.monthlyAvgEmployee = monthlyAvg["employee"].int!
            
            
            let monthlyTotal = json["monthly_total"]
            
            today.monthlyTotalCash = monthlyTotal["cash"].int!
            
            today.monthlyTotalProject = monthlyTotal["project"].int!
            
            today.monthlyTotalProduct = monthlyTotal["product"].int!
            
            today.monthlyTotalCustomer = monthlyTotal["customer"].int!
            
            today.monthlyTotalEmployee = monthlyTotal["employee"].int!
            
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
    
    override func angleTypeTap(sender: UIButton) {
        
        let button = sender
        let index = button.tag
        let vc = PieViewController()
        
        var nums = [Int]()
        
        var currentMonthAvgVaule:Float = 0.0
        
        var grandTotalValue:Float = 0.0
        
        switch index {
        case 0:
            
            vc.title = "现金"
            
            vc.data = self.jsonData["chart_data"]["cash"]
            
            for form in formList {
                let num = form.cash
                nums.append(num)
            }
            
            currentMonthAvgVaule = formToday.avgPointArray
            
        case 1:
            
            vc.title = "实操"
            vc.data = self.jsonData["chart_data"]["project"]
            
            for form in formList {
                let num = form.project
                nums.append(num)
            }
        case 2:
            
            vc.title = "产品"
            vc.data = self.jsonData["chart_data"]["product"]
            
            for form in formList {
                let num = form.product
                nums.append(num)
            }
        case 3:
            
            vc.title = "客流"
            vc.data = self.jsonData["chart_data"]["customer"]
            
            for form in formList {
                let num = form.customerCount
                nums.append(num)
            }
        case 4:
            
            vc.title = "员工"
            vc.data = self.jsonData["chart_data"]["employee"]
            
            for form in formList {
                let num = form.employee
                nums.append(num)
            }
            
        default:
            break;
        }
        
        vc.parentNavigationController = self.navigationController
        
        vc.numbers = nums.reverse()
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        var dataArray = [FormData]()
        
        let title = self.names[indexPath.row]
        
        
        let vc = FormDetailVC()
        vc.title = title
        
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
    
    var dataArray = [FormData]()
    
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! typeCell
        cell.selectionStyle = .None
        let datas = dataArray[indexPath.row]
        cell.leftLabel.text = datas.name
        cell.typeLabel.text = datas.detail
        
        return cell
        
    }
    
    
    
}


class  PieViewController: PieChartViewController {
    
    var data:JSON!
    
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
