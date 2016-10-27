//
//  BaseChartViewController.swift
//  MeiBu
//
//  Created by Seppuu on 16/7/12.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class BaseChartViewController: BaseViewController {

    
    var filterNameArray = ["日期","日期","日期","日期"]
    
    var parties = [
        "金额", "客户", "产品", "产品", "金额", "F",
        "G", "H", "I", "J", "K", "L",
        "Party M", "Party N", "Party O", "Party P", "Party Q", "Party R",
        "Party S", "Party T", "Party U", "Party V", "Party W", "Party X",
        "Party Y", "Party Z"
    ]
    
    var centerText = ""
    
    var parentNavigationController : UINavigationController?
    
    var collectionView:UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func updateChartData() {
        //override this
    }
    
    func setupPieChartView(_ chartView:PieChartView) {
        
        chartView.usePercentValuesEnabled = false
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.4
        chartView.transparentCircleRadiusPercent = 0.4
        chartView.chartDescription?.text = ""
        chartView.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
        chartView.drawCenterTextEnabled = true
        
        
        let paragraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
//        let part2 = "MyBook"
//        let centerText = NSMutableAttributedString(string: "Charts by " + part2)
//        
//        centerText.setAttributes([
//            NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 13.0)!,
//            NSParagraphStyleAttributeName:paragraphStyle
//            ], range: NSMakeRange(0, centerText.length))
//        
//        centerText.setAttributes([
//            NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 11.0)!,
//            NSParagraphStyleAttributeName:paragraphStyle
//            ], range: NSMakeRange(0, centerText.length))
//        
//        centerText.setAttributes([
//            NSFontAttributeName:UIFont(name: "HelveticaNeue-LightItalic", size: 11.0)!,
//            NSForegroundColorAttributeName:UIColor.orangeColor()
//            ], range: NSMakeRange(centerText.length - part2.characters.count, part2.characters.count))
        
        //chartView.centerText = centerText
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        
        let l = chartView.legend
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.font = UIFont.systemFont(ofSize: 10)
        l.formSize = 14
        l.xEntrySpace = 7.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
    }
    
    
    func setupRadarChartView(_ radarChartView:RadarChartView) {
        
        radarChartView.noDataText = ""
    }
}




