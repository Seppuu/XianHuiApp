//
//  NSUserDefaults+DD.swift
//  XianHui
//
//  Created by jidanyu on 16/9/20.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation


let isFirstLaunch = NSUserDefaults.isFirstLaunch()
//Put the following in NSUserDefaults+isFirstLaunch.swift

extension NSUserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "FirstLaunchFlag"
        let isFirstLaunch = NSUserDefaults.standardUserDefaults().stringForKey(firstLaunchFlag) == nil
        if (isFirstLaunch) {
            NSUserDefaults.standardUserDefaults().setObject("false", forKey: firstLaunchFlag)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        return isFirstLaunch
    }
}