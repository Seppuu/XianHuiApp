//
//  ChannelCell.swift
//  DingDong
//
//  Created by Seppuu on 16/5/31.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {
    
    
    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftImageView.contentMode = .scaleAspectFill
        leftImageView.layer.cornerRadius = 8
        leftImageView.layer.masksToBounds = true
        leftImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
