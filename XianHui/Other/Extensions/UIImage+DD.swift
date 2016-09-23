//
//  UIImage+DD.swift
//  DingDong
//
//  Created by Seppuu on 16/4/6.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func alpha(value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        CGContextScaleCTM(ctx!, 1, -1)
        CGContextTranslateCTM(ctx!, 0, -area.size.height)
        CGContextSetBlendMode(ctx!, .Multiply)
        CGContextSetAlpha(ctx!, value);
        CGContextDrawImage(ctx!, area, self.CGImage!);
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context!, color.CGColor)
        CGContextFillRect(context!, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    

    
}

