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

class XHBarChartView: OTPageView ,OTPageScrollViewDataSource,OTPageScrollViewDelegate {
    
    var topLabel = UILabel()
    
    var rightLabel01 = UILabel()
    
    var rightLabel02 = UILabel()
    
    var maxValue:Float = 20000
    
    var listOfNumber = ["1","4,232","12,313","11,233","7,777","8,466","3,456"]
    
    var listOfNumber2 = ["1","4232","12313","11233","7777","8466","3456"]
    
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
        
        
        rightLabel01.textColor = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        rightLabel01.font = UIFont.systemFontOfSize(12)
        rightLabel01.text = "当月平均:8K"
        rightLabel01.textAlignment = .Right
        addSubview(rightLabel01)
        rightLabel01.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(self).offset(10)
            make.width.equalTo(self)
            make.height.equalTo(21)
        }
        
        
        rightLabel02.textColor = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        rightLabel02.font = UIFont.systemFontOfSize(12)
        rightLabel02.text = "当月累计:250K"
        rightLabel02.textAlignment = .Right
        addSubview(rightLabel02)
        rightLabel02.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
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

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func numberOfPageInPageScrollView(pageScrollView: OTPageScrollView!) -> Int {
        
        return listOfNumber.count
    }
    
    func pageScrollView(pageScrollView: OTPageScrollView!, viewForRowAtIndex index: Int32) -> UIView! {
        
        let view = VoiceRecordSampleCell(frame: CGRect(x: 0, y: 0, width: 25, height: ddHeight * 0.5))
        let item = Int(index)
        let val = listOfNumber2[item].toFloat()!
        
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
        //updateProgress(scrollView)
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
    }
    
    func updateProgress(scrollView: UIScrollView) {
        
        let currentCenterX = currentCenter(scrollView).x
        let bounds = self.pageScrollView.bounds
        
        for view in allTopCell() {
            
            //let visibleViewCount = topPageView.pageScrollView.visibleCell.count
            
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
