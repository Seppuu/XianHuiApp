//
//  chatSectionView.swift
//  XianHui
//
//  Created by jidanyu on 16/8/23.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class chatSectionView: UIView {

    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    @IBOutlet weak var firstTagView: UIView!

    @IBOutlet weak var sectionTagView: UIView!
    
    @IBOutlet weak var firsTagLabel: UILabel!
    
    @IBOutlet weak var secondTagLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    class func instanceFromNib() -> chatSectionView {
        
        return UINib(nibName: "chatSectionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! chatSectionView
    }
    
    override func didMoveToSuperview() {
        makeUI()
    }
    
    func makeUI() {
        
        firstTagView.layer.cornerRadius = firstTagView.ddWidth/2
        firstTagView.layer.masksToBounds = true
        firstTagView.backgroundColor = UIColor ( red: 0.4941, green: 0.8275, blue: 0.1294, alpha: 1.0 )
        
        sectionTagView.layer.cornerRadius = firstTagView.ddWidth/2
        sectionTagView.layer.masksToBounds = true
        sectionTagView.backgroundColor = UIColor ( red: 0.1598, green: 0.4719, blue: 0.8529, alpha: 1.0 )
        
    }
}
