//
//  progressCell.swift
//  XianHui
//
//  Created by jidanyu on 16/8/23.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import UAProgressView

class progressCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var progressView: UIView!
    
    var uaProgressView:UAProgressView!
    
    var progressLabel = UILabel()
    
    var tipLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressView.alpha = 0.0
        
        uaProgressView = UAProgressView()
        uaProgressView.frame = CGRect(x: screenWidth - 26 - 20, y: (ddHeight - 26)/2,  width: 26, height: 26)
        uaProgressView.lineWidth = 2.5
        //uaProgressView.setProgress(0.4, animated: true)
        addSubview(uaProgressView)
        
        progressLabel.frame = CGRect(x: 0, y: 0, width: uaProgressView.ddWidth, height: 8)
        progressLabel.textAlignment = .center
        progressLabel.textColor = UIColor ( red: 0.0, green: 0.4471, blue: 0.9961, alpha: 1.0 )
        progressLabel.font = UIFont.systemFont(ofSize: 10)
        
        uaProgressView.centralView = progressLabel
        uaProgressView.fillOnTouch = false
        
        
        tipLabel.frame = CGRect(x: screenWidth - 40 - 20, y: (ddHeight - 26)/2,  width: 40, height: 21)
        tipLabel.font = UIFont.systemFont(ofSize: 12)
        tipLabel.textColor = UIColor.lightGray
        tipLabel.text = "去设置"
        addSubview(tipLabel)
        tipLabel.alpha = 0.0
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
