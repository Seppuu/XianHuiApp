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
import SwiftString

class PieCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PieChartViewController: BaseChartViewController {
    
    var topPageView:OTPageView!
    
    var bottomCollectionView:UICollectionView!
    
    var pageControl:UIPageControl!
    
    var pieTypelabel:UILabel!
    
    var topLabel:UILabel!
    
    var tableView:UITableView!
    
    var dataOfPieChart = ["张芳芳","李华","陈蕾","徐天天","吴悦"]
    
    var listOfNumber = ["2,341","4,232","12,313","11,233","7,777","8,466","3,456"]
    
    var listOfNumber2 = ["2341","4232","12313","11233","7777","8466","3456"]
    
    var pieChartTopConstraint:Constraint? = nil
    
    var tableViewTopConstraint:Constraint? = nil
    
    var cellID = "CertificateCell"
    
    let pieCellID = "Piecell"
    
    var pieType = ["业绩组成","顾问业绩","客户级别"]
    
    let viewHeight = ( screenHeight - 64 - 44 )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        topPageView = OTPageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: viewHeight * 0.4))
        topPageView.clipsToBounds = true
        topPageView.pageScrollView.dataSource = self
        topPageView.pageScrollView.delegate = self
        topPageView.pageScrollView.padding = 25;
        topPageView.pageScrollView.leftRightOffset = 0
        topPageView.pageScrollView.frame = CGRectMake( (screenWidth - 50)/2 , viewHeight * 0.1, 50, viewHeight * 0.2)
        topPageView.backgroundColor = UIColor ( red: 0.9294, green: 0.8941, blue: 0.8392, alpha: 1.0 )
        view.addSubview(topPageView)
        
        
        topLabel = UILabel()
        topLabel.textColor = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        topLabel.text = listOfNumber.last
        topLabel.textAlignment = .Center
        topPageView.addSubview(topLabel)
        topLabel.snp_makeConstraints { (make) in
            make.width.equalTo(screenWidth)
            make.centerX.equalTo(topPageView)
            make.bottom.equalTo(topPageView.pageScrollView.snp_top)
        }
        
        
        topPageView.pageScrollView.reloadData()
        topPageView.pageScrollView.moveToPageAt(listOfNumber.count - 1, animeted: false)
        let cell = topPageView.pageScrollView.viewForRowAtIndex(listOfNumber.count - 1) as! VoiceRecordSampleCell
        cell.color = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        
        topLabel.text = listOfNumber.last
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSizeMake(screenWidth, viewHeight * 0.6)
        
        
        bottomCollectionView = UICollectionView(frame: CGRect(x: 0, y: topPageView.ddHeight, width: screenWidth, height: viewHeight * 0.6), collectionViewLayout: layout)
        
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.bounces = false
        bottomCollectionView.showsHorizontalScrollIndicator = false
        bottomCollectionView.pagingEnabled = true
        bottomCollectionView.registerClass(PieCell.self, forCellWithReuseIdentifier:pieCellID )
        
        view.addSubview(bottomCollectionView)
        
        
        //page control
        pageControl = UIPageControl(frame: CGRect(x: 0, y: topPageView.ddHeight, width: screenWidth, height: 40))
        view.addSubview(pageControl)
        
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor ( red: 0.8275, green: 0.7216, blue: 0.5529, alpha: 1.0 )
        pageControl.pageIndicatorTintColor = UIColor ( red: 0.949, green: 0.902, blue: 0.8196, alpha: 1.0 )
        pageControl.numberOfPages = 3
        
        
        pieTypelabel = UILabel(frame: CGRect(x: 0, y:pageControl.frame.origin.y + pageControl.ddHeight, width: screenWidth, height: 20))
        pieTypelabel.textAlignment = .Center
        pieTypelabel.textColor = UIColor ( red: 0.4549, green: 0.3922, blue: 0.3922, alpha: 1.0 )
        pieTypelabel.text = pieType[0]
        view.addSubview(pieTypelabel)
        
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
    
}

extension PieChartViewController: ChartViewDelegate {
    
    func updatePieChartData(pieView:PieChartView) -> [String?]{
        
        return  setDataCountWith(3, range: 10,pieView:pieView)
    }
    
    func setDataCountWith(count:Int,range:Double,pieView:PieChartView) -> [String?] {
        
        let mult = range
        
        var yVals1 = [BarChartDataEntry]()
        
        for i in 0..<count {
            
            let val  = Double(arc4random_uniform(UInt32(mult))) + mult/4
            
            let chartDataEntry = BarChartDataEntry(value: val, xIndex: i)
            
            yVals1.append(chartDataEntry)
        }
        
        var xVals = [String?]()
        
        var xvs = [String?]()
        
        for i in 0..<count {
            
            let str = parties[i % parties.count]
            xVals.append(str)
            xvs.append(str)
            
        }
        
        let dataSet = PieChartDataSet(yVals: yVals1, label: "分布结果")
        
        let colors = [
            UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 ),
            UIColor ( red: 0.8715, green: 0.7948, blue: 0.6786, alpha: 1.0 ),
            UIColor ( red: 0.7855, green: 0.6676, blue: 0.4805, alpha: 1.0 ),
            UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 ),
            UIColor ( red: 0.897, green: 0.609, blue: 0.4544, alpha: 1.0 ),
            UIColor ( red: 0.763, green: 0.4454, blue: 0.2472, alpha: 1.0 )
        ]
        
        dataSet.colors = colors
        
        let data = PieChartData(xVals: xVals, dataSet: dataSet)
        
        let pFormatter = NSNumberFormatter()
        pFormatter.numberStyle = .PercentStyle
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = ""
        data.setValueFormatter(pFormatter)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 11.0))
        data.setValueTextColor(UIColor.whiteColor())
        
        pieView.data = data
        
        return xvs
        
    }
    
    func moveSelectdSliceToVertical(pieView:PieChartView , index:Int) {
        
        let selcetPartDrawAngle = pieView.drawAngles[index]
        let selcetPartAbsoluteAngle = pieView.absoluteAngles[index]
        
        let toAngle = (270 - (selcetPartAbsoluteAngle - selcetPartDrawAngle/2))
        
        pieView.spin(duration: 0.5, fromAngle:pieView.rotationAngle, toAngle: toAngle, easingOption: .EaseInOutSine)
    }
    
    //MARK:ChartViewDelegate
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        
        let index = entry.xIndex
        guard let pieChartView = chartView as? PieChartView else {return}
        
        moveSelectdSliceToVertical(pieChartView, index: index)
    }
    
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        
        
    }

}

extension PieChartViewController:OTPageScrollViewDataSource,OTPageScrollViewDelegate {
    
    func numberOfPageInPageScrollView(pageScrollView: OTPageScrollView!) -> Int {
        if pageScrollView.superview == topPageView {
            return listOfNumber.count
        }
        else {
            return 3
        }
        
    }
    
    func pageScrollView(pageScrollView: OTPageScrollView!, viewForRowAtIndex index: Int32) -> UIView! {
        
        let view = VoiceRecordSampleCell(frame: CGRect(x: 0, y: 0, width: 25, height: viewHeight * 0.4))
        let item = Int(index)
        let val = listOfNumber2[item].toFloat()!
        view.color = UIColor ( red: 0.8275, green: 0.7216, blue: 0.5529, alpha: 1.0 )
        
        view.value = val / 20000
        
        return view

    }
    
    func sizeCellForPageScrollView(pageScrollView: OTPageScrollView!) -> CGSize {
        if pageScrollView.superview == topPageView {
            
            return CGSizeMake(25, viewHeight * 0.2)
        }
        else {
            return CGSizeMake(screenWidth, viewHeight * 0.6)
        }
        
    }
    
    func pageScrollView(pageScrollView: OTPageScrollView!, didTapPageAtIndex index: Int) {
        
        updatePieData(index)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
       // updateProgress(scrollView)
        if scrollView.superview == topPageView {
            
            updateColor(scrollView)
        }
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if scrollView == bottomCollectionView {
            let pageWidth = bottomCollectionView.ddWidth
            let currentpage = Int( bottomCollectionView.contentOffset.x / pageWidth )
            pageControl.currentPage = currentpage
            pieTypelabel.text = pieType[currentpage]
        }
        else {
            let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            updatePieData(index)
        }

    }
    
    func updatePieData(index:Int) {
        
        for i in 0..<pieType.count {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            guard  let cell = bottomCollectionView.cellForItemAtIndexPath(indexPath) as? PieCell else {return}
            
            guard let pieView = cell.viewWithTag(10) as? PieChartView else {return}
            
            updatePieChartData(pieView)
            
            pieView.animate(xAxisDuration: 1.0, easingOption: .EaseOutBack)
        }
        
    }
    
    func updateColor(scrollView:UIScrollView) {
        
        for index in 0..<listOfNumber.count {
            let cell = topPageView.pageScrollView.viewForRowAtIndex(index) as! VoiceRecordSampleCell
            cell.color = UIColor ( red: 0.8275, green: 0.7216, blue: 0.5529, alpha: 1.0 )
        }
        
        let index = scrollView.contentOffset.x / scrollView.frame.size.width
        guard let cell = topPageView.pageScrollView.viewForRowAtIndex(Int(index)) as? VoiceRecordSampleCell else {return}
        cell.color = UIColor ( red: 0.5216, green: 0.3765, blue: 0.2863, alpha: 1.0 )
        
        topLabel.text = listOfNumber[Int(index)]
    }
    
    func updateProgress(scrollView: UIScrollView) {
        
        let currentCenterX = currentCenter(scrollView).x
        let bounds = topPageView.pageScrollView.bounds
        
        for view in allTopCell() {
            
            //let visibleViewCount = topPageView.pageScrollView.visibleCell.count

            let progress = (view.center.x - currentCenterX) / CGRectGetWidth(bounds) * CGFloat(1)
            updateView(view, withProgress: progress)
        }
        
    }
    
    func allTopCell() -> [VoiceRecordSampleCell] {
        
        var cells = [VoiceRecordSampleCell]()
        
        for i in 0..<listOfNumber.count {
            
           let cell = topPageView.pageScrollView.viewForRowAtIndex(i) as! VoiceRecordSampleCell
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
        let bounds = topPageView.pageScrollView.bounds
        let x = scrollView.contentOffset.x + CGRectGetWidth(bounds) / 2.0
        let y = scrollView.contentOffset.y
        return CGPointMake(x, y)
    }
    
    
}

extension PieChartViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pieCellID, forIndexPath: indexPath) as! PieCell
        
        let pieChartView = PieChartView(frame: cell.contentView.bounds)
        pieChartView.tag = 10
        pieChartView.delegate = self
        
        pieChartView.backgroundColor = UIColor ( red: 1.0, green: 0.9882, blue: 0.9647, alpha: 1.0 )
        cell.addSubview(pieChartView)
        
        
        let labels = self.updatePieChartData(pieChartView)
        
        setupPieChartView(pieChartView)
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
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
