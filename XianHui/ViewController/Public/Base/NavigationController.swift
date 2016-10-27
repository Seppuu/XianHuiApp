//
//  NavigationController.swift
//  MeiBu
//
//  Created by Seppuu on 16/7/13.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.isTranslucent = true
        self.navigationBar.barTintColor = UIColor.navBarColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }


}
