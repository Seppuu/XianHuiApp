//
//  VoiceRecordSampleView.swift
//  Yep
//
//  Created by nixzhu on 15/11/25.
//  Copyright © 2015年 Catch Inc. All rights reserved.
//

import UIKit
import SnapKit


class VoiceRecordSampleCell: UIView {
    
    var shapeView = UIView()

    var value: Float = 0 {
        didSet {
            if value != oldValue {
                setNeedsLayout()
               addShapeView()
            }
        }
    }
    
    var color = UIColor(red: 200.3/255.0, green: 170.2/255.0, blue: 122.5/255.0, alpha: 1.0) {
        didSet {
            changeShapeColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor ( red: 0.8576, green: 0.6678, blue: 0.9987, alpha: 0.0 )
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addShapeView() {
        
        let height = self.bounds.size.height
        let width = self.bounds.size.width
        var valueHeight = height * CGFloat(value)
        shapeView = UIView()
        shapeView.backgroundColor = color
        
        if valueHeight < width {
            
            valueHeight = width
            
        }

        self.addSubview(shapeView)
    
        shapeView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(valueHeight)
        }
        
        
        shapeView.layer.cornerRadius = width/2
        shapeView.layer.masksToBounds = true
        
        
    }
    
    func changeShapeColor() {
        
        shapeView.backgroundColor = color
    }
    
    override func draw(_ rect: CGRect) {

//        let context = UIGraphicsGetCurrentContext()
//
//        CGContextSetStrokeColorWithColor(context, color.CGColor)
//        CGContextSetLineWidth(context, bounds.width)
//        CGContextSetLineCap(context, .Round)
//
//        let x = bounds.width / 2
//        let height = bounds.height
//        let valueHeight = height * CGFloat(value) + 6
//        let offset = (height - valueHeight) / 2
//
//       // print("分贝值:\(value)")
//        
//        
//        //这里的是波形样式是中间点对称.
//        CGContextMoveToPoint(context, x, height - offset)
//        CGContextAddLineToPoint(context, x, height - valueHeight - offset)
//        
//        //这里的波形样式是从底部开始,显示一半.
////        CGContextMoveToPoint(context, x, height  )
////        CGContextAddLineToPoint(context, x, height - valueHeight)
//
//        CGContextStrokePath(context)
    }
}



