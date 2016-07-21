//
//  CountDownView.swift
//  DingDong
//
//  Created by Seppuu on 16/6/1.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit

class CountDownView: UIView {
    
    
    @IBOutlet weak var countLabel: UILabel!
    
    var countDownComplete:(()->())?
    
    class func instanceFromNib() -> CountDownView {
        
        return UINib(nibName: "CountDown", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! CountDownView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
    var countNumber = 3 {
        didSet {
            
            UIView.animateWithDuration(0.3) { 
                self.countLabel.text = String(self.countNumber)
            }
        }
    }
    
    var timer = NSTimer()
    
    @objc private func beginCount() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CountDownView.count), userInfo: nil, repeats: true)
    }
    
    
    func show(time:Int) {
        countNumber = time
        self.transform = CGAffineTransformMakeScale(3.5, 3.5)
        UIView.animateWithDuration(0.7, delay: 0,
                                   usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 3,
                                   options: .CurveEaseInOut,
                                   animations: {
                                    self.transform = CGAffineTransformMakeScale(1.0, 1.0)
                                    self.alpha = 1.0
        }){ (success) in
           self.beginCount()
        }
    }
    
    
    @objc private func count() {
        
        if countNumber == 0 {
            timer.invalidate()
            self.transform = CGAffineTransformIdentity
            
            UIView.animateWithDuration(0.7, delay: 0,
                                       usingSpringWithDamping: 0.7,
                                       initialSpringVelocity: 3,
                                       options: .CurveEaseInOut,
                                       animations: {
                                        self.transform = CGAffineTransformMakeScale(3.5, 3.5)
                                        self.alpha = 0.0
            }){ (success) in
                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }

            countDownComplete?()
            
            return
        }
        countNumber -= 1
        
    }

}
