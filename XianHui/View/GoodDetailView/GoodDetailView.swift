//
//  GoodDetailView.swift
//  XianHui
//
//  Created by jidanyu on 16/8/26.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class GoodDetailView: UIView {

    
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var thirdLabel: UILabel!
    
    @IBOutlet weak var forthLabel: UILabel!
    
    
    @IBOutlet weak var detailContainer: UIView!
    
    
    @IBOutlet weak var firstDetailLabel: UILabel!
    
    @IBOutlet weak var secondDetailLabel: UILabel!
    
    @IBOutlet weak var thirdDetailLabel: UILabel!
    
    @IBOutlet weak var forthDetailLabel: UILabel!
    
    
    class func instanceFromNib() -> GoodDetailView {
        
        return UINib(nibName: "GoodDetail", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! GoodDetailView
    }
    
    override func didMoveToSuperview() {
        makeUI()
    }
    
    func makeUI() {
        
        firstLabel.text = "卡名"
        firstDetailLabel.text = "卡名A"
        
        secondLabel.text = "卡类型"
        secondDetailLabel.text = "多项卡"
        
        thirdLabel.text = "可用项目"
        thirdDetailLabel.text = "--"
        
        forthLabel.text = "余次"
        forthDetailLabel.text = "3"
        
    }
    
}
