//
//  GoodDetailContainerView.swift
//  XianHui
//
//  Created by jidanyu on 16/9/18.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class GoodDetailContainerView: UIView {

    
    @IBOutlet weak var firstLabel: UILabel!
    
    
    @IBOutlet weak var secondLabel: UILabel!
    
    
    @IBOutlet weak var thirdLabel: UILabel!
    
    
    @IBOutlet weak var forthLabel: UILabel!

    
    class func instanceFromNib() -> GoodDetailContainerView {
        
        return UINib(nibName: "GoodDetailContainer", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GoodDetailContainerView
    }
    
    override func didMoveToSuperview() {
        makeUI()
    }
    
    func makeUI() {
        
    }
    
}
