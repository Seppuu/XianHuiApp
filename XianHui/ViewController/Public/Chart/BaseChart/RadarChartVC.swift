//
//  RadarChartVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/25.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class RadarChartVC: BaseChartViewController {

    var chartView:RadarChartView!
    
    var topDayLabel = UILabel()
    
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
    

    func setRadarChartView() {
        
        chartView = RadarChartView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: viewHeight * 0.5))
        view.addSubview(chartView)
        
        chartView.delegate = self
        chartView.chartDescription?.text = ""
        chartView.webLineWidth = 0.0
        chartView.innerWebLineWidth = 0.0
        chartView.highlightPerTapEnabled = false
        //蛛网竖线
        chartView.webColor = UIColor.clear
        
        
        chartView.yAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.yAxis.labelTextColor = UIColor.clear
        chartView.xAxis.labelTextColor = UIColor.clear

        chartView.setExtraOffsets(left: 0, top: 50, right: 0, bottom: 20)
        chartView.rotationEnabled = false
        chartView.backgroundColor = UIColor ( red: 0.9109, green: 0.8698, blue: 0.8024, alpha: 1.0 )
        
        
        let inset = UIEdgeInsetsMake(0, 0, 5, 0)
        let color = UIColor.white
        let font = UIFont.systemFont(ofSize: 12.0)
        let marker = BalloonMarker(color:color , font: font,textColor:UIColor.darkText, insets: inset)

        chartView.marker = marker
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 15.0)!
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        
        
        let yAxis = chartView.yAxis
        yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 9.0)!
        yAxis.drawGridLinesEnabled = false
        yAxis.drawAxisLineEnabled = false
        yAxis.setLabelCount(1, force: true)
        yAxis.axisMinimum = 0.0
        yAxis.axisMaximum = 100.0
        
        let l = chartView.legend
        l.drawInside = true
        l.orientation = .vertical
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.direction = .rightToLeft
        l.font = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
        l.xEntrySpace = 7.0
        l.yEntrySpace = 5.0
        l.yOffset = 0.0
        //l.setCustom(colors: [UIColor ( red: 0.8275, green: 0.7216, blue: 0.5529, alpha: 1.0 ),UIColor ( red: 0.4438, green: 0.3027, blue: 0.2227, alpha: 1.0 ) ,UIColor.clear ], labels: ["七日均值","今日",""])
        let le0 = LegendEntry()
        le0.formColor = UIColor ( red: 0.8275, green: 0.7216, blue: 0.5529, alpha: 1.0 )
        le0.label = "七日均值"
        
        let le1 = LegendEntry()
        le1.formColor = UIColor ( red: 0.4438, green: 0.3027, blue: 0.2227, alpha: 1.0 )
        le1.label = "今日"
        
        let le2 = LegendEntry()
        le2.formColor = UIColor.clear
        le2.label = ""
        
        l.setCustom(entries: [le0,le1,le2])
        
        updateChartData()
        
        
        chartView.addSubview(topDayLabel)
        topDayLabel.text = ""
        topDayLabel.textColor = UIColor ( red: 0.3779, green: 0.3171, blue: 0.3185, alpha: 1.0 )
        topDayLabel.font = UIFont.systemFont(ofSize: 14)
        topDayLabel.textAlignment = .left
        topDayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(chartView).offset(15)
            make.width.equalTo(200)
            make.top.equalTo(chartView).offset(15)
        }
        
    }
    
    func setBottomTableView() {
        
        tableView = UITableView(frame:CGRect(x: 0, y: chartView.frame.size.height + chartView.frame.origin.y, width: screenWidth, height: viewHeight * 0.5) , style:.plain )
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.showsVerticalScrollIndicator = false
        
        tableView.backgroundColor = UIColor ( red: 1.0, green: 0.9882, blue: 0.9647, alpha: 1.0 )
        
    }
    
    override func updateChartData() {
        
        setChartData()
    }
    
    
    func setChartData() {
        //最大值
       // let mult:Double = form.totalScore
        
        //维度数量
        let count = form.viewCount
        
        self.topDayLabel.text = form.date
        
        var yValsButton = [RadarChartDataEntry]() //button 位置
        
        var yVals0Back = [RadarChartDataEntry]() //这一层作为背景
        
        var yVals1 = [RadarChartDataEntry]() //基本数据
        
        var yVals2 = [RadarChartDataEntry]() //七日平均值
        
        for i in 0..<count {
            
            //某天值 原值最大值是5 这里*20
            let point = Double(form.pointArray[i].point * 20)
            let entry = RadarChartDataEntry(value: point)
                //ChartDataEntry(x:point, y: Double(i))
            yVals1.append(entry)
            
            //七日均值
            let avgPoint = Double(form.avgPointArray[i].point * 20)
            let entryAvarage = RadarChartDataEntry(value: avgPoint)
            yVals2.append(entryAvarage)

            //button位置
            let yMax = chartView.yAxis.axisMaximum
            let entryEx = RadarChartDataEntry(value: yMax)
            yValsButton.append(entryEx)
            
            //背景颜色
            let entryBack = RadarChartDataEntry(value: yMax)
            yVals0Back.append(entryBack)
            

        }
        
        
        var xVals = [String]()
        
        //原生的维度Tag
        for i in 0..<count {
            let v = parties[i % parties.count]
            xVals.append(v)
        }
        
        let set0 = RadarChartDataSet(values: yVals0Back, label: "")
        set0.setColor(UIColor ( red: 0.7855, green: 0.6676, blue: 0.4805, alpha: 1.0 ))
        set0.fillColor = UIColor ( red: 0.7855, green: 0.6676, blue: 0.4805, alpha: 1.0 )
        set0.drawFilledEnabled = true
        set0.lineWidth = 0.0
        set0.fillAlpha = 0.3
        
        let set1 = RadarChartDataSet(values: yVals1, label: "今日")
        set1.setColor(UIColor ( red: 0.4438, green: 0.3027, blue: 0.2227, alpha: 1.0 ))
        set1.fillColor = UIColor ( red: 0.4438, green: 0.3027, blue: 0.2227, alpha: 1.0 )
        set1.drawFilledEnabled = true
        set1.lineWidth = 0.0
        set1.fillAlpha = 0.7
        
        
        let set2 = RadarChartDataSet(values: yVals2, label: "七日均值")
        set2.setColor(UIColor ( red: 0.7855, green: 0.6676, blue: 0.4805, alpha: 1.0 ))
        set2.fillColor = UIColor ( red: 0.7855, green: 0.6676, blue: 0.4805, alpha: 1.0 )
        set2.drawFilledEnabled = true
        set2.lineWidth = 0.0
        set2.fillAlpha = 0.7
        
        
        let data = RadarChartData(dataSets: [set0,set2,set1])
        data.setValueTextColor(UIColor.clear)
        data.setDrawValues(false)
        
        let percentFormatter = NumberFormatter()
        percentFormatter.positiveSuffix = ""
        percentFormatter.negativeSuffix = ""
        
        let vFormatter = DefaultValueFormatter(formatter: percentFormatter)
        data.setValueFormatter(vFormatter)
        
        chartView.data = data
        
        addCustomLabelToChartView(yValsButton)
        
    }
    
    func addCustomLabelToChartView(_ yVals:[RadarChartDataEntry]) {
        
        var buttons = [UIButton]()
        //TODO:button dismissed
        for var yVal in yVals {
            
            if yVal.x == 0{
                yVal.y += 20
            }
            else if yVal.x == 4 {
                yVal.y += 45
            }
            
            //let p = chartView.getMarkerPosition(entry: yVal, highlight: Highlight())
            let highLight = Highlight(x: yVal.x, y: yVal.y, dataSetIndex: Int(yVal.x))
            let p = chartView.getMarkerPosition(highlight:highLight)
            
            let button = UIButton(frame: CGRect(x: p.x, y: p.y, width: 40, height: 20))
            //button.setTitleColor(UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 ), forState: .Highlighted)
            //button.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            button.setTitleColor(UIColor ( red: 0.3779, green: 0.3171, blue: 0.3185, alpha: 1.0 ), for: .normal)
            button.setTitle(listOfType[Int(yVal.x)], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//            button.layer.cornerRadius = 4.0
//            button.layer.masksToBounds = true
//            button.layer.borderWidth = 0.8
//            button.layer.borderColor = UIColor ( red: 0.3779, green: 0.3171, blue: 0.3185, alpha: 1.0 ).CGColor
            button.tag = Int(yVal.x)
            
            button.addTarget(self, action:  #selector(RadarChartVC.angleTypeTap(_:)), for: .touchUpInside)
            
//            button.addTarget(self, action:  #selector(RadarChartVC.angleTypeTouchDown(_:)), forControlEvents: .TouchDown)
//            
//            button.addTarget(self, action:  #selector(RadarChartVC.angleTypeTouchCancel(_:)), forControlEvents: .TouchUpOutside)
            
            chartView.addSubview(button)
            
            buttons.append(button)
            
            //调整位置(顺时针0-4)
            switch button.tag {
            case 0:
                //设置x中心点为p.x
                button.center.x = p.x
            case 1:
                //设置y中心店为p.y
                button.center.y = p.y
                //button.contentHorizontalAlignment = .Left
            case 2 ,3:
                //向左边移动一个合适的数值
                button.frame.origin.x -= 15
                //button.contentHorizontalAlignment = .Left
            case 4:
                //和1保持同一个水平线
                button.frame.origin.x -= 1
                //button.contentHorizontalAlignment = .Left
            default:
                break;
            }
        }
        //调整04label
        adjustLabelPosition(buttons)
        
        //makeButtonHightlighted(buttons, selected: buttons[0])
        
        topButtons = buttons
    }
    
    func adjustLabelPosition(_ buttons:[UIButton]) {
        
        if buttons.count == 0 {
            return
        }
        let button01 = buttons[1]
        let button04 = buttons[4]
        
        button04.center.y = button01.center.y
        //调整button4 x 位置.让button4 和button1 对称
        let x = screenWidth - button01.frame.origin.x - button01.ddWidth
        
        button04.frame.origin.x = x

    }
    
    func makeButtonHightlighted(_ buttons:[UIButton],selected button:UIButton) {
        
        buttons.forEach {
            
            $0.isSelected = false
            $0.backgroundColor = UIColor.clear
            
        }
        
        button.isSelected = true
        button.backgroundColor = UIColor ( red: 0.3779, green: 0.3171, blue: 0.3185, alpha: 1.0 )
        
    }
    
    func angleTypeTap(_ sender:UIButton) {
        

    }
    
    func angleTypeTouchDown(_ sender:UIButton) {
        
        sender.backgroundColor = UIColor ( red: 0.3779, green: 0.3171, blue: 0.3185, alpha: 1.0 )
        
    }
    
    func angleTypeTouchCancel(_ sender:UIButton) {
        
        sender.backgroundColor = UIColor.clear
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
        cell?.typeLabel.textAlignment = .right
        
        if baseModel.hasList == true {
            cell?.accessoryType = .disclosureIndicator
        }
        else {
            cell?.accessoryType = .none
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

extension RadarChartVC:ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
        
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
    }
    
}
