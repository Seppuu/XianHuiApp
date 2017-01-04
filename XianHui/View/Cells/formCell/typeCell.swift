//
//  typeCell.swift
//  DingDong
//
//  Created by Seppuu on 16/5/23.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit

class typeCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var dotView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        dotView.layer.masksToBounds = true
        dotView.layer.cornerRadius = 5
        
        dotView.alpha = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
