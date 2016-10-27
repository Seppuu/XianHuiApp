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
    
    
    var buttonTapHandler:((_ index:Int)->())?
    
    var buttons = [UIButton]()

    override func awakeFromNib() {
        super.awakeFromNib()
        buttons = [FirstButton,secondButton,thirdButton,forthButton]
        buttons.forEach { (button) in
            button.backgroundColor = UIColor.clear
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func FirstButtonTap(_ sender: UIButton) {
        buttonTapHandler?(0)
    }
    
    @IBAction func secondButtonTap(_ sender: UIButton) {
        buttonTapHandler?(1)
    }
    
    @IBAction func thirdButtonTap(_ sender: UIButton) {
        buttonTapHandler?(2)
    }
    
    @IBAction func forthButtonTap(_ sender: UIButton) {
        buttonTapHandler?(3)
    }
    
  
    
    
    
    
}
