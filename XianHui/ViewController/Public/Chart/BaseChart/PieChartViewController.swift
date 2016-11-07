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

let NeedUpdateMaxValueNoti = NSNotification.Name("NeedUpdateMaxValueNoti")

let NoNeedUpdateMaxValueNoti = NSNotification.Name("NoNeedUpdateMaxValueNoti")

class PieChartViewController: BaseChartViewController {
    
    //顶部数组
    
    var currentDayIndex = 0
    
    var currentMonthAvgVaule = 0
    
    var grandTotalValue = 0
    
    var numbers = [Float]()
    
    var listOfDateString = [String]()
    
    var topPageView:XHBarChartView!
    
    var bottomCollectionView:UICollectionView!
    
    var listOfChartDataArray = [ChartList]()
    
    var animePieChart = false
    
    var pageControl:UIPageControl!

    var tableView:UITableView!
    
    var dataOfPieChart = ["X","F","G","V","B"]
    
    var pieChartTopConstraint:Constraint? = nil
    
    var tableViewTopConstraint:Constraint? = nil
    
    var cellID = "CertificateCell"
    
    let pieCellID = "Piecell"
    
    //TODO:需要后端自动化 饼图类型
    var pieType = [String]()

    var maxType:MaxValueType = .cashMax
    
    let viewHeight = ( screenHeight - 64)
    
    var needUpdateMaxValue = false
    
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
        topPageView.maxType = maxType
        
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
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: screenWidth, height: viewHeight * 0.5)
        
        
        bottomCollectionView = UICollectionView(frame: CGRect(x: 0, y: topPageView.ddHeight + 64, width: screenWidth, height: viewHeight * 0.5), collectionViewLayout: layout)
        
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.bounces = false
        bottomCollectionView.showsHorizontalScrollIndicator = false
        bottomCollectionView.isPagingEnabled = true
        bottomCollectionView.register(PieCell.self, forCellWithReuseIdentifier:pieCellID )
        
        view.addSubview(bottomCollectionView)
        
        
        //page control
        pageControl = UIPageControl(frame: CGRect(x: 0, y:screenHeight - 20, width: screenWidth, height: 20))
        view.addSubview(pageControl)
        
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor ( red: 0.8275, green: 0.7216, blue: 0.5529, alpha: 1.0 )
        pageControl.pageIndicatorTintColor = UIColor ( red: 0.949, green: 0.902, blue: 0.8196, alpha: 1.0 )
        pageControl.numberOfPages = listOfChartDataArray[0].charts.count
        
        //tableViewSet
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        view.addSubview(tableView)
        
        let nib = UINib(nibName: cellID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        
        tableView.snp.makeConstraints{ (make) in
            make.left.right.equalTo(view)
            self.tableViewTopConstraint = make.top.equalTo(view).offset(64).constraint
            make.height.equalTo((screenHeight * 2)/5)
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableViewTopConstraint?.update(offset: -screenWidth)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}

extension PieChartViewController: ChartViewDelegate {
    
    func updatePieChartData(_ index:Int,pieView:PieChartView) {
        
        setDataCountWith(index, pieView: pieView)
    }
    
    func setDataCountWith(_ index:Int,pieView:PieChartView) {
        
        var yVals1 = [PieChartDataEntry]()
        
        //第几天的第几个类型的图表的数据集
        for i in 0..<listOfChartDataArray[currentDayIndex].charts[index].model.count {
            let model = listOfChartDataArray[currentDayIndex].charts[index].model[i]
           
            let chartDataEntry = PieChartDataEntry(value: model.y, label: model.x)
            
            yVals1.append(chartDataEntry)
        }

        
        let dataSet = PieChartDataSet(values: yVals1, label: "分布结果")
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
        
        let data = PieChartData(dataSets: [dataSet])
        //(xVals: xVals, dataSet: dataSet)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = " %"
        let iVFormatter = DefaultValueFormatter(formatter: pFormatter)
        data.setValueFormatter(iVFormatter)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 14.0))
        data.setValueTextColor(UIColor ( red: 0.3078, green: 0.3078, blue: 0.3078, alpha: 1.0 ))
        
        pieView.data = data
        
        
    }
    
    func moveSelectdSliceToVertical(_ pieView:PieChartView , index:Int) {
        
        let selcetPartDrawAngle = pieView.drawAngles[index]
        let selcetPartAbsoluteAngle = pieView.absoluteAngles[index]
        
        let toAngle = (270 - (selcetPartAbsoluteAngle - selcetPartDrawAngle/2))
        
        pieView.spin(duration: 0.5, fromAngle:pieView.rotationAngle, toAngle: toAngle, easingOption: .easeInOutSine)
    }
    
    //MARK:ChartViewDelegate
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
        
        let index = entry.x
        guard let pieChartView = chartView as? PieChartView else {return}
        
        moveSelectdSliceToVertical(pieChartView, index: Int(index))
    }
    
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
        
    }

}

extension PieChartViewController {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.animePieChart = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageWidth = bottomCollectionView.ddWidth
        let currentpage = Int( bottomCollectionView.contentOffset.x / pageWidth )
        pageControl.currentPage = currentpage
        
        //get cell with index
        let path = IndexPath(item: currentpage, section: 0)
        let cell = bottomCollectionView.cellForItem(at: path) as! PieCell
        let pieChartView = cell.viewWithTag(10) as! PieChartView
        pieChartView.centerText = pieType[currentpage]
        
    }
    
    
    
    func updatePieData(_ index:Int) {
        
        animePieChart = false
        currentDayIndex = index
        //TODO:更换数据
        
        bottomCollectionView.reloadData()
    }
    
    
}

extension PieChartViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfChartDataArray[currentDayIndex].charts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pieCellID, for: indexPath) as! PieCell
        
        let pieChartView = PieChartView(frame: cell.contentView.bounds)
        pieChartView.tag = 10
        pieChartView.delegate = self
        
        pieChartView.backgroundColor = UIColor ( red: 0.9997, green: 0.9858, blue: 0.9558, alpha: 1.0 )
        pieChartView.centerText = pieType[indexPath.row]
        cell.addSubview(pieChartView)
        
        self.updatePieChartData(indexPath.row, pieView: pieChartView)
        setupPieChartView(pieChartView)
        if animePieChart == true {
            
            pieChartView.animate(xAxisDuration: 1.0, easingOption: .easeOutBack)
            
        }
        else {
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}

extension PieChartViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataOfPieChart.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CertificateCell
        
        cell.accessoryView = UIImageView.xhAccessoryView()
        cell.leftLabel.text = dataOfPieChart[(indexPath as NSIndexPath).row]
        
        cell.rightLabel.text = "熟练"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = BaseViewController()
        vc.view.backgroundColor = UIColor.ddViewBackGroundColor()
        vc.title = dataOfPieChart[(indexPath as NSIndexPath).row]
        self.parentNavigationController?.pushViewController(vc, animated: true)
    }
    
}
