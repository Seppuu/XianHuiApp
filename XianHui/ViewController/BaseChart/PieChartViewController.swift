//
//  PieChartViewController.swift
//  MeiBu
//
//  Created by Seppuu on 16/7/13.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class PieChartViewController: BaseChartViewController ,ChartViewDelegate{
    
    var pieChartView: PieChartView!
    
    var tableView:UITableView!
    
    var dataOfPieChart = ["张芳芳","李华","陈蕾","徐天天","吴悦"]
    
    var pieChartTopConstraint:Constraint? = nil
    
    var tableViewTopConstraint:Constraint? = nil
    
    var cellID = "CertificateCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView = PieChartView()
        pieChartView.delegate = self
        view.addSubview(pieChartView)
        pieChartView.snp_makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(view.ddHeight)
            self.pieChartTopConstraint =  make.top.equalTo(view).constraint
        }
        
        setupPieChartView(pieChartView)
        
        self.updateChartData()
        
        //tableViewSet
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        view.addSubview(tableView)
        
        let nib = UINib(nibName: cellID, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellID)
        
        tableView.snp_makeConstraints { (make) in
            make.left.right.equalTo(view)
            self.tableViewTopConstraint = make.top.equalTo(view).offset(64).constraint
            make.height.equalTo((screenHeight * 2)/5)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableViewTopConstraint?.updateOffset(-screenWidth)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func updateChartData() {
        
        setDataCountWith(4, range: 10)
    }
    
    func setDataCountWith(count:Int,range:Double) {
        
        let mult = range
        
        var yVals1 = [BarChartDataEntry]()
        
        for i in 0..<count {
            
            let val  = Double(arc4random_uniform(UInt32(mult))) + mult/4
            
            let chartDataEntry = BarChartDataEntry(value: val, xIndex: i)
            
            yVals1.append(chartDataEntry)
        }
        
        var xVals = [String]()
        
        for i in 0..<count {
            
            let str = parties[i % parties.count]
            xVals.append(str)
            
        }
        
        let dataSet = PieChartDataSet(yVals: yVals1, label: "Election Results")
        
        var colors = [UIColor]()
        
        colors += ChartColorTemplates.vordiplom()
        colors += ChartColorTemplates.joyful()
        colors += ChartColorTemplates.colorful()
        colors += ChartColorTemplates.liberty()
        colors += ChartColorTemplates.pastel()
        
        colors += [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1.0)]
        
        dataSet.colors = colors
        
        let data = PieChartData(xVals: xVals, dataSet: dataSet)
        
        let pFormatter = NSNumberFormatter()
        pFormatter.numberStyle = .PercentStyle
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(pFormatter)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 11.0))
        data.setValueTextColor(UIColor.darkTextColor())
        
        pieChartView.data = data
        
    }
    
    func moveSelectdSliceToVertical(index:Int) {
        
        let selcetPartDrawAngle = self.pieChartView.drawAngles[index]
        let selcetPartAbsoluteAngle = self.pieChartView.absoluteAngles[index]
        
        let toAngle = (270 - (selcetPartAbsoluteAngle - selcetPartDrawAngle/2))
        
        
        self.pieChartView.spin(duration: 0.5, fromAngle: self.pieChartView.rotationAngle, toAngle: toAngle, easingOption: .EaseInOutSine)
        delay(1.2) {
            print("toAngle:\(toAngle)")
            print(self.pieChartView.rotationAngle)
        }
        
        self.moveAndScalePieChart()
    }
    
    func moveAndScalePieChart() {
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            
            self.pieChartTopConstraint?.updateOffset((screenHeight * 2) / 5)
            self.tableViewTopConstraint?.updateOffset(0)
            self.view.layoutIfNeeded()
        }) { (success) in
        }
        
    }
    
    
    func reSetViewPositionAnimeted() {
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            
            self.tableViewTopConstraint?.updateOffset(-self.tableView.frame.size.height)
            self.pieChartTopConstraint?.updateOffset(0)
            self.view.layoutIfNeeded()
        }) { (success) in
        }
        
    }
    
}

extension PieChartViewController {
    
    //MARK:ChartViewDelegate
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        
        let index = entry.xIndex
        
        moveSelectdSliceToVertical(index)
    }
    
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        
        reSetViewPositionAnimeted()
    }
    
}

extension PieChartViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataOfPieChart.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! CertificateCell
        
        cell.accessoryType = .DisclosureIndicator
        cell.leftLabel.text = dataOfPieChart[indexPath.row]
        
        cell.rightLabel.text = "熟练"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = BaseViewController()
        vc.view.backgroundColor = UIColor.ddViewBackGroundColor()
        vc.title = dataOfPieChart[indexPath.row]
        self.parentNavigationController?.pushViewController(vc, animated: true)
    }
    
}
