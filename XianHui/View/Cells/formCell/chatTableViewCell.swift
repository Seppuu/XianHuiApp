//
//  chatTableViewCell.swift
//  XianHui
//
//  Created by jidanyu on 16/8/23.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class chatTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var tagView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        tagView.layer.cornerRadius = tagView.ddWidth/2
        tagView.layer.masksToBounds = true
    }
    
}
