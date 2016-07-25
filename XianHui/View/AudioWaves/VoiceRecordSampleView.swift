//
//  VoiceRecordSampleView.swift
//  Yep
//
//  Created by nixzhu on 15/11/25.
//  Copyright © 2015年 Catch Inc. All rights reserved.
//

import UIKit

class VoiceRecordSampleCell: UIView {

    var value: Float = 0 {
        didSet {
            if value != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    var color = UIColor(red: 171/255.0, green: 181/255.0, blue: 190/255.0, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()

        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextSetLineWidth(context, bounds.width)
        CGContextSetLineCap(context, .Round)

        let x = bounds.width / 2
        let height = bounds.height
        let valueHeight = height * CGFloat(value) + 6
        let offset = (height - valueHeight) / 2

       // print("分贝值:\(value)")
        
        
        //这里的是波形样式是中间点对称.
//        CGContextMoveToPoint(context, x, height - offset)
//        CGContextAddLineToPoint(context, x, height - valueHeight - offset)
        
        //这里的波形样式是从底部开始,显示一半.
        CGContextMoveToPoint(context, x, height  )
        CGContextAddLineToPoint(context, x, height - valueHeight)

        CGContextStrokePath(context)
    }
}



