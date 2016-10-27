//
//  CustomerCardView.swift
//  XianHui
//
//  Created by jidanyu on 16/8/22.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class CustomerCardView: UIView {
    
    //navbar
    @IBOutlet weak var navBarView: UIView!
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var buttonsContainerView: UIView!
    
    @IBOutlet weak var phoneButton: UIImageView!
    @IBOutlet weak var chatButton: UIImageView!
    @IBOutlet weak var otherButton: UIImageView!
    
    @IBOutlet weak var bottomContainer: UIView!
    
    @IBOutlet weak var leftTag: UILabel!
    @IBOutlet weak var middleTag: UILabel!
    @IBOutlet weak var rightTag: UILabel!
    
    @IBOutlet weak var leftTextLabel: UILabel!
    @IBOutlet weak var middleTextLabel: UILabel!
    @IBOutlet weak var rightTextLabel: UILabel!
    
    var backButtonHandler:(()->())?
    
    class func instanceFromNib() -> CustomerCardView {
        
        return UINib(nibName: "CustomerCard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomerCardView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let imageViewArray = [avatarImageView,phoneButton,chatButton,otherButton]
        
        for imageView in imageViewArray {
            imageView?.layer.cornerRadius = (imageView?.ddWidth)!/2
            imageView?.layer.masksToBounds = true
            imageView?.contentMode = .scaleAspectFit
        }
        
        //add line
        let frame0 = CGRect(x:screenWidth/3, y: 10, width: 1, height: bottomContainer.ddHeight - 10*2)
        let line0 = UIView(frame: frame0)
        line0.backgroundColor = UIColor ( red: 0.8539, green: 0.8539, blue: 0.8539, alpha: 1.0 )
        
        bottomContainer.addSubview(line0)
        
        let frame1 = CGRect(x: (screenWidth/3) * 2, y: 10, width: 1, height: bottomContainer.ddHeight - 10*2)
        let line1 = UIView(frame: frame1)
        line1.backgroundColor = UIColor ( red: 0.8539, green: 0.8539, blue: 0.8539, alpha: 1.0 )
        
        bottomContainer.addSubview(line1)
        
        
        //add backImageView tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(CustomerCardView.backImageViewTap))
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tap)
        
    }
    
    func backImageViewTap() {
        
        backButtonHandler?()
    }
    
}


















