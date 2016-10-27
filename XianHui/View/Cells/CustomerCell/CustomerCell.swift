//
//  CustomerCell.swift
//  XianHui
//
//  Created by jidanyu on 16/8/21.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class CustomerCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var stageLabel: UILabel!
    
    @IBOutlet weak var happyLevel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
