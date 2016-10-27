//
//  MyWorkCell.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/28.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class MyWorkCell: UITableViewCell {
    
    @IBOutlet weak var leftImageIView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var firstTagImageView: UIImageView!
    @IBOutlet weak var secondTagImageView: UIImageView!
    @IBOutlet weak var thirdTagImageView: UIImageView!
    
    
    @IBOutlet weak var firstTagLabel: UILabel!
    
    @IBOutlet weak var secondTagLabel: UILabel!
    
    @IBOutlet weak var thirdTagLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        let imageViews = [leftImageIView,firstTagImageView,secondTagImageView,thirdTagImageView]
        
        for imageView in imageViews {
            
            imageView?.contentMode = .scaleAspectFit
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
