//
//  UserNameCell.swift
//  XianHui
//
//  Created by Seppuu on 16/7/28.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class UserNameCell: UITableViewCell,UITextFieldDelegate {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubviews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    var textField:UITextField! = nil
    
    var codeButton:UIButton! = nil
    
    var codeButtonTapHandler:(()->())?
    
    var textFieldDidTapHandler:((text:String)->())?
    
    func setSubviews() {
        
        textField = UITextField()
        textField.font = UIFont.systemFontOfSize(14)
        addSubview(textField)
        textField.snp_makeConstraints { (make) in
            make.top.right.bottom.equalTo(self)
            make.left.equalTo(self).offset(15)
        }
        textField.addTarget(self, action: #selector(UserNameCell.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        textField.delegate = self
        
        codeButton = UIButton()
        addSubview(codeButton)
        codeButton.snp_makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(120)
        }
        
        codeButton.setTitle("发送验证码", forState: .Normal)
        codeButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        codeButton.backgroundColor = UIColor ( red: 0.2937, green: 0.6186, blue: 1.0, alpha: 1.0 )
        codeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        codeButton.addTarget(self, action: #selector(UserNameCell.codeButtonTap(_:)), forControlEvents: .TouchUpInside)
    }
    
    
    func codeButtonTap(sender:UIButton) {
        
        codeButtonTapHandler?()
    }
    
    
    
    func textFieldDidChange(textField: UITextField) {
        
        textFieldDidTapHandler?(text:textField.text!)
    }
}
