//
//  UITableView+DD.swift
//  XianHui
//
//  Created by Seppuu on 16/8/3.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    
    
    func scrollToBottom(_ animated: Bool) {
        var y: CGFloat = 0.0
        
        if self.contentSize.height > bounds.size.height {
            y = self.contentSize.height - bounds.size.height
        }
        self.setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
}
