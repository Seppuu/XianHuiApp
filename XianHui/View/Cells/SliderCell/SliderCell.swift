//
//  SliderCell.swift
//  XianHui
//
//  Created by jidanyu on 2016/10/13.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class SliderCell: UITableViewCell {
    
    
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!

    @IBOutlet weak var rightLabel: UILabel!
    
    var min:Float = 0.0 {
        didSet {
            slider.minimumValue = min
        }
    }
    
    var max:Float = 0.0 {
        didSet {
            slider.maximumValue = max
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    var step: Float = 1
    
    var unit = ""
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        rightLabel.text = String(sender.value) + unit
        
    }
    
}
