//
//  CheckBoxCell.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/29.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class CheckBoxCell: UITableViewCell {
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var rightButton: UIButton!

    var rightButtonTapHandler:(()->())?
    
    var isChecked = false {
        didSet {
            if isChecked == true {
                checkImageView.image = UIImage(named: "checkBox_checked")
            }
            else {
                checkImageView.image = UIImage(named: "checkBox_uncheck")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        rightButton.addTarget(self, action: #selector(CheckBoxCell.rightButtonTap), for: .touchUpInside)
        
        rightButton.layer.cornerRadius = 8
        rightButton.layer.masksToBounds = true
        
        rightButton.layer.borderColor = UIColor ( red: 0.0, green: 0.4868, blue: 0.9191, alpha: 1.0 ).cgColor
        rightButton.layer.borderWidth = 1.0
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func rightButtonTap() {
        rightButtonTapHandler?()
    }
}
