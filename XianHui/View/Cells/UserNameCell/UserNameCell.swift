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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    var textField:UITextField! = nil
    
    var codeButton:UIButton! = nil
    
    var codeButtonTapHandler:(()->())?
    
    var textFieldDidTapHandler:((_ text:String)->())?
    
    var textFieldDidReturnHandler:(()->())?
    
    func setSubviews() {
        
        textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(self)
            make.left.equalTo(self).offset(15)
        }
        textField.addTarget(self, action: #selector(UserNameCell.textFieldDidChange(_:)), for: .editingChanged)
        
        textField.delegate = self
        
        codeButton = UIButton()
        addSubview(codeButton)
        codeButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(120)
        }
        
        codeButton.setTitle("发送验证码", for: UIControlState())
        codeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        codeButton.backgroundColor = UIColor ( red: 0.2937, green: 0.6186, blue: 1.0, alpha: 1.0 )
        codeButton.setTitleColor(UIColor.white, for: UIControlState())
        
        codeButton.addTarget(self, action: #selector(UserNameCell.codeButtonTap(_:)), for: .touchUpInside)
    }
    
    
    func codeButtonTap(_ sender:UIButton) {
        
        codeButtonTapHandler?()
    }
    
    
    
    func textFieldDidChange(_ textField: UITextField) {
        
        textFieldDidTapHandler?(textField.text!)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textFieldDidReturnHandler?()
        
        return true
    }
    
    
    
    
    
}
