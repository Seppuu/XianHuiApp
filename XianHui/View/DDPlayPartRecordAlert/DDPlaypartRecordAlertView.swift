//
//  DDPlaypartRecordAlertView.swift
//  DingDong
//
//  Created by Seppuu on 16/3/25.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit
import SnapKit

class DDPlaypartRecordAlertView: UIView {
    
    var timeTextLabel = UILabel()
    var imageView = UIImageView()
    var countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10.0
        self.backgroundColor = UIColor.whiteColor()
        self.layer.masksToBounds = true
        self.layer.shadowOpacity = 0.7
        self.layer.shadowColor = UIColor ( red: 0.6445, green: 0.6445, blue: 0.6445, alpha: 1.0 ).CGColor
        self.layer.shadowOffset = CGSizeMake(0, -4)
        self.layer.shadowRadius = 10
    }
    
    override func didMoveToSuperview() {
         super.didMoveToSuperview()
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeUI() {
        addSubview(timeTextLabel)
        timeTextLabel.snp_makeConstraints { (make) -> Void in
            make.left.top.right.equalTo(self)
            make.height.equalTo(30)
        }
        
        timeTextLabel.textAlignment = .Center
        timeTextLabel.font = UIFont.systemFontOfSize(15)
        timeTextLabel.textColor = UIColor.blackColor()
        timeTextLabel.text = "00:00/00:00"
        
        addSubview(imageView)
        imageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(timeTextLabel.snp_bottom)
            make.left.right.bottom.equalTo(self)
        }
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        
        
        addSubview(countLabel)
        countLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.top.bottom.equalTo(imageView)
        }
        
        countLabel.textAlignment = .Center
        countLabel.textColor = UIColor.whiteColor()
        countLabel.backgroundColor = UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1953125 )
        countLabel.font = UIFont.systemFontOfSize(100)
        
    }
    
    
    func changeImageViewImage(toImage:UIImage,imageIndex:Int) {
        
        //渐变隐藏imageview,更换图片,渐变显示imageview
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.imageView.alpha = 0.0
            
            }) { (success) -> Void in
            
                self.imageView.image = toImage
                
                UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    
                    self.imageView.alpha = 1.0
                    self.countLabel.text = "\(imageIndex)"
                    }, completion: nil)
            
        }
        
//        self.imageView.image = toImage
//        self.countLabel.text = "\(imageIndex)"
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    

}
