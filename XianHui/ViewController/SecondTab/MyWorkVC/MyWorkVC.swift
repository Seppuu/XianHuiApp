//
//  MyWorkVC.swift
//  XianHui
//
//  Created by jidanyu on 16/8/21.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import PageMenu
import SnapKit

class MyWorkVC: BaseViewController,CAPSPageMenuDelegate {

    var pageMenu : CAPSPageMenu?
    
    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setSubView()
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
        
//        let controller1 = PlanningVC()
//        
//        controller1.parentNavigationController = self.navigationController
//        controller1.parentVC = self
//        controller1.title = "计划表"
//        controllerArray.append(controller1)
//        
//        let controller2 = ScheduleVC()
//        controller2.title = "预约表"
//        controller2.parentNavigationController = self.navigationController
//        controller2.parentVC = self
//        controllerArray.append(controller2)
        
        let controller1 = MyCustomerListVC()
        
        controller1.parentNavigationController = self.navigationController
        controller1.parentVC = self
        controller1.title = "客户"
        controller1.type = .Customer
        controllerArray.append(controller1)
        
        let controller2 = MyCustomerListVC()
        controller2.title = "同事"
        controller2.parentNavigationController = self.navigationController
        controller2.parentVC = self
        controller2.type = .Employee
        controllerArray.append(controller2)
        
        let controller3 = MyCustomerListVC()
        controller3.title = "项目"
        controller3.parentNavigationController = self.navigationController
        controller3.parentVC = self
        controller3.type = .Project
        controllerArray.append(controller3)
        
        let controller4 = MyCustomerListVC()
        controller4.title = "产品"
        controller4.parentNavigationController = self.navigationController
        controller4.parentVC = self
        controller4.type = .Production
        controllerArray.append(controller4)
        
        
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 64, self.view.frame.width, self.view.frame.height - 64), pageMenuOptions: pageMenuParameters)
        
        // Optional delegate
        pageMenu!.delegate = self
        pageMenu!.controllerScrollView.scrollEnabled = true
        
        pageMenu!.moveToPage(pageIndex)
        
        self.view.addSubview(pageMenu!.view)
        
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
