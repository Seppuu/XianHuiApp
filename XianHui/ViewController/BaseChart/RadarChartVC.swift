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
    
    let viewHeight = ( screenHeight - 64 - 44 )
    
    var listOfType = ["客户","金额","技师","产品","顾问"]
    
    var topButtons = [UIButton]()
    
    var currentType:String = "客户" {
        didSet {
            let set = NSIndexSet(index: 0)
            tableView.reloadSections(set, withRowAnimation: .Fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRadarChartView()
        
        setBottomTableView()
        
        currentType = listOfType[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    func setRadarChartView() {
        
        chartView = RadarChartView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: viewHeight * 0.4))
        view.addSubview(chartView)
        
        chartView.delegate = self
        chartView.descriptionText = ""
        chartView.webLineWidth = 0.75
        chartView.innerWebLineWidth = 0.375
        chartView.highlightPerTapEnabled = false
        chartView.webAlpha = 0.7
        chartView.yAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.xAxis.labelTextColor = UIColor.clearColor()

        chartView.setExtraOffsets(left: 0, top: 30, right: 0, bottom: 15)
        chartView.rotationEnabled = false
        chartView.backgroundColor = UIColor ( red: 0.9294, green: 0.8941, blue: 0.8392, alpha: 1.0 )

        
        
        let inset = UIEdgeInsetsMake(0, 0, 5, 0)
        let color = UIColor.whiteColor()
        let font = UIFont.systemFontOfSize(12.0)
        let marker = BalloonMarker(color:color , font: font, insets: inset)

        chartView.marker = marker
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 15.0)!
        
        let yAxis = chartView.yAxis
        yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 9.0)!
        yAxis.labelCount = 2
        yAxis.axisMinValue = 0.0
        yAxis.axisMaxValue = 100
        
        let l = chartView.legend
        l.drawInside = true
        l.font = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
        l.xEntrySpace = 7.0
        l.yEntrySpace = 5.0
        
        updateChartData()
        
    }
    
    func setBottomTableView() {
        
        tableView = UITableView(frame:CGRect(x: 0, y: chartView.frame.size.height, width: screenWidth, height: viewHeight * 0.6) , style:.Plain )
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        
        
    }
    
    override func updateChartData() {
        
        setChartData()
    }
    
    
    func setChartData() {
        
        let mult:Double = 100
        let count = 5
        
        var yVals1 = [ChartDataEntry]()
        var yVals2 = [ChartDataEntry]()
        
        for i in 0..<count {
            let dd = Double(arc4random_uniform(UInt32(mult)))
            let entry = ChartDataEntry(value:dd, xIndex: i, data: i)
            
            let yMax = chartView.yAxis.axisMaxValue
            let entryEx = ChartDataEntry(value: yMax + 10 , xIndex: i, data: i)
            yVals1.append(entry)
            yVals2.append(entryEx)
            
        }
        
        
        var xVals = [String]()
        
        for i in 0..<count {
            let v = parties[i % parties.count]
            xVals.append(v)
        }
        
        
        let set1 = RadarChartDataSet(yVals: yVals1, label: "set 1")
        set1.setColor(UIColor ( red: 0.7855, green: 0.6676, blue: 0.4805, alpha: 1.0 ))
        set1.fillColor = UIColor ( red: 0.7855, green: 0.6676, blue: 0.4805, alpha: 1.0 )
        set1.drawFilledEnabled = true
        set1.lineWidth = 2.0
        set1.drawFilledEnabled = true
        
        
        let data = RadarChartData(xVals: xVals, dataSets: [set1])
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 8.0))
        data.setDrawValues(true)
        
        let percentFormatter = NSNumberFormatter()
        percentFormatter.positiveSuffix = ""
        percentFormatter.negativeSuffix = ""
        
        
        data.setValueFormatter(percentFormatter)
        
        chartView.data = data
        
        addCustomLabelToChartView(yVals2)
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
            button.setTitleColor(UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 ), forState: .Highlighted)
            button.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            button.setTitleColor(UIColor ( red: 0.3779, green: 0.3171, blue: 0.3185, alpha: 1.0 ), forState: .Normal)
            button.setTitle(listOfType[yVal.xIndex], forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(12)
            button.layer.cornerRadius = 4.0
            button.layer.masksToBounds = true
            button.layer.borderWidth = 0.8
            button.layer.borderColor = UIColor ( red: 0.3779, green: 0.3171, blue: 0.3185, alpha: 1.0 ).CGColor
            button.tag = yVal.xIndex
            
            button.addTarget(self, action:  #selector(RadarChartVC.angleTypeTap(_:)), forControlEvents: .TouchUpInside)
            
            button.addTarget(self, action:  #selector(RadarChartVC.angleTypeTouchDown(_:)), forControlEvents: .TouchDown)
            
            button.addTarget(self, action:  #selector(RadarChartVC.angleTypeTouchCancel(_:)), forControlEvents: .TouchUpOutside)
            
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
                button.frame.origin.x -= 5
                //button.contentHorizontalAlignment = .Left
            default:
                break;
            }
        }
        //调整04label
        adjustLabelPosition(buttons)
        
        makeButtonHightlighted(buttons, selected: buttons[0])
        
        topButtons = buttons
    }
    
    func adjustLabelPosition(labels:[UIButton]) {
        
        let label01 = labels[1]
        let label04 = labels[4]
        
        label04.center.y = label01.center.y

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
        sender.backgroundColor = UIColor.clearColor()
        currentType = listOfType[index]
        
        let buttons = topButtons
        makeButtonHightlighted(buttons, selected: button)
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
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "\(currentType): 1/\(indexPath.item + 1)"
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
