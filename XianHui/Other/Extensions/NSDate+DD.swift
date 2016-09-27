//
//  NSDate+DD.swift
//  XianHui
//
//  Created by 鲁莹 on 2016/9/27.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    
    class func currentDateString() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        let date = formatter.stringFromDate(NSDate())
        return date
    }
    
}
