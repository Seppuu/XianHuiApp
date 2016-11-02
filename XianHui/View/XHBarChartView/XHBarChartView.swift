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
            let fmt = NumberFormatter()
            fmt.numberStyle = .decimal
            let numString = fmt.string(from: NSNumber(value: num))
            
            numsString.append(numString!)
        }
        
        return numsString

    }
    
    var listOfNumber2 = [Float]()
    
    var listOfDateString = [String]()
    
    var currentPageChangedHandler:((_ index:Int)->())?
    
    override func layoutSubviews() {
        
        topLabel.textColor = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        topLabel.text = listOfNumber.last
        topLabel.textAlignment = .center
        addSubview(topLabel)
        topLabel.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.pageScrollView.snp.top)
        }
        
        topLabel.text = listOfNumber.last
        
        dateLabel.textColor = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        dateLabel.text = listOfNumber.last
        dateLabel.textAlignment = .left
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(21)
        }
        
        dateLabel.text = listOfDateString.last
        
        
        rightLabel01.textColor = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        rightLabel01.font = UIFont.systemFont(ofSize: 12)
        
        let str01 = String(currentMonthAvgVaule)
        
        rightLabel01.text = "当月平均:" + str01
        rightLabel01.textAlignment = .right
        addSubview(rightLabel01)
        rightLabel01.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(self).offset(10)
            make.width.equalTo(self)
            make.height.equalTo(21)
        }
        
        
        rightLabel02.textColor = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        rightLabel02.font = UIFont.systemFont(ofSize: 12)
        let str02 = String(currentMonthAvgVaule)
        rightLabel02.text = "当月累计:" + str02
        rightLabel02.textAlignment = .right
        addSubview(rightLabel02)
        rightLabel02.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(rightLabel01.snp.bottom).offset(10)
            make.width.equalTo(self)
            make.height.equalTo(21)
        }
        
        
    }
    
    
    func setScrollView() {
        
        
        pageScrollView.frame = CGRect(x: (screenWidth - 50)/2 , y: ddHeight * 0.25, width: 50, height: ddHeight * 0.5)
        pageScrollView.delegate = self
        pageScrollView.dataSource = self
        pageScrollView.padding = 25;
        pageScrollView.leftRightOffset = 0
        
    }
    
    func moveToLastPage() {
        
        self.pageScrollView.moveToPage(at: listOfNumber.count - 1, animeted: false)
        guard let cell = self.pageScrollView.viewForRow(at: listOfNumber.count - 1) as? VoiceRecordSampleCell else {return}
        cell.color = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
    }

    func numberOfPage(in pageScrollView: OTPageScrollView!) -> Int {
        
        return listOfNumber.count
    }
    
    func pageScrollView(_ pageScrollView: OTPageScrollView!, viewForRowAt index: Int32) -> UIView! {
        
        let view = VoiceRecordSampleCell(frame: CGRect(x: 0, y: 0, width: 25, height: ddHeight * 0.5))
        let item = Int(index)
        var val = listOfNumber2[item]
        
        if val == 0 {
            //如果数值是0.加一点.防止UI界面消失
            val = 0.01
        }
        var maxValueNeedUpdate = false
        
        if (val / maxValue) > 1.0 {
            val = maxValue
            
            maxValueNeedUpdate = true
        }
        
        if maxValueNeedUpdate == true {
            NotificationCenter.default.post(name: NeedUpdateMaxValueNoti, object: nil)
        }
        else {
            NotificationCenter.default.post(name: NoNeedUpdateMaxValueNoti, object: nil)
        }
        
        view.value = val / maxValue
        
        view.color = UIColor ( red: 0.8275, green: 0.7216, blue: 0.5529, alpha: 1.0 )
        
        return view
        
    }
    
    func sizeCell(for pageScrollView: OTPageScrollView!) -> CGSize {
        
        return CGSize(width: 25, height: ddHeight * 0.5)
    }
    
    func pageScrollView(_ pageScrollView: OTPageScrollView!, didTapPageAt index: Int) {
        
        currentPageChangedHandler?(index)
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        updateColor(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        currentPageChangedHandler?(index)
        
    }
    
    func updateColor(_ scrollView:UIScrollView) {
        
        for index in 0..<listOfNumber.count {
            let cell = self.pageScrollView.viewForRow(at: index) as! VoiceRecordSampleCell
            cell.color = UIColor ( red: 0.8275, green: 0.7216, blue: 0.5529, alpha: 1.0 )
        }
        
        let index = scrollView.contentOffset.x / scrollView.frame.size.width
        guard let cell = self.pageScrollView.viewForRow(at: Int(index)) as? VoiceRecordSampleCell else {return}
        cell.color = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        
        topLabel.text = listOfNumber[Int(index)]
        
        dateLabel.text = listOfDateString[Int(index)]
    }
    
    func updateProgress(_ scrollView: UIScrollView) {
        
        let currentCenterX = currentCenter(scrollView).x
        let bounds = self.pageScrollView.bounds
        
        for view in allTopCell() {
            
            let progress = (view.center.x - currentCenterX) / bounds.width * CGFloat(1)
            updateView(view, withProgress: progress)
        }
        
    }
    
    func allTopCell() -> [VoiceRecordSampleCell] {
        
        var cells = [VoiceRecordSampleCell]()
        
        for i in 0..<listOfNumber.count {
            
            let cell = self.pageScrollView.viewForRow(at: i) as! VoiceRecordSampleCell
            cells.append(cell)
            
        }
        
        return cells
    }
    
    
    fileprivate func updateView(_ view: UIView, withProgress progress: CGFloat) {
        
        let size:CGFloat = 25
        
        var transform = CGAffineTransform.identity
        // scale
        let scale = (1.4 - 0.3 * (fabs(progress)))
        
        transform = transform.scaledBy(x: scale, y: scale)
        
        // translate
        var translate = size / 4 * progress
        if progress > 1 {
            translate = size / 4
        }
        else if progress < -1 {
            translate = -size / 4
        }
        transform = transform.translatedBy(x: translate, y: 0)
        
        view.transform = transform
        
    }
    
    fileprivate func currentCenter(_ scrollView: UIScrollView) -> CGPoint {
        let bounds = self.pageScrollView.bounds
        let x = scrollView.contentOffset.x + bounds.width / 2.0
        let y = scrollView.contentOffset.y
        return CGPoint(x: x, y: y)
    }


}
