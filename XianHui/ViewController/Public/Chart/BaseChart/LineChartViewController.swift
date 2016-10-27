//
//  LineChartViewController.swift
//  MeiBu
//
//  Created by Seppuu on 16/7/13.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class LineChartViewController: BaseChartViewController {
    
    var months: [String]!
    
    var lineChartView:LineChartView!
    
    var switchButton:UIButton!
    
    var animateButton: UIButton!
    
    var useData1 = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "折线图"
        
        lineChartView = LineChartView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width - 20, height: 200))
        lineChartView.noDataText = ""
        lineChartView.center.x = view.center.x
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        
        lineChartView.drawGridBackgroundEnabled = false
        
        lineChartView.dragEnabled = true
        
        lineChartView.autoScaleMinMaxEnabled = false
        
        lineChartView.setScaleEnabled(true)
        
        lineChartView.pinchZoomEnabled = false
        
        let xAxis = lineChartView.xAxis
        
        xAxis.labelPosition = .bottom
        
        lineChartView.rightAxis.enabled = false
        
        lineChartView.setYAxisMinWidth(.left, width: 30)
        
        lineChartView.leftAxis.axisMaximum = 32
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.leftAxis.labelCount = 4
        
        view.addSubview(lineChartView)
        
        switchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        switchButton.setTitle("更换数据源", for: UIControlState())
        switchButton.backgroundColor = UIColor.red
        switchButton.center = view.center
        view.addSubview(switchButton)
        switchButton.addTarget(self, action: #selector(LineChartViewController.changeChartData), for: .touchUpInside)
        
        animateButton = UIButton(frame: CGRect(x: 0, y: 360, width: 50, height: 30))
        animateButton.setTitle("move", for: UIControlState())
        animateButton.backgroundColor = UIColor.red
        view.addSubview(animateButton)
        animateButton.addTarget(self, action: #selector(LineChartViewController.moveCharts), for: .touchUpInside)
        
        firstData()
    }
    
    var data1:[Double] = [3,12,7,30,8]
    
    var data2:[Double] = [12,3,6,1,30]
    
    func makeNewDataSetWith(_ phase:Double) -> [Double] {
        
        var data3 = [Double]()
        
        for i in data2 {
            let index = data2.index(of: i)!
            let number = (data2[index] - data1[index]) * phase + data1[index]
            data3.append(number)
            
        }
        
        return data3
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func changeChartData() {
        
        firstData()
    }
    
    var progress: Double = 0
    var timer = Timer()
    
    func updateProgress() {
        
        guard progress <= 1 else {
            
            timer.invalidate()
            progress = 1.0
            setChartWithBool()
            progress = 0.0
            return
        }
        
        progress += 0.02
        
        setChartWithBool()
    }
    
    
    func moveCharts() {
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(LineChartViewController.updateProgress), userInfo: nil, repeats: true)
        
        timer.fire()
    }
    
    func firstData() {
        
        
        let count = 5
        
        var xVals = [String]()
        
        for i in 0..<count {
            
            let stringInt = String(i)
            xVals.append(stringInt)
        }
        
        var yVals = [ChartDataEntry]()
        
        var nums = data1
        
        let labelText = useData1 ? "数据1" : "数据2"
        
        for i in 0..<count {
            
            let val  = nums[i]
            
            let chartDataEntry = ChartDataEntry(x: val, y: Double(i))
            
            yVals.append(chartDataEntry)
            
        }
        
        let set1 = LineChartDataSet(values: yVals, label: labelText)
        set1.axisDependency = .left
        set1.fillColor = UIColor.orange
        set1.highlightColor = UIColor.lightGray
        
        set1.lineWidth = 2.0
        set1.circleRadius = 3.0
        set1.fillAlpha = 65/255.0
        set1.drawCircleHoleEnabled = false
        
        let dataSets = [set1]
        
        let data = LineChartData(dataSets: dataSets)
        
        lineChartView.data = data
        
        
        
    }
    
    func setChartWithBool() {
        
        let count = 5
        
        var xVals = [String]()
        
        for i in 0..<count {
            
            let stringInt = String(i)
            xVals.append(stringInt)
        }
        
        var yVals = [ChartDataEntry]()
        
        var nums = makeNewDataSetWith(progress)
        
        let labelText = useData1 ? "数据1" : "数据2"
        
        for i in 0..<count {
            
            let val  = nums[i]
            
            let chartDataEntry = ChartDataEntry(x: val, y: Double(i))
            
            yVals.append(chartDataEntry)
            
        }
        
        let set1 = LineChartDataSet(values: yVals, label: labelText)
        set1.axisDependency = .left
        set1.fillColor = UIColor.orange
        set1.highlightColor = UIColor.lightGray
        
        set1.lineWidth    = 2.0
        set1.circleRadius = 3.0
        set1.fillAlpha    = 65/255.0
        set1.drawCircleHoleEnabled = false
        
        let dataSets = [set1]
        
        let data = LineChartData(dataSets:dataSets)
        
        lineChartView.data = data
        
        
        
        //        lineChartView.leftAxis.customAxisMin = max(0.0, lineChartView.data!.yMin - 1.0)
        //        lineChartView.leftAxis.customAxisMax = min(10.0, lineChartView.data!.yMax + 1.0)
        
        //lineChartView.leftAxis.startAtZeroEnabled = false
        
    }
    
}
