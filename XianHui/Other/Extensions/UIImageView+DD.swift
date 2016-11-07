//
//  UIImageView+DD.swift
//  XianHui
//
//  Created by jidanyu on 2016/11/7.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    class func xhAccessoryView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "Disclosure Indicator"))
        
        return imageView
    }
    
    class func xhAccessoryViewClear() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "Disclosure Indicator Clear"))
        
        return imageView
    }
    
    
}
