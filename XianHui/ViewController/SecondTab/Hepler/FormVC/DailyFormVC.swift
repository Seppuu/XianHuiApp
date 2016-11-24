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
        setBarItem()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PieViewController.showDot), name: NeedUpdateMaxValueNoti, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PieViewController.disMissDot), name: NoNeedUpdateMaxValueNoti, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    var rightBarItem = UIBarButtonItem()
    
    var dot = UIView()
    
    private let dotWidth:CGFloat = 6
    
    var isShowDot = false {
        didSet {
            if isShowDot == true {
                dot.alpha = 1.0
            }
            else {
                dot.alpha = 0.0
            }
        }
    }
    
    func showDot() {
        
        isShowDot = true
    }
    
    func disMissDot() {
        
        isShowDot = false
    }
    
    func setBarItem() {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 21))
        button.setTitle("设置", for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.addTarget(self, action: #selector(DailyFormVC.settingTap(_:)), for: .touchUpInside)
        rightBarItem = UIBarButtonItem(customView: button)
        
        dot = UIView(frame: CGRect(x: 40 - dotWidth , y: 0, width: dotWidth, height: dotWidth))
        dot.layer.cornerRadius = dotWidth/2
        dot.layer.masksToBounds = true
        dot.backgroundColor = UIColor.red
        dot.alpha = 0.0
        button.addSubview(dot)
        navigationItem.rightBarButtonItem = rightBarItem
        
        
    }
    
    
    func settingTap(_ sender:UIBarButtonItem) {
        
        let vc = FormSettingVC()
        
        vc.saveCompletion = {
            
            //设置完之后,重新刷新UI.
            self.getDailyReportDataWith(self.noticeId)
        }
        
        vc.title = "设置"
        
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true, completion: nil)
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
    
    func getDailyReportDataWith(_ noticeId:Int) {
        
        NetworkManager.sharedManager.getDailyReportDataWith(noticeId) { (success, json, error) in
            
            if success == true {
                if let formList = self.makeFormDataWith(json!) {
                    self.formList = formList

                    self.form = self.formToday
                    
                    self.jsonData = json!
                    
                    self.chartView.reloadData()
                    
                    //下方列表数据源
                    let listArry = BaseTableViewModelList()
                    listArry.listName = ""
                    listArry.list = self.form.tableListArray
                    self.listArray = [listArry]
                    
                    self.tableView.reloadData()
                }
            }
            else {
                
            }
            
        }
        
    }
    
    
    func getChartDataList(_ datas:[JSON]) -> [XHChartData] {
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
    
    func makeFormDataWith(_ json:JSON) -> [Form]? {
        
        func makeRadarData(_ data:JSON) -> [RadarModel] {
            
            var array = [RadarModel]()
            if let vaules = data["value"].array {
                
                for data in vaules {
                    
                    let radarModel = RadarModel()
                    
                    if let name = data["name"].string {
                       radarModel.name = name
                    }
                    
                    if let score = data["score"].int {
                        radarModel.point = score
                    }
                    
                    if let amount = data["amount"].float {
                        radarModel.amount = amount
                        if radarModel.name == "工时" {
                           print(amount)
                            print(radarModel.name)
                        }
                        
                    }
                    
                    array.append(radarModel)
                    
                }
            }
            return array
        }
        
        var formList = [Form]()
        
        guard let daysData = json["weekly_daily"].array else {return nil}
        //今天的数据是数组第一个.
        for dailyData in daysData.reversed() {
            
            let form = Form()
            
            if let date = dailyData["date"].string {
               form.date = date
            }
            
            //雷达图单日,七日均值分数
            if let radarLists = dailyData["radar_list"].array {
                
                var todayList:JSON?
                
                var avgList:JSON?
                
                for list in radarLists {
                    
                    if let key = list["key"].string {
                        
                        if key == "7日均值" {
                           avgList = list
                        }
                        else if key == "今日" {
                            todayList = list
                        }
                        else {
                            
                        }
                    }
                }
                
                if let  actualTotayList = todayList {
                    form.pointArray = makeRadarData(actualTotayList)
                }
                
                if let acutalAvgList = avgList {
                    form.avgPointArray = makeRadarData(acutalAvgList)
                }
                

            }

            //下方列表
            if let homeLists = dailyData["home_list"].array {
                
                for data in homeLists {
                    
                    let dayModel = BaseTableViewModel()
                    
                    if let name = data["name"].string {
                        dayModel.name = name
                    }
                    
                    if let amount = data["amount"].string {
                        dayModel.desc = amount
                    }
                    
                    if let listModels = data["list"].array {
                        
                        for listModel in listModels {
                            
                            let model = BaseTableViewModel()
                            
                            if let name = listModel["fullname"].string {
                                model.name = name
                            }
                            
                            if let amount = listModel["amount"].string {
                                model.desc = amount
                            }
                            
                            dayModel.hasList = true
                            dayModel.listData.append(model)
                        }
                    }
                    
                    form.tableListArray.append(dayModel)
                }
                
            }
            
            //后续饼图
            //饼图
            if let chartLists = dailyData["chart_list"].array {
                
                for chartList in chartLists {
                    let list = ChartList()
                    
                    if let name = chartList["key"].string {
                        list.name = name
                    }
                    
                    //具体图表数据
                    if let values = chartList["value"].array {
                        
                        for value in values {
                            
                            
                            let chartModel = ChartModel()
                            //图表名称
                            if let name = value["key"].string {
                                chartModel.name = name
                            }
                            
                            //图表类型
                            if let type = chartList["type"].string {
                                
                                if type == "pie" {
                                    chartModel.type = .pie
                                }
                                else {
                                    //TODO:等待后续的更新,增加更多的图表
                                }
                                
                            }
                            
                            //图表数据
                            if let chartDatas = value["value"].array {
                                
                                chartModel.model = getChartDataList(chartDatas)
                                
                            }
                            
                            list.charts.append(chartModel)
                        }

                    }
                    
                    form.chartListArray.append(list)
                    
                }
                
                
                
                
            }
            formList.append(form)
        }

        //五个维度,当月平均和累计
        do {
            
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
        }
        
       return formList
    }

    override func angleTypeTap(_ index: Int) {
        
        let vc = PieViewController()
        
        vc.maxValueUpdateHandler = {
            
            self.getDailyReportDataWith(self.noticeId)
        }
        
        var nums = [Float]()
        
        var dateArray = [String]()
        
        var currentMonthAvgVaule = 0
        
        var grandTotalValue = 0
        
        //饼图类型 这里先写死
        var pieType = [String]()
        
        //饼图模型 多个一组
        var chartListArr = [ChartList]()
        
        
        for form in formList {
            let date = form.dateWithOutYear
            dateArray.append(date)
        }
        
        //雷达图按钮,点击之后显示的标题
        let title = formToday.pointArray[index].name
        
        for form in self.formList {
            //下一个页面,上方的数字
            let num = form.pointArray[index].amount
            nums.append(num)
            //获取某种视角的7天的图表组的数据集合
            
            
            //某天的一组图表
            let chartList = form.chartListArray[index]
            
            chartList.charts.forEach({ (chart) in
                //饼图类型文本
                pieType.append(chart.name)
            })
            
            //饼图数据集合
            chartListArr.append(chartList)
        }
        
        var maxType:MaxValueType = .cashMax
        
        switch index {
        case 0:
            maxType = .cashMax
            
        case 1:
            maxType = .projectMax
            
        case 2:
            maxType = .productMax
            
        case 3:
            maxType = .roomTurnoverMax
            
        case 4:
            maxType = .employeeHoursMax

        default:break;
        }
        
        
        currentMonthAvgVaule = formToday.monthlyAvgCash
        grandTotalValue = formToday.monthlyTotalCash
        
        
        vc.parentNavigationController = self.navigationController
        
        vc.numbers = nums.reversed()
        vc.listOfDateString = dateArray.reversed()
        vc.currentDayIndex = 6 //默认显示第7天
        vc.currentMonthAvgVaule = currentMonthAvgVaule
        vc.grandTotalValue = grandTotalValue
        vc.maxType = maxType
       
        vc.pieType = pieType
        vc.listOfChartDataArray  = chartListArr.reversed()
        
        vc.title = title
        
        navigationController?.pushViewController(vc, animated: true)
    }


}

class FormData: NSObject {
    
    var name = ""
    
    var detail = ""
    
}


class  PieViewController: PieChartViewController {
    
    var data:JSON!
    
    var maxValueUpdateHandler:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBarItem()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PieViewController.showDot), name: NeedUpdateMaxValueNoti, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PieViewController.disMissDot), name: NoNeedUpdateMaxValueNoti, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    var dot = UIView()
    
    private let dotWidth:CGFloat = 6
    
    var isShowDot = false {
        didSet {
            if isShowDot == true {
                dot.alpha = 1.0
            }
            else {
                dot.alpha = 0.0
            }
        }
    }
    
    func showDot() {
        
        isShowDot = true
    }
    
    func disMissDot() {
        
        isShowDot = false
    }
    
    var rightBarItem = UIBarButtonItem()
    
    func setBarItem() {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 21))
        button.setTitle("设置", for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.addTarget(self, action: #selector(FormVC.settingTap(_:)), for: .touchUpInside)
        rightBarItem = UIBarButtonItem(customView: button)
        
        dot = UIView(frame: CGRect(x: 40 - dotWidth , y: 0, width: dotWidth, height: dotWidth))
        dot.layer.cornerRadius = dotWidth/2
        dot.layer.masksToBounds = true
        dot.backgroundColor = UIColor.red
        dot.alpha = 0.0
        button.addSubview(dot)
        navigationItem.rightBarButtonItem = rightBarItem
        
        
    }
    
    
    func settingTap(_ sender:UIBarButtonItem) {
        
        let vc = FormSettingVC()
        
        vc.saveCompletion = {
            
            //设置完之后,重新刷新UI.
            self.topPageView.pageScrollView.reloadData()
            self.maxValueUpdateHandler?()
        }
        
        vc.title = "设置"
        
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true, completion: nil)
    }
    
}
