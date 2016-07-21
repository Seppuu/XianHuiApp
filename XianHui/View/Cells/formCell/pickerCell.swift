//
//  pickerCell.swift
//  DingDong
//
//  Created by Seppuu on 16/5/23.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit

class pickerCell: UITableViewCell {

    
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    var defaultRow = 0
    
    var dateChangeHandler:((date:NSDate)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func dateValueChanged(sender: UIDatePicker) {
        
        dateChangeHandler?(date:sender.date)
    }
    
}
