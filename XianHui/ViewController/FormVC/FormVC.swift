//
//  FormVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/22.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SnapKit
import Charts
import PageMenu
import SwiftString

class FormVC: UIViewController,CAPSPageMenuDelegate {
    
    var topView = SubscriptionTopView()
    var collectionView:UICollectionView!
    let cellID = "SubscriptionDetailCell"
    
    var pageMenu : CAPSPageMenu?
    var chartTitleLabel = UILabel()
    var titleButton = UIButton()
    var titlesArray = ["顾问","技师","店长"]
    
    var dateTypesArray = ["当日","当周","当月"]
    
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
        .ViewBackgroundColor(UIColor(red: 254.9/255.0, green: 251.4/255.0, blue: 243.7/255.0, alpha: 1.0)),
        .BottomMenuHairlineColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.1)),
        .SelectionIndicatorColor(UIColor(red: 96.4/255.0, green: 80.8/255.0, blue: 81.2/255.0, alpha: 1.0)),
        .MenuMargin(20.0),
        .MenuHeight(40.0),
        .SelectedMenuItemLabelColor(UIColor(red: 96.4/255.0, green: 80.8/255.0, blue: 81.2/255.0, alpha: 1.0)),
        .UnselectedMenuItemLabelColor(UIColor(red: 116.7/255.0, green: 96.1/255.0, blue: 97.2/255.0, alpha: 1.0)),
        .MenuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
        .UseMenuLikeSegmentedControl(true),
        .MenuItemSeparatorRoundEdges(false),
        .SelectionIndicatorHeight(2.0),
        .MenuItemSeparatorPercentageHeight(0.1)
    ]
    
    func setSubView() {
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1 = RadarChartVC()
        
        controller1.parentNavigationController = self.navigationController
        controller1.title = "分析"
        controllerArray.append(controller1)
        
        let controller2 = PieChartViewController()
        controller2.title = "现金"
        controller2.parentNavigationController = self.navigationController
        controllerArray.append(controller2)
        
        let controller3 = PieChartViewController()
        controller3.title = "实操"
        controller3.parentNavigationController = self.navigationController
        controllerArray.append(controller3)
        
        let controller4 = PieChartViewController()
        controller4.title = "产品"
        controller4.parentNavigationController = self.navigationController
        controllerArray.append(controller4)
        
        let controller5 = PieChartViewController()
        controller5.title = "客流"
        controller5.parentNavigationController = self.navigationController
        controllerArray.append(controller5)
        
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 64, self.view.frame.width, self.view.frame.height - 64), pageMenuOptions: pageMenuParameters)
        
        // Optional delegate
        pageMenu!.delegate = self
        pageMenu?.controllerScrollView.scrollEnabled = false
        
        self.view.addSubview(pageMenu!.view)
        
    }
    
    func updatePageMenuWith(tabArry:[String]) {
        
        pageMenu?.view.removeFromSuperview()
        
        pageMenu = nil
        
    }
    
    var rightBarItem = UIBarButtonItem()
    
    func setBarItem() {
        
        rightBarItem = UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FormVC.settingTap(_:)))
        navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    
    func settingTap(sender:UIBarButtonItem) {
        
        let vc = FormSettingVC()
        vc.title = "设置"
        
        navigationController?.pushViewController(vc, animated: true)
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
