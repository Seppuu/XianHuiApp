//
//  GoodCell.swift
//  XianHui
//
//  Created by jidanyu on 16/8/26.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class GoodCell: UITableViewCell {
    
    
    @IBOutlet weak var cardTypeImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    var showDetailHandler:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        cardTypeImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(GoodCell.showDetailView))
        cardTypeImageView.addGestureRecognizer(tap)
        
//        nameLabel.userInteractionEnabled = true
//        let tap2 = UITapGestureRecognizer(target: self, action: #selector(GoodCell.showDetailView))
//        nameLabel.addGestureRecognizer(tap2)
        
    }
    
    
    func showDetailView () {
        showDetailHandler?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
