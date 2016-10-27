//
//  CustomerLargeCell.swift
//  XianHui
//
//  Created by jidanyu on 16/9/5.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class CustomerLargeCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var vipLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = 60/2
        avatarImageView.layer.masksToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
