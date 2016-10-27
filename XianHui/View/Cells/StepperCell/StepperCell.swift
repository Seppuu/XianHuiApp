//
//  StepperCell.swift
//  XianHui
//
//  Created by jidanyu on 16/8/24.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import ValueStepper

class StepperCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var stepperView: ValueStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
