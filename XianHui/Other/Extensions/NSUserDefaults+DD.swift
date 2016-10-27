//
//  NSUserDefaults+DD.swift
//  XianHui
//
//  Created by jidanyu on 16/9/20.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation


let isFirstLaunch = UserDefaults.isFirstLaunch()
//Put the following in NSUserDefaults+isFirstLaunch.swift

extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "FirstLaunchFlag"
        let isFirstLaunch = UserDefaults.standard.string(forKey: firstLaunchFlag) == nil
        if (isFirstLaunch) {
            UserDefaults.standard.set("false", forKey: firstLaunchFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
