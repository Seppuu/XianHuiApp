//
//  HeplerCell.swift
//  XianHui
//
//  Created by Seppuu on 16/8/3.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class HeplerCell: UITableViewCell {

    @IBOutlet weak var pushTimeLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dayTimeLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )
        
        pushTimeLabel.backgroundColor = UIColor ( red: 0.747, green: 0.747, blue: 0.747, alpha: 1.0 )
        pushTimeLabel.textColor = UIColor.white
        
        backgroundColor = UIColor.clear
        
        layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
