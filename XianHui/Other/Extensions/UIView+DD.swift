//
//  UIView+DD.swift
//  DingDong
//
//  Created by Seppuu on 16/3/15.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    /// Shortcut for frame.size.width
    var ddWidth :CGFloat {
        
        return self.frame.size.width
    }
    
    /// Shortcut for frame.size.height
    var ddHeight :CGFloat {
        
        return self.frame.size.height
    }
    
    
    /// Shortcut for frame.origin.x
    var ddBoundsWidth :CGFloat {
        
        return self.bounds.size.width
    }
    
    /// Shortcut for frame.origin.y
    var ddBoundsHeight :CGFloat {
        
        return self.bounds.size.height
    }
    
    //增加边框虚线
    func addDashedBorder(_ strokeColor: UIColor, lineWidth: CGFloat) {
        self.layoutIfNeeded()
        let strokeColor = strokeColor.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = kCALineJoinRound
        
        shapeLayer.lineDashPattern = [5,5] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height: shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath

        self.layer.addSublayer(shapeLayer)
    }
    
}
