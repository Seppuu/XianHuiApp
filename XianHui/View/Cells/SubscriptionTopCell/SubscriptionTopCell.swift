//
//  SubscriptionTopCell.swift
//  DingDong
//
//  Created by Seppuu on 16/5/30.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubscriptionTopCell: UICollectionViewCell {

    
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var arrowTapHandler:(()->())?
    
    var authorTapHandler:((authorID:String,authorName:String)->())?
    
    var subView: SubscriptionTopView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subView = SubscriptionTopView.instanceFromNib()
        
        subView.authorCellTapHandler = { (authorID,authorName) in
            
            self.authorTapHandler?(authorID:authorID,authorName:authorName)
        }
        
        leftView.addSubview(subView)
        
        
        arrowImageView.backgroundColor = UIColor.whiteColor()
        let tap = UITapGestureRecognizer(target: self, action: #selector(SubscriptionTopCell.arrowTap))
        arrowImageView.userInteractionEnabled = true
        arrowImageView.addGestureRecognizer(tap)
    }
    
    func loadDataWith(list:[JSON]) {
        
        subView.collectionView.reloadData()
    }
    
    
    @objc private func arrowTap() {
        
        arrowTapHandler?()
        
    }
    
    
    
}
