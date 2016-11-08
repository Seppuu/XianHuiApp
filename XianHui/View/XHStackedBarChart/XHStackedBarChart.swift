//
//  XHStackedBarChart.swift
//  XianHui
//
//  Created by jidanyu on 2016/11/7.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import Charts
import SnapKit

let YAxisValue:Double = 80

class XHStackedBarChart: UIView,ChartViewDelegate {
    
    var chartView = BarChartView()
    var unit = ""
    
    var chartBackColor = UIColor.init(hexString: "EDE4D4")
    var axisTextColor  = UIColor.init(hexString: "7D7067")
    
    
    var dataColor1 = UIColor.init(hexString: "C1B4A0")
    var dataColor2 = UIColor.init(hexString: "D89F44")
    var dataColor3 = UIColor.init(hexString: "D74C48")
    
    override func didMoveToSuperview() {
       setChartView()
    }
    
    func setChartView() {
        
        chartView = BarChartView(frame: self.bounds)
        chartView.backgroundColor = UIColor.white
        self.addSubview(chartView)
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.backgroundColor = chartBackColor
        chartView.maxVisibleCount = 7
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.highlightFullBarEnabled = false
        
    
        
        let leftAxis = chartView.leftAxis
        leftAxis.valueFormatter = DayTimeAxisValueFormatter()
        leftAxis.axisMinimum = 0.0 // this replaces startAtZero = YES
        leftAxis.setLabelCount(5, force: true)
        leftAxis.spaceTop = 0.0
        leftAxis.labelTextColor = axisTextColor
        
        chartView.rightAxis.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .top
        xAxis.valueFormatter = WeekAxisValueFormatter()
        xAxis.labelTextColor = axisTextColor
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.textColor = axisTextColor
        l.form = .square
        l.formSize = 8.0
        l.formToTextSpace = 4.0
        l.xEntrySpace = 6.0
        
        updateChartData()
    }
    
    func updateChartData() {
        
        self.setDataCount(7)
        
    }
    
    func setDataCount(_ count:Int) {
        
        var yVals = [BarChartDataEntry]()
    
        for i in 0 ..< count {
            
            let val1 = YAxisValue
            let val2 = YAxisValue
            let val3 = YAxisValue
            let val4 = YAxisValue
            
            let entry = BarChartDataEntry(x: Double(i), yValues: [val1,val2,val3,val4])
            yVals.append(entry)
        }
        
        var set1:BarChartDataSet? = nil
        
        
        if ( chartView.data != nil && (chartView.data?.dataSetCount)! > 0) {
            if let set = chartView.data?.dataSets[0] as? BarChartDataSet {
                set1?.values = set.values
                chartView.data?.notifyDataChanged()
                chartView.notifyDataSetChanged()
            }
            
        }
        else {
            set1 = BarChartDataSet(values: yVals, label: "房间满载率")
            
            set1?.colors = [
                dataColor1,
                dataColor2,
                dataColor3
            ]
            
            set1?.stackLabels = ["<33%","<66%",">66%"]
            
            var dataSets = [BarChartDataSet]()
            dataSets.append(set1!)
            
            let data = BarChartData(dataSets: dataSets)
            let font = UIFont(name: "HelveticaNeue-Light", size: 7.0)
            data.setValueFont(font)
            data.setDrawValues(false)
            //data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            data.setValueTextColor(UIColor.black)
            //这个值是间隔百分比.最大值1.0 默认0.85
            data.barWidth = 0.5
            chartView.fitBars = true
            chartView.data = data
        }
        
    }
    
    //MARK:ChartViewDelegate
   
}


class WeekAxisValueFormatter: NSObject,IAxisValueFormatter {
    
    var weeks = ["周一","周二","周三","周四","周五","周六","周日"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let index = Int(value)

        return weeks[index]
    }
}

class DayTimeAxisValueFormatter: NSObject,IAxisValueFormatter {
    
    var dayTimes = ["09:00","12:00","15:00","18:00","21:00"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value / YAxisValue)
       // print("value:\(value)")
        return dayTimes.reversed()[index]
        
    }
}
