//
//  UserAvatarCell.swift
//  DingDong
//
//  Created by Seppuu on 16/5/20.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit

class UserAvatarCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var hudView: UIActivityIndicatorView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var firstNameField: BorderTextField!

    @IBOutlet weak var secondNameField: BorderTextField!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var cameraImageView: UIImageView!
    
    @IBOutlet weak var levelTextLabel: UILabel!
    
    var isEditting = false
    
    var isUpLoading = false
    
    var avatarTapHandler:((cell:UserAvatarCell)->())?
    
    var cancelEdit = false {
        didSet {
            if cancelEdit == true {
                cancelTapHandler?()
            }
        }
    }
    
    var editTapHandler:(()->())?
    
    var cancelTapHandler:(()->())?
    
    var confirmTapHandler:((firstName:String,secondName:String)->())?
    
    var nameNoneHandler:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarView.layer.cornerRadius = avatarView.ddWidth/2
        avatarView.contentMode = .ScaleAspectFill
        avatarView.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserAvatarCell.avatarTap))
        cameraImageView.userInteractionEnabled = true
        cameraImageView.addGestureRecognizer(tap)
        
        dimView.layer.cornerRadius = dimView.ddWidth/2
        dimView.layer.masksToBounds = true
        
        dimView.alpha = 0.0
        
        firstNameField.alpha = 0.0
        secondNameField.alpha = 0.0
        
        cancelButton.alpha = 0.0
        
        cameraImageView.alpha = 0.0
        
        self.selectionStyle = .None
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func avatarTap() {
        
        avatarTapHandler?(cell: self)
    }
    
    
    func changeState(edit:Bool) {
        
        if edit {
            avatarView.userInteractionEnabled = true
            UIView.animateWithDuration(0.2, animations: {
                self.nameLabel.alpha = 0.0
                self.levelTextLabel.alpha = 0.0
                self.editButton.setTitle("完成", forState: .Normal)
                
                self.cancelButton.alpha = 1.0
                
                self.dimView.alpha = 0.3
                self.cameraImageView.alpha = 1.0
                
                }, completion: { (success) in
                    
                   UIView.animateWithDuration(0.2, animations: { 
                    
                    self.firstNameField.alpha = 1.0
                    self.secondNameField.alpha = 1.0
                    
                   })
                    
                    self.editTapHandler?()
                    
            })
            
        }
        else {
            
            avatarView.userInteractionEnabled = false
            UIView.animateWithDuration(0.2, animations: {
                self.firstNameField.alpha = 0.0
                self.secondNameField.alpha = 0.0
                
                self.cancelButton.alpha = 0.0
                
                self.dimView.alpha = 0.0
                self.cameraImageView.alpha = 0.0
                
                }, completion: { (success) in
                    
                    if self.cancelEdit  == false {
                        guard self.checkFiled() else {
                            
                            self.nameNoneHandler?()
                            
                            return
                        }
                        
                        let first = self.firstNameField.text
                        let second = self.secondNameField.text
                        self.confirmTapHandler?(firstName:first!,secondName:second!)
                    }
                    else {
                        
                    }
                    
                    
                    UIView.animateWithDuration(0.2, animations: {
                        
                        self.nameLabel.alpha = 1.0
                        self.levelTextLabel.alpha = 1.0
                        self.editButton.setTitle("编辑", forState: .Normal)
                        
                    })
            })
        }
    }
    
    
    @IBAction func editTap(sender: UIButton) {
        
        isEditting = !isEditting
        cancelEdit = false
        changeState(isEditting)
        
        self.endEditing(true)
    }
    
    func complete() {
        
        isEditting = false
        cancelEdit = false
        changeState(isEditting)
        
        self.endEditing(true)
    }
    
    
    @IBAction func cancelTap(sender: UIButton) {
        
        isEditting = false
        cancelEdit = true
        changeState(isEditting)
        
        self.endEditing(true)
    }
    
    
    private func checkFiled() -> Bool {
        
        if firstNameField.text == "" || secondNameField.text == "" {
            
            return false
        }
        else {
            return true
        }
    }
    
    
    
    
    
    
}
