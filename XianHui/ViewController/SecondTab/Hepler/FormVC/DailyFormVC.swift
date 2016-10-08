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
    
    
    var jsonData:JSON!
    
    var noticeId:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDailyReportDataWith(noticeId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
    func getDailyReportDataWith(noticeId:Int) {
        
        NetworkManager.sharedManager.getDailyReportDataWith(noticeId) { (success, json, error) in
            
            if success == true {
                if let formList = self.makeFormDataWith(json!) {
                    self.formList = formList
                    self.numbers = self.setNumbers()
                    self.names = ["现金","实操","产品","客流","客单价","人均项目数","项目均价"]
                    
                    self.form = self.formToday
                    
                    self.jsonData = json!
                    
                    self.setChartData()
                    self.tableView.reloadData()
                }
                
                
                
            }
            else {
                
            }
            
        }
        
    }
    
    func makeFormDataWith(json:JSON) -> [Form]? {
        
        var formList = [Form]()
        
        guard let daysData = json["weekly_daily"].array else {return nil}
        //今天的数据是数组第一个.
        for dailyData in daysData {
            
            let form = Form()
            
            if let date = dailyData["date"].string {
               form.date = date
            }
            
            //雷达图单日分数
            if let cashPoint = dailyData["radar_data"]["today"]["cash"].int {
                form.cashPoint = cashPoint
            }
            
            if let projectPoint = dailyData["radar_data"]["today"]["project"].int {
                form.projectPoint = projectPoint
            }
            
            if let productionPoint = dailyData["radar_data"]["today"]["product"].int {
                form.productionPoint = productionPoint
            }
            
            if let customerCountPoint = dailyData["radar_data"]["today"]["customer"].int {
                form.customerCountPoint = customerCountPoint
            }
            
            if let employeePoint = dailyData["radar_data"]["today"]["employee"].int {
                form.employeePoint = employeePoint
            }
            
            //雷达图七日均价
            if let cashAvgPoint = dailyData["radar_data"]["avg"]["cash"].int{
                form.cashAvgPoint = cashAvgPoint
            }
            
            if let projectAvgPoint = dailyData["radar_data"]["avg"]["project"].int {
                form.projectAvgPoint = projectAvgPoint
            }
            if let productionAvgPoint = dailyData["radar_data"]["avg"]["product"].int {
                form.productionAvgPoint = productionAvgPoint
            }
            
            if let customerCountAvgPoint = dailyData["radar_data"]["avg"]["customer"].int {
                form.customerCountAvgPoint = customerCountAvgPoint
            }
            
            if let employeeAvgPoint = dailyData["radar_data"]["avg"]["employee"].int {
                form.employeeAvgPoint = employeeAvgPoint
            }
            
            //下方列表
            //现金
            if let amount = dailyData["cash_amount"].int {
                form.cashList.amount = amount
            }
            
            if let cash = dailyData["cash_amount"].int {
                form.cash = cash
            }
            
            if let cashList = dailyData["cash_list"].array {
                
                for unit in cashList {
                    let p = FormDetailList()
                    if let name = unit["fullname"].string{
                        p.name = name
                    }
                    
                    if let amount = unit["amount"].string {
                        p.amount = amount
                    }
                    form.cashList.list.append(p)
                }
            }
            
            //项目
            if let amount = dailyData["project_amount"].int {
                form.projectList.amount = amount
            }
            
            if let project = dailyData["project_amount"].int {
                form.project = project
            }
            
            if let projectList = dailyData["project_list"].array {
                
                for unit in projectList {
                    let p = FormDetailList()
                    if let name = unit["fullname"].string {
                        p.name = name
                    }
                    if let amount = unit["amount"].string{
                        p.amount = amount
                    }
                    form.projectList.list.append(p)
                }
            }
            
            //产品
            if let amount = dailyData["product_amount"].int{
                form.productList.amount = amount
            }
            
            if let product = dailyData["product_amount"].int{
                form.product = product
            }
            
            if let productList = dailyData["product_list"].array {
                
                for unit in productList {
                    let p = FormDetailList()
                    if let name = unit["fullname"].string{
                        p.name = name
                    }
                    if let amount = unit["amount"].string {
                        p.amount = amount
                    }
                    form.productList.list.append(p)
                }
            }
            
            //客流
            if let amount = dailyData["customer_num"].int{
                form.customerList.amount = amount
            }
            
            if let customerCount = dailyData["customer_num"].int{
                form.customerCount = customerCount
            }
            
            if let customerList = dailyData["customer_list"].array {
                
                for unit in customerList {
                    let p = FormDetailList()
                    if let name = unit["fullname"].string{
                        p.name = name
                    }
                    if let amount = unit["amount"].string{
                        p.amount = amount
                    }
                    form.customerList.list.append(p)
                }
            }
            
            //客单价
            form.customerUnitPriceList.amount = dailyData["customer_price"].int!
            
            if let data = dailyData["customer_price_list"].array {
                
                for unit in data {
                    let p = FormDetailList()
                    if let name = unit["fullname"].string{
                        p.name = name
                    }
                    
                    if let amount = unit["amount"].string{
                        p.amount = amount
                    }
                    form.customerUnitPriceList.list.append(p)
                }
                
            }
            
            //员工项目数
            if let amount = dailyData["employee_project_num"].int{
                form.employeeList.amount = amount
            }
            
            if let employee = dailyData["employee_project_num"].int{
                form.employee = employee
            }
            
            if let data = dailyData["employee_project_list"].array {
                
                for unit in data {
                    let p = FormDetailList()
                    if let name = unit["fullname"].string{
                        p.name = name
                    }
                    
                    if let amount = unit["amount"].string{
                        p.amount = amount
                    }
                    form.employeeList.list.append(p)
                }
                
            }
            
            //项目均价
            if let amount = dailyData["project_avg_price"].int{
                form.projectPriceList.amount = amount
            }
            
            if let data = dailyData["project_avg_list"].array {
                
                for unit in data {
                    let p = FormDetailList()
                    if let name = unit["fullname"].string{
                        p.name = name
                    }
                    if let amount = unit["amount"].string{
                        p.amount = amount
                    }
                    form.projectPriceList.list.append(p)
                }
                
            }
            
            formList.append(form)
            
        }
        
        //五个维度,当月平均和累计
        let monthlyAvg = json["monthly_avg"]
        let today = formList[0]
        
        if let monthlyAvgCash = monthlyAvg["cash"].int{
            today.monthlyAvgCash = monthlyAvgCash
        }
        
        if let monthlyAvgProject = monthlyAvg["project"].int{
            today.monthlyAvgProject = monthlyAvgProject
        }
        
        if let monthlyAvgProduct = monthlyAvg["product"].int{
            today.monthlyAvgProduct = monthlyAvgProduct
        }
        
        if let monthlyAvgCustomer = monthlyAvg["customer"].int{
            today.monthlyAvgCustomer = monthlyAvgCustomer
        }
        
        if let monthlyAvgEmployee = monthlyAvg["employee"].int{
            today.monthlyAvgEmployee = monthlyAvgEmployee
        }
        
        
        let monthlyTotal = json["monthly_total"]
        
        if let monthlyTotalCash = monthlyTotal["cash"].int{
            today.monthlyTotalCash = monthlyTotalCash
        }
        
        if let monthlyTotalProject = monthlyTotal["project"].int{
            today.monthlyTotalProject = monthlyTotalProject
        }
        
        if let monthlyTotalProduct = monthlyTotal["product"].int{
            today.monthlyTotalProduct = monthlyTotalProduct
        }
        
        if let monthlyTotalCustomer = monthlyTotal["customer"].int{
            today.monthlyTotalCustomer = monthlyTotalCustomer
        }
        
        if let monthlyTotalEmployee = monthlyTotal["employee"].int{
            today.monthlyTotalEmployee = monthlyTotalEmployee
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
        
        var dateArray = [String]()
        
        var currentMonthAvgVaule = 0
        
        var grandTotalValue = 0
        
        //饼图类型 这里先写死
        var pieType = [String]()
        
        //饼图模型 多个一组
        var chartDatasArray = [[XHChartData]]()
        
        func getChartDataListArry(datas:[JSON]) -> [XHChartData] {
            var totalVal:Double = 0.0
            
            //计算百分比
            for data in datas {
                if let amount = data["amount"].int {
                    totalVal += Double(amount)
                }
               
            }
            
            var chartDatas = [XHChartData]()
            for data in datas {
                let c = XHChartData()
                if let name = data["name"].string {
                    c.x = name
                }
                
                if let amount = data["amount"].int {
                    c.y = (Double(amount)/totalVal) * 100
                }
                
                chartDatas.append(c)
            }
            
            return chartDatas
        }
        
        
        for form in formList {
            let date = form.dateWithOutYear
            dateArray.append(date)
        }
        
        switch index {
        case 0:
            
            vc.title = "现金"
            
            vc.data = self.jsonData["chart_data"]["cash"]
            
            for form in formList {
                let num = form.cash
                nums.append(num)
            }
            
            currentMonthAvgVaule = formToday.monthlyAvgCash
            grandTotalValue = formToday.monthlyTotalCash
            
            pieType = ["消费类型","客户类型","顾问业绩"]
            if let datas = jsonData!["weekly_daily"].array {
                
                let formThisDay = datas[index]
                
                //消费类型
                if let customer_typeArr = formThisDay["chart_data"]["cash"]["customer_type"].array {
                    let datas = getChartDataListArry(customer_typeArr)
                    chartDatasArray.append(datas)
                }
                //客户类型
                if let consume_type = formThisDay["chart_data"]["cash"]["consume_type"].array {
                    let datas = getChartDataListArry(consume_type)
                    chartDatasArray.append(datas)
                }
            
                //顾问业绩
                if let adviser = formThisDay["chart_data"]["cash"]["adviser"].array {
                    let datas = getChartDataListArry(adviser)
                    chartDatasArray.append(datas)
                }
                
            }
            
        case 1:
            
            vc.title = "实操"
            vc.data = self.jsonData["chart_data"]["project"]
            
            for form in formList {
                let num = form.project
                nums.append(num)
            }
          
            currentMonthAvgVaule = formToday.monthlyAvgProject
            grandTotalValue = formToday.monthlyTotalProject
            
            pieType = ["项目类型","员工类型","折实价"]
            if let datas = jsonData!["weekly_daily"].array {
                
                let formThisDay = datas[index]
                
                //消费类型
                if let project_type = formThisDay["chart_data"]["project"]["project_type"].array {
                    let datas = getChartDataListArry(project_type)
                    chartDatasArray.append(datas)
                }
                //客户类型
                if let employee_type = formThisDay["chart_data"]["project"]["employee_type"].array {
                    let datas = getChartDataListArry(employee_type)
                    chartDatasArray.append(datas)
                }
                
                //顾问业绩
                if let real_amount = formThisDay["chart_data"]["project"]["real_amount"].array {
                    let datas = getChartDataListArry(real_amount)
                    chartDatasArray.append(datas)
                }
                
            }
            
            
        case 2:
            
            vc.title = "产品"
            vc.data = self.jsonData["chart_data"]["product"]
            
            for form in formList {
                let num = form.product
                nums.append(num)
            }
            
            currentMonthAvgVaule = formToday.monthlyAvgProduct
            grandTotalValue = formToday.monthlyTotalProduct
            
            pieType = ["产品类型","周转周期","生命周期"]
            
            if let datas = jsonData!["weekly_daily"].array {
                
                let formThisDay = datas[index]
                
                //消费类型
                if let product_type = formThisDay["chart_data"]["product"]["product_type"].array {
                    let datas = getChartDataListArry(product_type)
                    chartDatasArray.append(datas)
                }
                //客户类型
                if let turn_over = formThisDay["chart_data"]["product"]["turn_over"].array {
                    let datas = getChartDataListArry(turn_over)
                    chartDatasArray.append(datas)
                }
                
                //顾问业绩
                if let life_cycle = formThisDay["chart_data"]["product"]["life_cycle"].array {
                    let datas = getChartDataListArry(life_cycle)
                    chartDatasArray.append(datas)
                }
                
            }
            
        case 3:
            
            vc.title = "客流"
            vc.data = self.jsonData["chart_data"]["customer"]
            
            for form in formList {
                let num = form.customerCount
                nums.append(num)
            }
            
           
            currentMonthAvgVaule = formToday.monthlyAvgCustomer
            grandTotalValue = formToday.monthlyTotalCustomer
            
            pieType = ["顾问","客户类型","本月到店"]
            
            if let datas = jsonData!["weekly_daily"].array {
                
                let formThisDay = datas[index]
                
                //消费类型
                if let adviser = formThisDay["chart_data"]["customer"]["adviser"].array {
                    let datas = getChartDataListArry(adviser)
                    chartDatasArray.append(datas)
                }
                //客户类型
                if let customer_type = formThisDay["chart_data"]["customer"]["customer_type"].array {
                    let datas = getChartDataListArry(customer_type)
                    chartDatasArray.append(datas)
                }
                
                //顾问业绩
                if let arrival_total = formThisDay["chart_data"]["customer"]["arrival_total"].array {
                    let datas = getChartDataListArry(arrival_total)
                    chartDatasArray.append(datas)
                }
                
            }
            
        case 4:
            
            vc.title = "员工"
            vc.data = self.jsonData["chart_data"]["employee"]
            
            for form in formList {
                let num = form.employee
                nums.append(num)
            }
            
           
            currentMonthAvgVaule = formToday.monthlyAvgEmployee
            grandTotalValue = formToday.monthlyTotalEmployee
            
            pieType = ["有效工时","个人产值"]
            
            if let datas = jsonData!["weekly_daily"].array {
                
                let formThisDay = datas[index]
                
                //消费类型
                if let hours = formThisDay["chart_data"]["employee"]["hours"].array {
                    let datas = getChartDataListArry(hours)
                    chartDatasArray.append(datas)
                }
                //客户类型
                if let amount = formThisDay["chart_data"]["employee"]["amount"].array {
                    let datas = getChartDataListArry(amount)
                    chartDatasArray.append(datas)
                }
                
            }
            
        default:
            break;
        }
        
        vc.parentNavigationController = self.navigationController
        
        vc.numbers = nums.reverse()
        vc.listOfDateString = dateArray.reverse()
        
        vc.currentMonthAvgVaule = currentMonthAvgVaule
        vc.grandTotalValue = grandTotalValue
        
       
        vc.pieType = pieType
        vc.listOfChartDataArray = chartDatasArray
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        var dataArray = [FormData]()
        
        let title = self.names[indexPath.row]
        
        let list = formToday.listArray[indexPath.row]
        
        for l in list.list {
            let d = FormData()
            d.name = l.name
            d.detail = l.amount
            dataArray.append(d)
        }
        
        
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
        
        vc.saveCompletion = {
            
            //设置完之后,重新刷新UI.
            self.topPageView.pageScrollView.reloadData()
        }
        
        vc.title = "设置"
        
        let nav = UINavigationController(rootViewController: vc)
        
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
}
