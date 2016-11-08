//
//  XHStackedChartViewController.swift
//  XianHui
//
//  Created by jidanyu on 2016/11/8.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import Charts


class XHStackedChartViewController: UIViewController,ChartViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setChartView()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }

    var chartView = BarChartView()
    var unit = " $"
    
    func setChartView() {
        
        
        chartView = BarChartView(frame: self.view.frame)
        chartView.backgroundColor = UIColor.white
        self.view.addSubview(chartView)
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        
        chartView.maxVisibleCount = 40
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.highlightFullBarEnabled = false
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = unit
        leftAxisFormatter.positiveSuffix = unit
        
        let leftAxis = chartView.leftAxis
        let iVFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.valueFormatter = iVFormatter
        leftAxis.axisMinimum = 0.0 // this replaces startAtZero = YES
        
        chartView.rightAxis.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .top
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8.0
        l.formToTextSpace = 4.0
        l.xEntrySpace = 6.0
        
        updateChartData()
    }
    
    func updateChartData() {
        
        self.setDataCount(4, range:100)
        
    }
    
    func setDataCount(_ count:Int,range:Double) {
        
        var yVals = [BarChartDataEntry]()
        
        for i in 0 ..< count {
            
            let  mult = (range + 1)
                        let val1 = Double(arc4random_uniform(UInt32(mult))) + mult / 3
                        let val2 = Double(arc4random_uniform(UInt32(mult))) + mult / 3
                        let val3 = Double(arc4random_uniform(UInt32(mult))) + mult / 3
            
//            let val1:Double = 80
//            let val2:Double = 60
//            let val3:Double = 40
            
            let entry = BarChartDataEntry(x: Double(i), yValues: [(val1),(val2),(val3)])
            yVals.append(entry)
        }
        
        var set1:BarChartDataSet? = nil
        
        
        //        if ( chartView.data != nil && (chartView.data?.dataSetCount)! > 0) {
        //            if let set = chartView.data?.dataSets[0] as? BarChartDataSet {
        //                set1?.values = set.values
        //                chartView.data?.notifyDataChanged()
        //                chartView.notifyDataSetChanged()
        //            }
        //
        //        }
        //else {
        set1 = BarChartDataSet(values: yVals, label: "Statistics Vienna 2014")
        
        set1?.colors = [
            ChartColorTemplates.material()[0],
            ChartColorTemplates.material()[1],
            ChartColorTemplates.material()[2]
        ]
        
        set1?.stackLabels = ["Births","Divorces","Marriages"]
        
        var dataSets = [BarChartDataSet]()
        dataSets.append(set1!)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = unit
        formatter.positiveSuffix = unit
        
        let data = BarChartData(dataSets: dataSets)
        let font = UIFont(name: "HelveticaNeue-Light", size: 7.0)
        data.setValueFont(font)
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueTextColor(UIColor.black)
        
        chartView.fitBars = true
        chartView.data = data
        // }
        
    }
    
    //MARK:ChartViewDelegate
    
    
    
    
}
