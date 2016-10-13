//
//  FourButtonCell.swift
//  XianHui
//
//  Created by jidanyu on 2016/10/13.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class FourButtonCell: UITableViewCell {
    
    
    @IBOutlet weak var FirstButton: UIButton!
    
    @IBOutlet weak var secondButton: UIButton!
    
    @IBOutlet weak var thirdButton: UIButton!
    
    @IBOutlet weak var forthButton: UIButton!
    
    
    var buttonTapHandler:((index:Int)->())?
    
    var buttons = [UIButton]()

    override func awakeFromNib() {
        super.awakeFromNib()
        buttons = [FirstButton,secondButton,thirdButton,forthButton]
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func FirstButtonTap(sender: UIButton) {
        buttonTapHandler?(index:0)
    }
    
    @IBAction func secondButtonTap(sender: UIButton) {
        buttonTapHandler?(index:1)
    }
    
    @IBAction func thirdButtonTap(sender: UIButton) {
        buttonTapHandler?(index:2)
    }
    
    @IBAction func forthButtonTap(sender: UIButton) {
        buttonTapHandler?(index:3)
    }
    
  
    
    
    
    
}
