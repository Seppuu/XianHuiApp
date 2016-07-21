//
//  switchCell.swift
//  DingDong
//
//  Created by Seppuu on 16/5/23.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit

class SegmentCell: UITableViewCell {

    @IBOutlet weak var permissionSegment: UISegmentedControl!
    
    var segmentChangeHandler:((selectedIndex:Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func segmentTap(sender: UISegmentedControl) {
        
        segmentChangeHandler?(selectedIndex:sender.selectedSegmentIndex)
        
    }
    
    
}
