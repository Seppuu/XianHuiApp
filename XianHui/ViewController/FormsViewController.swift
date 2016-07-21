//
//  FormsViewController.swift
//  MeiBu
//
//  Created by Seppuu on 16/7/11.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SnapKit
import Charts
import PageMenu
import LGFilterView
import SwiftString

class FormsViewController: BaseViewController,CAPSPageMenuDelegate {
    
    var topView = SubscriptionTopView()
    var collectionView:UICollectionView!
    let cellID = "SubscriptionDetailCell"
    
    var pageMenu : CAPSPageMenu?
    var chartTitleLabel = UILabel()
    var titleButton = UIButton()
    var titlesArray = ["顾问","技师","店长"]
    
    var filterView:LGFilterView!
    var dateTypesArray = ["当日","当周","当月"]
    
    var dateFilterView:LGFilterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubView()
        
        setBarItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    let pageMenuParameters: [CAPSPageMenuOption] = [
        .MenuItemSeparatorWidth(0.0),
        .ScrollMenuBackgroundColor(UIColor.whiteColor()),
        .ViewBackgroundColor(UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)),
        .BottomMenuHairlineColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.1)),
        .SelectionIndicatorColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
        .MenuMargin(20.0),
        .MenuHeight(40.0),
        .SelectedMenuItemLabelColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
        .UnselectedMenuItemLabelColor(UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)),
        .MenuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
        .UseMenuLikeSegmentedControl(true),
        .MenuItemSeparatorRoundEdges(false),
        .SelectionIndicatorHeight(2.0),
        .MenuItemSeparatorPercentageHeight(0.1)
    ]
    
    func setSubView() {
        
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        
        let controller1 = PieChartViewController()
        
        controller1.parentNavigationController = self.navigationController
        controller1.title = "员工"
        controllerArray.append(controller1)
        
        let controller2 = LineChartViewController()
        controller2.title = "金额"
        controller2.parentNavigationController = self.navigationController
        controllerArray.append(controller2)
        
        let controller3 = PieChartViewController()
        controller3.title = "项目"
        controller3.parentNavigationController = self.navigationController
        controllerArray.append(controller3)
        
        let controller4 = PieChartViewController()
        controller4.title = "产品"
        controller4.parentNavigationController = self.navigationController
        controllerArray.append(controller4)
        
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 64, self.view.frame.width, self.view.frame.height - 64), pageMenuOptions: pageMenuParameters)
        
        // Optional delegate
        pageMenu!.delegate = self
        
        
        self.view.addSubview(pageMenu!.view)
        
    }
    
    func updatePageMenuWith(tabArry:[String]) {
        
        pageMenu?.view.removeFromSuperview()
        
        pageMenu = nil
        
        
    }
    
    var rightBarItem = UIBarButtonItem()
    
    func setBarItem() {
        
        let arrowImage = UIImage(named: "Arrow")
        
        titleButton.backgroundColor = UIColor.clearColor()
        titleButton.tag = 0
        titleButton.setTitle(titlesArray[0], forState: .Normal)
        titleButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        titleButton.setImage(arrowImage, forState: .Normal)
        
        titleButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4)
        titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4)
        
        titleButton.addTarget(self, action: #selector(FormsViewController.titleFilter(_:)), forControlEvents: .TouchUpInside)
        titleButton.sizeToFit()
        
        self.navigationItem.titleView = titleButton
        
        setupFilterViewsWithTransitionStyle(.Top)
        
        rightBarItem = UIBarButtonItem(title: dateTypesArray[0], style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FormsViewController.dataFilterTap(_:)))
        navigationItem.rightBarButtonItem = rightBarItem
        
        setDateFilterViewWithTransitionStyle(.Top)
    }
    
    func setupFilterViewsWithTransitionStyle(style:LGFilterViewTransitionStyle) {
        
        filterView = LGFilterView(titles: titlesArray, actionHandler: { (filter, title, index) in
            
            self.titleButton.titleLabel?.text = title
            
            }, cancelHandler: nil)
        
        filterView.transitionStyle = style
        filterView.numberOfLines = 0
        
    
        let isStatusBarHidden = UIApplication.sharedApplication().statusBarHidden
        let statusBarHeight   = isStatusBarHidden ? 0 : UIApplication.sharedApplication().statusBarFrame.size.height
        
        let topInset = (self.navigationController?.navigationBar.ddHeight)! +  statusBarHeight
        
//        let version = UIDevice.currentDevice().systemVersion.toFloat()!
//        
//        if version < 7.0 {
//            topInset = 0
//        }
        
        
        if (filterView.transitionStyle == .Top){
            filterView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0)
            filterView.offset = CGPointZero
        }
        
        
    }
    
    func setDateFilterViewWithTransitionStyle(style:LGFilterViewTransitionStyle) {
        
        dateFilterView = LGFilterView(titles: dateTypesArray, actionHandler: { (filter, title, index) in
            
            //TODO:更换日期范围
            self.rightBarItem.title = title
            
            }, cancelHandler: nil)
        
        dateFilterView.transitionStyle = style
        dateFilterView.numberOfLines = 0
        
        
        let isStatusBarHidden = UIApplication.sharedApplication().statusBarHidden
        let statusBarHeight   = isStatusBarHidden ? 0 : UIApplication.sharedApplication().statusBarFrame.size.height
        
        let topInset = (self.navigationController?.navigationBar.ddHeight)! +  statusBarHeight
        
        if (dateFilterView.transitionStyle == .Top){
            dateFilterView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0)
            dateFilterView.offset = CGPointZero
        }
    }
    
    func dataFilterTap(sender:UIBarButtonItem) {
        
        if dateFilterView.showing == false {
            
            dateFilterView.showInView(view, animated: true, completionHandler: nil)
        }
        else {
            dateFilterView.dismissAnimated(true, completionHandler: nil)
        }
    }
    
    func titleFilter(button:UIButton) {
        
        if filterView.showing == false {
            
            filterView.showInView(view, animated: true, completionHandler: nil)
        }
        else {
            filterView.dismissAnimated(true, completionHandler: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

