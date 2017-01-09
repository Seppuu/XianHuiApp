//
//  BaseNavigationController.swift
//  XianHui
//
//  Created by jidanyu on 2016/11/4.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import Kingfisher

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationBar.isTranslucent = true
        self.navigationBar.barTintColor = UIColor.navBarColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barStyle = .black
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
        
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }


}
