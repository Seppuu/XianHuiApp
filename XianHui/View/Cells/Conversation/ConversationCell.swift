//
//  ConversationCell.swift
//  Yep
//
//  Created by NIX on 15/3/16.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit
import Kingfisher

class ConversationCell: UITableViewCell {
    
    var color: UIColor?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var progressView: GTProgressBar!
    
    @IBOutlet weak var unReadView: UIView!
    
    
    @IBOutlet weak var progressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        avatarImageView.contentMode = .scaleAspectFill
        
        progressView.progress = 0.4
        //progressView.backgroundColor = UIColor.orange
        progressView.barBorderColor = UIColor.clear
        progressView.barFillColor = UIColor.init(hexString: "1BD691")
        progressView.barBackgroundColor = UIColor.init(hexString: "236C51")
        progressView.barBorderWidth = 0.0
        progressView.barFillInset = 0.0
        progressView.labelTextColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressView.progressLabelInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        progressView.font = UIFont.boldSystemFont(ofSize: 18)
        progressView.barMaxHeight = 15
        progressView.displayLabel = false
        
        progressLabel.text = "\(Int(progressView.progress * 100))%"
        progressLabel.textColor = UIColor.init(hexString: "236C51")
        
        
        unReadView.layer.cornerRadius = unReadView.ddWidth/2
        unReadView.layer.masksToBounds = true
        unReadView.backgroundColor = UIColor.init(hexString: "FF5050")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.avatarImageView.layer.cornerRadius =  avatarImageView.ddWidth/2
        self.avatarImageView.layer.masksToBounds = true
    }


}

