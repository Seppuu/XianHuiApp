//
//  formCell.swift
//  DingDong
//
//  Created by Seppuu on 16/5/23.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit

class formCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var leftTextField: UITextField!
    
    var endEditHandler:((textField: UITextField)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }
    
    
    @IBAction func textFieldEndEdit(sender: UITextField) {
        
        endEditHandler?(textField:sender)
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
