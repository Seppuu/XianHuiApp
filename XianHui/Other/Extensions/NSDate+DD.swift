//
//  NSDate+DD.swift
//  XianHui
//
//  Created by 鲁莹 on 2016/9/27.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    static func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        let date = formatter.string(from: Date())
        return date
    }
    
}
