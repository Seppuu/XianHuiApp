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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRadarChartView()
        
        setBottomTableView()
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
        chartView.webAlpha = 0.7
        chartView.yAxis.enabled = false
        chartView.setExtraOffsets(left: 0, top: 20, right: 0, bottom: 10)
        chartView.rotationEnabled = false
        
        let inset = UIEdgeInsetsMake(0, 0, 5, 0)
        let color = UIColor.whiteColor()
        let font = UIFont.systemFontOfSize(12.0)
        let marker = BalloonMarker(color:color , font: font, insets: inset)

        chartView.marker = marker
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 9.0)!
        
        
        let yAxis = chartView.yAxis
        yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 9.0)!
        yAxis.labelCount = 2
        yAxis.axisMinValue = 0.0
        
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
        
        let mult:Double = 150
        let count = 5
        
        var yVals1 = [ChartDataEntry]()
        var yVals2 = [ChartDataEntry]()
        
        for i in 0..<count {
            let dd = Double(arc4random_uniform(UInt32(mult)))
            let entry = ChartDataEntry(value: (dd + mult / 2), xIndex: i, data: i)
            
            yVals1.append(entry)
            yVals2.append(entry)
            
        }
        
        
        var xVals = [String]()
        
        for i in 0..<count {
            let v = parties[i % parties.count]
            xVals.append(v)
        }
        
        
        let set1 = RadarChartDataSet(yVals: yVals1, label: "set 1")
        set1.setColor(UIColor ( red: 1.0, green: 0.5129, blue: 0.5935, alpha: 1.0 ))
        set1.fillColor = UIColor ( red: 1.0, green: 0.5723, blue: 0.9247, alpha: 1.0 )
        set1.drawFilledEnabled = true
        set1.lineWidth = 2.0
        set1.drawFilledEnabled = true
        
//        
//        let set2 = RadarChartDataSet(yVals: yVals2, label: "set 2")
//        set2.setColor(UIColor ( red: 0.7589, green: 0.989, blue: 0.7129, alpha: 1.0 ))
//        set2.fillColor = UIColor ( red: 0.5286, green: 0.9345, blue: 0.9893, alpha: 1.0 )
//        set2.drawFilledEnabled = true
//        set2.lineWidth = 2.0
//        
        
        
        let data = RadarChartData(xVals: xVals, dataSets: [set1])
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 8.0))
        data.setDrawValues(true)
        
        let percentFormatter = NSNumberFormatter()
        percentFormatter.positiveSuffix = ""
        percentFormatter.negativeSuffix = ""
        
        
        data.setValueFormatter(percentFormatter)
        
        chartView.data = data;

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
        cell.textLabel?.text = "维度:\(indexPath.item)"
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
