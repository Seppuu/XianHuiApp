//
//  InfoView.swift
//  DingDong
//
//  Created by Seppuu on 16/4/21.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit
import Ruler

class InfoView: UIView {
    
    var info: String?
    
    private var infoLabel: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    convenience init(_ info: String? = nil) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 240))
        
        self.info = info
    }
    
    func makeUI() {
        
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.textColor = UIColor.lightGrayColor()
        
        self.infoLabel = label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        let views = [
            "label": label
        ]
        
        let constraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-margin-[label]-margin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["margin": Ruler.iPhoneHorizontal(20, 40, 40).value], views: views)
        let constraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        
        NSLayoutConstraint.activateConstraints(constraintsH)
        NSLayoutConstraint.activateConstraints(constraintsV)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        infoLabel?.text = info
    }
}


