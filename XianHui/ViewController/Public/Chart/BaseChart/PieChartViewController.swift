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

//TODO:移动到Model file
class XHChartData:NSObject {
    
    var x:String = ""
    var y:Double = 0.0
    
}

class PieChartViewController: BaseChartViewController {
    
    //顶部数组
    
    var currentMonthAvgVaule = 0
    
    var grandTotalValue = 0
    
    var numbers = [Int]()
    
    var listOfDateString = [String]()
    
    var topPageView:XHBarChartView!
    
    var bottomCollectionView:UICollectionView!
    
    var listOfChartDataArray = [[XHChartData]]()
    
    var animePieChart = false
    
    var pageControl:UIPageControl!
    
    //var pieTypelabel:UILabel!

    var tableView:UITableView!
    
    var dataOfPieChart = ["X","F","G","V","B"]
    
    var pieChartTopConstraint:Constraint? = nil
    
    var tableViewTopConstraint:Constraint? = nil
    
    var cellID = "CertificateCell"
    
    let pieCellID = "Piecell"
    
    //TODO:需要后端自动化 饼图类型
    var pieType = [String]()
    
    let viewHeight = ( screenHeight - 64)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //遇到含导航栏的ViewController，其第一个子试图是UIScrollView会自动产生64像素偏移
        //automaticallyAdjustsScrollViewInsets：是否根据按所在界面的navigationbar与tabbar的高度，自动调整scrollview的 inset。
        self.automaticallyAdjustsScrollViewInsets = false
        
        topPageView = XHBarChartView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: viewHeight * 0.5))
        
        topPageView.listOfNumber2 = numbers
        topPageView.listOfDateString = listOfDateString
        topPageView.currentMonthAvgVaule = currentMonthAvgVaule
        topPageView.grandTotalValue = grandTotalValue
        
        topPageView.clipsToBounds = true
        topPageView.setScrollView()
        topPageView.backgroundColor = UIColor(red: 0.9294, green: 0.8941, blue: 0.8392, alpha: 1.0)
        view.addSubview(topPageView)
        
        topPageView.pageScrollView.reloadData()
        
        topPageView.moveToLastPage()
        
        topPageView.currentPageChangedHandler = {
            (index) in
            self.updatePieData(index)
        }
        
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSizeMake(screenWidth, viewHeight * 0.5)
        
        
        bottomCollectionView = UICollectionView(frame: CGRect(x: 0, y: topPageView.ddHeight + 64, width: screenWidth, height: viewHeight * 0.5), collectionViewLayout: layout)
        
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.bounces = false
        bottomCollectionView.showsHorizontalScrollIndicator = false
        bottomCollectionView.pagingEnabled = true
        bottomCollectionView.registerClass(PieCell.self, forCellWithReuseIdentifier:pieCellID )
        
        view.addSubview(bottomCollectionView)
        
        
        //page control
        pageControl = UIPageControl(frame: CGRect(x: 0, y:screenHeight - 20, width: screenWidth, height: 20))
        view.addSubview(pageControl)
        
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor ( red: 0.8275, green: 0.7216, blue: 0.5529, alpha: 1.0 )
        pageControl.pageIndicatorTintColor = UIColor ( red: 0.949, green: 0.902, blue: 0.8196, alpha: 1.0 )
        pageControl.numberOfPages = listOfChartDataArray.count
        
//        
//        pieTypelabel = UILabel(frame: CGRect(x: 0, y:pageControl.frame.origin.y - 15 , width: screenWidth, height: 20))
//        pieTypelabel.textAlignment = .Center
//        pieTypelabel.font = UIFont.systemFontOfSize(12)
//        pieTypelabel.textColor = UIColor ( red: 0.4549, green: 0.3922, blue: 0.3922, alpha: 1.0 )
//        pieTypelabel.text = pieType[0]
//        view.addSubview(pieTypelabel)
        
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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}

extension PieChartViewController: ChartViewDelegate {
    
    func updatePieChartData(index:Int,pieView:PieChartView) {
        
        setDataCountWith(index, pieView: pieView)
    }
    
    func setDataCountWith(index:Int,pieView:PieChartView) {
        
        
        var yVals1 = [BarChartDataEntry]()
        
        
        for i in 0..<listOfChartDataArray[index].count {
            
            let val  = listOfChartDataArray[index][i].y
            
            let chartDataEntry = BarChartDataEntry(value: val, xIndex: i)
            
            yVals1.append(chartDataEntry)
        }
       
        var xVals = [String?]()
        
        //var xvs = [String?]()
        
        for chartData in listOfChartDataArray[index] {
            let str = chartData.x
            
            xVals.append(str)
          
        }

        
        let dataSet = PieChartDataSet(yVals: yVals1, label: "分布结果")
        dataSet.sliceSpace = 2.0
        
        var colors = [UIColor]()

        colors += ChartColorTemplates.vordiplom()
        colors += ChartColorTemplates.joyful()
        colors += ChartColorTemplates.colorful()
        colors += ChartColorTemplates.liberty()
        colors += ChartColorTemplates.pastel()
        colors += ChartColorTemplates.material()
        colors += [UIColor ( red: 0.0, green: 0.6426, blue: 0.9191, alpha: 1.0 )]

        dataSet.colors = colors
        
        let data = PieChartData(xVals: xVals, dataSet: dataSet)
        
        let pFormatter = NSNumberFormatter()
        pFormatter.numberStyle = .PercentStyle
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(pFormatter)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 11.0))
        data.setValueTextColor(UIColor ( red: 0.3078, green: 0.3078, blue: 0.3078, alpha: 1.0 ))
        
        pieView.data = data
        
        
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

extension PieChartViewController {
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.animePieChart = false
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pageWidth = bottomCollectionView.ddWidth
        let currentpage = Int( bottomCollectionView.contentOffset.x / pageWidth )
        pageControl.currentPage = currentpage
        
        //get cell with index
        let path = NSIndexPath(forItem: currentpage, inSection: 0)
        let cell = bottomCollectionView.cellForItemAtIndexPath(path) as! PieCell
        let pieChartView = cell.viewWithTag(10) as! PieChartView
        pieChartView.centerText = pieType[currentpage]
        
    }
    
    
    
    func updatePieData(index:Int) {
        
        animePieChart = true
        
        bottomCollectionView.reloadData()
    }
    
    
}

extension PieChartViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfChartDataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pieCellID, forIndexPath: indexPath) as! PieCell
        
        let pieChartView = PieChartView(frame: cell.contentView.bounds)
        pieChartView.tag = 10
        pieChartView.delegate = self
        
        pieChartView.backgroundColor = UIColor ( red: 0.9997, green: 0.9858, blue: 0.9558, alpha: 1.0 )
        pieChartView.centerText = pieType[indexPath.row]
        cell.addSubview(pieChartView)
        
        self.updatePieChartData(indexPath.row, pieView: pieChartView)
        setupPieChartView(pieChartView)
        if animePieChart == true {
            
            pieChartView.animate(xAxisDuration: 1.0, easingOption: .EaseOutBack)
            
        }
        else {
            
        }
        
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
