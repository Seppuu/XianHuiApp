//
//  checkBoxCellTableView.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/29.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import DLRadioButton

class checkBoxCell: UITableViewCell {
    
    
    @IBOutlet var checkButton: DLRadioButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var rightButton: UIButton!

    var rightButtonTapHandler:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rightButton.addTarget(self, action: #selector(checkBoxCell.rightButtonTap), forControlEvents: .TouchUpInside)
        
        rightButton.layer.cornerRadius = 8
        rightButton.layer.masksToBounds = true
        
        rightButton.backgroundColor = UIColor.DDBlueTextColor()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func rightButtonTap() {
        rightButtonTapHandler?()
    }
    
    
}
