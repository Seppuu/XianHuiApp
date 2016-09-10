//
//  RadarChartVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/25.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import Charts


class RadarChartVC: BaseChartViewController {

    var chartView:RadarChartView!
    
    var tableView:UITableView!
    
    let viewHeight = screenHeight - 64
    
    var listOfType = ["现金","实操","产品","客流","员工"]
    
    var topButtons = [UIButton]()
    
    var cellId = "typeCell"
    
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
        chartView.descriptionText = ""
        chartView.webLineWidth = 0.0
        chartView.innerWebLineWidth = 0.0
        chartView.highlightPerTapEnabled = false
        //蛛网竖线
        chartView.webColor = UIColor.clearColor()
        
        
        chartView.yAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.yAxis.labelTextColor = UIColor.clearColor()
        chartView.xAxis.labelTextColor = UIColor.clearColor()

        chartView.setExtraOffsets(left: 0, top: 50, right: 0, bottom: 20)
        chartView.rotationEnabled = false
        chartView.backgroundColor = UIColor ( red: 0.9109, green: 0.8698, blue: 0.8024, alpha: 1.0 )
        
        
        let inset = UIEdgeInsetsMake(0, 0, 5, 0)
        let color = UIColor.whiteColor()
        let font = UIFont.systemFontOfSize(12.0)
        let marker = BalloonMarker(color:color , font: font, insets: inset)

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
        yAxis.axisMinValue = 0.0
        yAxis.axisMaxValue = 100.0
        
        let l = chartView.legend
        l.drawInside = true
        l.orientation = .Vertical
        l.horizontalAlignment = .Right
        l.verticalAlignment = .Top
        l.direction = .RightToLeft
        l.font = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
        l.xEntrySpace = 7.0
        l.yEntrySpace = 5.0
        l.yOffset = 0.0
        l.setCustom(colors: [UIColor ( red: 0.8275, green: 0.7216, blue: 0.5529, alpha: 1.0 ),UIColor ( red: 0.4438, green: 0.3027, blue: 0.2227, alpha: 1.0 ) ,UIColor.clearColor() ], labels: ["七日均值","今日",""])
        
        updateChartData()
        
    }
    
    func setBottomTableView() {
        
        tableView = UITableView(frame:CGRect(x: 0, y: chartView.frame.size.height + chartView.frame.origin.y, width: screenWidth, height: viewHeight * 0.5) , style:.Plain )
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
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
        
        
        var yValsButton = [ChartDataEntry]() //button 位置
        
        var yVals0Back = [ChartDataEntry]() //这一层作为背景
        
        var yVals1 = [ChartDataEntry]() //基本数据
        
        var yVals2 = [ChartDataEntry]() //七日平均值
        
        for i in 0..<count {
            
            //某天值 原值最大值是5 这里*20
            let point = Double(form.pointArray[i] * 20)
            let entry = ChartDataEntry(value:point, xIndex: i, data: i)
            yVals1.append(entry)
            
            //七日均值
            let avgPoint = Double(form.avgPointArray[i] * 20 )
            let entryAvarage = ChartDataEntry(value: avgPoint , xIndex: i, data: i)
            yVals2.append(entryAvarage)

            
            let yMax = chartView.yAxis.axisMaxValue
            let entryEx = ChartDataEntry(value: yMax + 5 , xIndex: i, data: i)
            yValsButton.append(entryEx)
            
            
            let entryBack = ChartDataEntry(value: yMax , xIndex: i, data: i)
            yVals0Back.append(entryBack)
            
            
        }
        
        
        var xVals = [String]()
        
        //原生的维度Tag
        for i in 0..<count {
            let v = parties[i % parties.count]
            xVals.append(v)
        }
        
        
        let set0 = RadarChartDataSet(yVals: yVals0Back, label: "")
        set0.setColor(UIColor ( red: 0.7855, green: 0.6676, blue: 0.4805, alpha: 1.0 ))
        set0.fillColor = UIColor ( red: 0.7855, green: 0.6676, blue: 0.4805, alpha: 1.0 )
        set0.drawFilledEnabled = true
        set0.lineWidth = 0.0
        set0.fillAlpha = 0.3
        
        let set1 = RadarChartDataSet(yVals: yVals1, label: "今日")
        set1.setColor(UIColor ( red: 0.4438, green: 0.3027, blue: 0.2227, alpha: 1.0 ))
        set1.fillColor = UIColor ( red: 0.4438, green: 0.3027, blue: 0.2227, alpha: 1.0 )
        set1.drawFilledEnabled = true
        set1.lineWidth = 0.0
        set1.fillAlpha = 0.7
        
        
        let set2 = RadarChartDataSet(yVals: yVals2, label: "七日均值")
        set2.setColor(UIColor ( red: 0.7855, green: 0.6676, blue: 0.4805, alpha: 1.0 ))
        set2.fillColor = UIColor ( red: 0.7855, green: 0.6676, blue: 0.4805, alpha: 1.0 )
        set2.drawFilledEnabled = true
        set2.lineWidth = 0.0
        set2.fillAlpha = 0.7
        
        
        
        let data = RadarChartData(xVals: xVals, dataSets: [set0,set2,set1])
        data.setValueTextColor(UIColor.clearColor())
        data.setDrawValues(false)
        
        let percentFormatter = NSNumberFormatter()
        percentFormatter.positiveSuffix = ""
        percentFormatter.negativeSuffix = ""
        
        
        data.setValueFormatter(percentFormatter)
        
        chartView.data = data
        
        addCustomLabelToChartView(yValsButton)
    }
    
    func addCustomLabelToChartView(yVals:[ChartDataEntry]) {
        
        var buttons = [UIButton]()
        
        for yVal in yVals {
            
            if yVal.xIndex == 0{
                yVal.value += 20
            }
            else if yVal.xIndex == 4 {
                yVal.value += 45
            }
            
            let p = chartView.getMarkerPosition(entry: yVal, highlight: ChartHighlight())
            
            
            let button = UIButton(frame: CGRect(x: p.x, y: p.y, width: 40, height: 20))
            //button.setTitleColor(UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 ), forState: .Highlighted)
            //button.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            button.setTitleColor(UIColor ( red: 0.3779, green: 0.3171, blue: 0.3185, alpha: 1.0 ), forState: .Normal)
            button.setTitle(listOfType[yVal.xIndex], forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(13)
//            button.layer.cornerRadius = 4.0
//            button.layer.masksToBounds = true
//            button.layer.borderWidth = 0.8
//            button.layer.borderColor = UIColor ( red: 0.3779, green: 0.3171, blue: 0.3185, alpha: 1.0 ).CGColor
            button.tag = yVal.xIndex
            
            button.addTarget(self, action:  #selector(RadarChartVC.angleTypeTap(_:)), forControlEvents: .TouchUpInside)
            
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
    
    func adjustLabelPosition(buttons:[UIButton]) {
        
        let button01 = buttons[1]
        let button04 = buttons[4]
        
        button04.center.y = button01.center.y
        //调整button4 x 位置.让button4 和button1 对称
        let x = screenWidth - button01.frame.origin.x - button01.ddWidth
        
        button04.frame.origin.x = x

    }
    
    func makeButtonHightlighted(buttons:[UIButton],selected button:UIButton) {
        
        buttons.forEach {
            
            $0.selected = false
            $0.backgroundColor = UIColor.clearColor()
            
        }
        
        button.selected = true
        button.backgroundColor = UIColor ( red: 0.3779, green: 0.3171, blue: 0.3185, alpha: 1.0 )
        
    }
    
    func angleTypeTap(sender:UIButton) {
        let button = sender
        let index = button.tag
        let controller2 = PieViewController()
        switch index {
        case 0:
            
            controller2.title = "现金"
        case 1:
            
            controller2.title = "实操"
        case 2:
            
            controller2.title = "产品"
        case 3:
            
            controller2.title = "客流"
        case 4:
            
            controller2.title = "客单价"
        case 5:
            
            controller2.title = "人均项目数"
        case 6:
            
            controller2.title = "项目均价"
        default:
            break;
        }
        
        controller2.parentNavigationController = self.navigationController

        navigationController?.pushViewController(controller2, animated: true)
        //let buttons = topButtons
        //makeButtonHightlighted(buttons, selected: button)
    }
    
    func angleTypeTouchDown(sender:UIButton) {
        
        sender.backgroundColor = UIColor ( red: 0.3779, green: 0.3171, blue: 0.3185, alpha: 1.0 )
        
    }
    
    func angleTypeTouchCancel(sender:UIButton) {
        
        sender.backgroundColor = UIColor.clearColor()
    }
    

}

extension RadarChartVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! typeCell
        cell.backgroundColor = UIColor ( red: 1.0, green: 0.9882, blue: 0.9647, alpha: 1.0 )
        cell.selectionStyle = .Default
        cell.accessoryType = .DisclosureIndicator
        cell.leftLabel.text = names[indexPath.row]
        cell.typeLabel.text = numbers[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}

extension RadarChartVC:ChartViewDelegate {
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        
    }
    
}
