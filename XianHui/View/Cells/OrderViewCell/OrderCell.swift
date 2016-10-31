//
//  OrderCell.swift
//  XianHui
//
//  Created by jidanyu on 2016/10/5.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    
    
    @IBOutlet weak var firstLabel: UILabel!
   
    @IBOutlet weak var rightLabel: UILabel!

    
    @IBOutlet weak var secondLabel: UILabel!
    
    
    @IBOutlet weak var thirdLabel: UILabel!
    
    @IBOutlet weak var forthlabel: UILabel!
    
    @IBOutlet weak var fifthLabel: UILabel!
    
    @IBOutlet weak var sixthLabel: UILabel!
    
    
    
    
    @IBOutlet weak var secondRightLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
