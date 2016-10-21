//
//  XHBarChartView.swift
//  XianHui
//
//  Created by Seppuu on 16/7/26.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import Charts
import SnapKit
import SwiftString


enum MaxValueType:String {
    
    case cashMax = "cashMax"
    case projectMax = "projectMax"
    case productMax = "productMax"
    case roomTurnoverMax = "roomTurnoverMax"
    case employeeHoursMax = "employeeHoursMax"
}

class XHBarChartView: OTPageView,OTPageScrollViewDataSource,OTPageScrollViewDelegate {
    
    var topLabel = UILabel()
    
    var dateLabel = UILabel()
    
    var rightLabel01 = UILabel()
    
    var rightLabel02 = UILabel()
    
    var currentMonthAvgVaule:Int = 0
    
    var grandTotalValue:Int = 0
    
    //TODO:change max value by type
    var maxValue:Float {
        
        switch maxType {
        case .cashMax:
            return Defaults.cashMaxValue.value!
        case .projectMax:
            return Defaults.projectMaxValue.value!
        case .productMax:
            return Defaults.productMaxValue.value!
        case .roomTurnoverMax:
            return Defaults.roomTurnoverMaxValue.value!
        case .employeeHoursMax:
            return Defaults.employeeHoursMaxValue.value!
        }
    }
    
    var maxType:MaxValueType = .cashMax
    
    var listOfNumber: [String] {
        //将Int转化为千位数逗号String
        var numsString = [String]()
        
        for num in listOfNumber2 {
            let fmt = NSNumberFormatter()
            fmt.numberStyle = .DecimalStyle
            let numString = fmt.stringFromNumber(num)!
            
            numsString.append(numString)
        }
        
        return numsString

    }
    
    var listOfNumber2 = [Int]()
    
    var listOfDateString = [String]()
    
    var currentPageChangedHandler:((index:Int)->())?
    
    override func layoutSubviews() {
        
        topLabel.textColor = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        topLabel.text = listOfNumber.last
        topLabel.textAlignment = .Center
        addSubview(topLabel)
        topLabel.snp_makeConstraints { (make) in
            make.width.equalTo(screenWidth)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.pageScrollView.snp_top)
        }
        
        topLabel.text = listOfNumber.last
        
        dateLabel.textColor = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        dateLabel.text = listOfNumber.last
        dateLabel.textAlignment = .Center
        addSubview(dateLabel)
        dateLabel.snp_makeConstraints { (make) in
            make.width.equalTo(screenWidth)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        dateLabel.text = listOfDateString.last
        
        
        rightLabel01.textColor = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        rightLabel01.font = UIFont.systemFontOfSize(12)
        
        let str01 = String(currentMonthAvgVaule)
        
        rightLabel01.text = "当月平均:" + str01
        rightLabel01.textAlignment = .Left
        addSubview(rightLabel01)
        rightLabel01.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self).offset(10)
            make.width.equalTo(self)
            make.height.equalTo(21)
        }
        
        
        rightLabel02.textColor = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        rightLabel02.font = UIFont.systemFontOfSize(12)
        let str02 = String(currentMonthAvgVaule)
        rightLabel02.text = "当月累计:" + str02
        rightLabel02.textAlignment = .Left
        addSubview(rightLabel02)
        rightLabel02.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(rightLabel01.snp_bottom).offset(10)
            make.width.equalTo(self)
            make.height.equalTo(21)
        }
        
        
    }
    
    
    func setScrollView() {
        
        
        pageScrollView.frame = CGRectMake((screenWidth - 50)/2 , ddHeight * 0.25, 50, ddHeight * 0.5)
        pageScrollView.delegate = self
        pageScrollView.dataSource = self
        pageScrollView.padding = 25;
        pageScrollView.leftRightOffset = 0
        
    }
    
    func moveToLastPage() {
        
        self.pageScrollView.moveToPageAt(listOfNumber.count - 1, animeted: false)
        guard let cell = self.pageScrollView.viewForRowAtIndex(listOfNumber.count - 1) as? VoiceRecordSampleCell else {return}
        cell.color = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
    }

    func numberOfPageInPageScrollView(pageScrollView: OTPageScrollView!) -> Int {
        
        return listOfNumber.count
    }
    
    func pageScrollView(pageScrollView: OTPageScrollView!, viewForRowAtIndex index: Int32) -> UIView! {
        
        let view = VoiceRecordSampleCell(frame: CGRect(x: 0, y: 0, width: 25, height: ddHeight * 0.5))
        let item = Int(index)
        var val = Float(listOfNumber2[item])
        
        if val == 0 {
            //如果数值是0.加一点.防止UI界面消失
            val = 0.01
        }
        
        view.value = val / maxValue
        
        view.color = UIColor ( red: 0.8275, green: 0.7216, blue: 0.5529, alpha: 1.0 )
        
        return view
        
    }
    
    func sizeCellForPageScrollView(pageScrollView: OTPageScrollView!) -> CGSize {
        
        return CGSizeMake(25, ddHeight * 0.5)
    }
    
    func pageScrollView(pageScrollView: OTPageScrollView!, didTapPageAtIndex index: Int) {
        
        currentPageChangedHandler?(index: index)
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        updateColor(scrollView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        currentPageChangedHandler?(index: index)
        
    }
    
    func updateColor(scrollView:UIScrollView) {
        
        for index in 0..<listOfNumber.count {
            let cell = self.pageScrollView.viewForRowAtIndex(index) as! VoiceRecordSampleCell
            cell.color = UIColor ( red: 0.8275, green: 0.7216, blue: 0.5529, alpha: 1.0 )
        }
        
        let index = scrollView.contentOffset.x / scrollView.frame.size.width
        guard let cell = self.pageScrollView.viewForRowAtIndex(Int(index)) as? VoiceRecordSampleCell else {return}
        cell.color = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        
        topLabel.text = listOfNumber[Int(index)]
        
        dateLabel.text = listOfDateString[Int(index)]
    }
    
    func updateProgress(scrollView: UIScrollView) {
        
        let currentCenterX = currentCenter(scrollView).x
        let bounds = self.pageScrollView.bounds
        
        for view in allTopCell() {
            
            let progress = (view.center.x - currentCenterX) / CGRectGetWidth(bounds) * CGFloat(1)
            updateView(view, withProgress: progress)
        }
        
    }
    
    func allTopCell() -> [VoiceRecordSampleCell] {
        
        var cells = [VoiceRecordSampleCell]()
        
        for i in 0..<listOfNumber.count {
            
            let cell = self.pageScrollView.viewForRowAtIndex(i) as! VoiceRecordSampleCell
            cells.append(cell)
            
        }
        
        return cells
    }
    
    
    private func updateView(view: UIView, withProgress progress: CGFloat) {
        
        let size:CGFloat = 25
        
        var transform = CGAffineTransformIdentity
        // scale
        let scale = (1.4 - 0.3 * (fabs(progress)))
        
        transform = CGAffineTransformScale(transform, scale, scale)
        
        // translate
        var translate = size / 4 * progress
        if progress > 1 {
            translate = size / 4
        }
        else if progress < -1 {
            translate = -size / 4
        }
        transform = CGAffineTransformTranslate(transform, translate, 0)
        
        view.transform = transform
        
    }
    
    private func currentCenter(scrollView: UIScrollView) -> CGPoint {
        let bounds = self.pageScrollView.bounds
        let x = scrollView.contentOffset.x + CGRectGetWidth(bounds) / 2.0
        let y = scrollView.contentOffset.y
        return CGPointMake(x, y)
    }


}
