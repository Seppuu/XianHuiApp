//
//  RadarChartVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/25.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SnapKit

class RadarChartVC: UIViewController, TKRadarChartDataSource,TKRadarChartDelegateDefault {

    var parentNavigationController : UINavigationController?
    
    var chartView:TKRadarChart!
    
    var topDayLabel = UILabel()
    
    var topOrgNameLabel = UILabel()
    
    var tableView:UITableView!
    
    let viewHeight = screenHeight - 64
    
    var topButtons = [UIButton]()
    
    let typeCellId = "typeCell"
    
    var dataID:Int!
    
    var listOfType:[String] {
        
        var arr = [String]()
        
        form.pointArray.forEach { (model) in
            arr.append(model.name)
        }
        
        return arr
        
    }
    
    var cellHeight:CGFloat = 44
    
    var listArray = [BaseTableViewModelList]()
    
    var names = [String]()
    
    var numbers = [String]()
    
    var form = Form()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRadarChartView()
        
        setBottomTableView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    var chartContainer:UIView!
    func setRadarChartView() {
        
        self.view.backgroundColor = UIColor.init(hexString: "EDE4D6")
        
        chartContainer = UIView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: viewHeight * 0.5))
        chartContainer.backgroundColor = UIColor.init(hexString: "EDE4D6")
        view.addSubview(chartContainer)
        
        let w = screenWidth
        chartView = TKRadarChart(frame:chartContainer.bounds)
        chartView.configuration.radius = w/3.5
        chartView.configuration.showBorder = true
        chartView.configuration.showPoint = true
        chartView.configuration.maxValue = 100.00
        chartView.configuration.minValue = 0.00
        chartView.dataSource = self
        chartView.delegate = self
        //chartView.center = chartContainer.center
        chartView.reloadData()
        chartContainer.addSubview(chartView)
        
        chartView.angleTypeTapHandler = {
            (index) in
            self.angleTypeTap(index)
        }
        
        let rightImageView0 = UIImageView()
        rightImageView0.backgroundColor = UIColor ( red: 0.8275, green: 0.7216, blue: 0.5529, alpha: 1.0 )
        chartView.addSubview(rightImageView0)
        rightImageView0.snp.makeConstraints { (make) in
            make.right.equalTo(chartView).offset(-57)
            make.width.height.equalTo(12)
            make.top.equalTo(chartView).offset(15)
        }
        
        let rightImageView1 = UIImageView()
        rightImageView1.backgroundColor = UIColor ( red: 0.4438, green: 0.3027, blue: 0.2227, alpha: 1.0 )
        chartView.addSubview(rightImageView1)
        rightImageView1.snp.makeConstraints { (make) in
            make.right.equalTo(chartView).offset(-57)
            make.width.height.equalTo(12)
            make.top.equalTo(rightImageView0.snp.bottom).offset(5)
        }
        
        let rightLabel0 = UILabel()
        chartView.addSubview(rightLabel0)
        rightLabel0.text = "七日均值"
        rightLabel0.textColor = UIColor.init(hexString: "746464")
        rightLabel0.font = UIFont.systemFont(ofSize: 12)
        rightLabel0.textAlignment = .left
        rightLabel0.snp.makeConstraints { (make) in
            make.left.equalTo(rightImageView0.snp.right).offset(5)
            make.centerY.equalTo(rightImageView0)
            make.width.equalTo(150)
        }
        
        let rightLabel1 = UILabel()
        chartView.addSubview(rightLabel1)
        rightLabel1.text = "今日"
        rightLabel1.textColor = UIColor.init(hexString: "746464")
        rightLabel1.font = UIFont.systemFont(ofSize: 12)
        rightLabel1.textAlignment = .left
        rightLabel1.snp.makeConstraints { (make) in
            make.left.equalTo(rightImageView1.snp.right).offset(5)
            make.centerY.equalTo(rightImageView1)
            make.width.equalTo(150)
        }
        
        chartView.reloadData()
        
        chartView.addSubview(topOrgNameLabel)
        topOrgNameLabel.text = Defaults.currentOrgNameForMaxValueSetting.value!
        topOrgNameLabel.textColor = UIColor ( red: 0.3779, green: 0.3171, blue: 0.3185, alpha: 1.0 )
        topOrgNameLabel.font = UIFont.systemFont(ofSize: 14)
        topOrgNameLabel.textAlignment = .left
        topOrgNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(chartView).offset(15)
            make.width.equalTo(200)
            make.top.equalTo(chartView).offset(15)
        }
        
        
        chartView.addSubview(topDayLabel)
        topDayLabel.text = ""
        topDayLabel.textColor = UIColor ( red: 0.3779, green: 0.3171, blue: 0.3185, alpha: 1.0 )
        topDayLabel.font = UIFont.systemFont(ofSize: 14)
        topDayLabel.textAlignment = .left
        topDayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(chartView).offset(15)
            make.width.equalTo(200)
            make.top.equalTo(topOrgNameLabel).offset(15)
        }
        
    }
    
    func setBottomTableView() {
        
        tableView = UITableView(frame:CGRect(x: 0, y: chartContainer.frame.size.height + chartContainer.frame.origin.y, width: screenWidth, height: viewHeight * 0.5) , style:.plain )
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.showsVerticalScrollIndicator = false
        
        tableView.backgroundColor = UIColor ( red: 1.0, green: 0.9882, blue: 0.9647, alpha: 1.0 )
        
    }
    
    func angleTypeTap(_ index:Int) {
        
    }
    
    func numberOfStepForRadarChart(_ radarChart: TKRadarChart) -> Int {
        return 5
    }
    func numberOfRowForRadarChart(_ radarChart: TKRadarChart) -> Int {
        self.topDayLabel.text = form.date
        return form.viewCount
    }
    func numberOfSectionForRadarChart(_ radarChart: TKRadarChart) -> Int {
        return 2
    }
    
    func fontOfTitleForRadarChart(_ radarChart: TKRadarChart) -> UIFont {
        return UIFont.systemFont(ofSize: 13)
    }
    
    func titleOfRowForRadarChart(_ radarChart: TKRadarChart, row: Int) -> String {
        return listOfType[row]
    }
    
    func valueOfSectionForRadarChart(withRow row: Int, section: Int) -> CGFloat {
        if section == 0 {
            //七日均值
            let avgPoint = CGFloat(form.avgPointArray[row].point * 20)
            return avgPoint
        } else {
            //今日值
            let point = CGFloat(form.pointArray[row].point * 20)
            return point
        }
    }
    
    func colorOfLineForRadarChart(_ radarChart: TKRadarChart) -> UIColor {
        return UIColor.init(hexString: "BEAC94")
    }
    
    func colorOfFillStepForRadarChart(_ radarChart: TKRadarChart, step: Int) -> UIColor {

        return UIColor ( red: 224/255, green: 205/255, blue: 177/255, alpha: 1.0 )
    }
    
    func colorOfSectionFillForRadarChart(_ radarChart: TKRadarChart, section: Int) -> UIColor {
        if section == 0 {
            return  UIColor ( red: 214/255, green: 182/255, blue: 143/255, alpha: 0.6 )
        } else {
            return UIColor ( red: 152/255, green: 117/255, blue: 95/255, alpha: 0.6 )
            
        }
        
    }
    
    func colorOfSectionBorderForRadarChart(_ radarChart: TKRadarChart, section: Int) -> UIColor {

        if section == 0 {
            return UIColor ( red: 214/255, green: 182/255, blue: 143/255, alpha: 1.0 )
        }
        else {
            return UIColor ( red: 152/255, green: 117/255, blue: 95/255, alpha:1.0 )
        }
        
    }


}

extension RadarChartVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray[section].list.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listArray[section].listName
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let baseModel = listArray[(indexPath as NSIndexPath).section].list[(indexPath as NSIndexPath).row]
        
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        let baseModel = listArray[(indexPath as NSIndexPath).section].list[(indexPath as NSIndexPath).row]
        
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

