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

    
    var parentNavigationController : UINavigationController?
    
    var collectionView:UICollectionView!
    
    var filterNameArray = ["日期","日期","日期","日期"]
    
    var parties = [
        "金额", "客户", "产品", "产品", "金额", "F",
        "G", "H", "I", "J", "K", "L",
        "Party M", "Party N", "Party O", "Party P", "Party Q", "Party R",
        "Party S", "Party T", "Party U", "Party V", "Party W", "Party X",
        "Party Y", "Party Z"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func updateChartData() {
        //override this
    }
    
    func setupPieChartView(chartView:PieChartView) {
        
        chartView.usePercentValuesEnabled = false
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.0
        chartView.transparentCircleRadiusPercent = 0.0
        chartView.descriptionText = ""
        chartView.setExtraOffsets(left: 5, top: 40, right: 5, bottom: 5)
        chartView.drawCenterTextEnabled = true
        
        let paragraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .ByTruncatingTail
        paragraphStyle.alignment = .Center
        
        let part2 = "MyBook"
        let centerText = NSMutableAttributedString(string: "Charts by " + part2)
        
        centerText.setAttributes([
            NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 13.0)!,
            NSParagraphStyleAttributeName:paragraphStyle
            ], range: NSMakeRange(0, centerText.length))
        
        centerText.setAttributes([
            NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 11.0)!,
            NSParagraphStyleAttributeName:paragraphStyle
            ], range: NSMakeRange(0, centerText.length))
        
        centerText.setAttributes([
            NSFontAttributeName:UIFont(name: "HelveticaNeue-LightItalic", size: 11.0)!,
            NSForegroundColorAttributeName:UIColor.orangeColor()
            ], range: NSMakeRange(centerText.length - part2.characters.count, part2.characters.count))
        
        //chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        
        let l = chartView.legend
        l.horizontalAlignment = .Right
        //l.labels = labels
        l.font = UIFont.systemFontOfSize(12)
        l.formSize = 12
        l.xEntrySpace = 7.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
    }
    
    
    func setupRadarChartView(radarChartView:RadarChartView) {
        
        radarChartView.noDataTextDescription = ""
    }
}




