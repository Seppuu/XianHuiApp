//
//  UserCentreVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/28.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftString
import Proposer
import Kingfisher
import MBProgressHUD

let HistoryNoti = "HistoryNoti"
let LessonsLikedNoti = "LessonsLikedNoti"
let FeedBackNoti = "FeedBackNoti"
let CertificateNoti = "CertificateNoti"
let UserAvatarUpdatedNoti = "UserAvatarUpdatedNoti"

class UserCentreVC: BaseViewController {
    
    var userTableView: UITableView!
    
    private let AddUserAvatarCell = "UserAvatarCell"
    
    private let UserAvatarEditCellId = "UserAvatarEditCell"
    
    private let logOutCellId = "SingleTapCell"
    
    private var editUserInfo = false
    
    private var uploadingAvatar = false
    
    let section1 = ["隐私与安全"]
//    let section2 = ["暂无","暂无"]
//    let section3 = ["暂无"]
    
    private var imageUploading = UIImage()
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "设置"
        
        setTableView()
        
    }
    
    func setTableView() {
        
        userTableView = UITableView(frame: view.bounds, style: .Grouped)
        view.addSubview(userTableView)
        
        userTableView.delegate = self
        userTableView.dataSource = self
        
        userTableView.registerNib(UINib(nibName: AddUserAvatarCell, bundle: nil), forCellReuseIdentifier: AddUserAvatarCell)
        userTableView.registerNib(UINib(nibName: UserAvatarEditCellId, bundle: nil), forCellReuseIdentifier: UserAvatarEditCellId)
        userTableView.registerNib(UINib(nibName: logOutCellId, bundle: nil), forCellReuseIdentifier: logOutCellId)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ViewHistory" {
            
        }
        else if segue.identifier == "LessonsLiked" {
            
        }
        
    }
    
}

extension UserCentreVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return section1.count
        }
//        else if section == 2 {
//            return section2.count
//        }
//        else if section == 3 {
//            return section3.count
//        }
        else {
            if editUserInfo == true {
                return 1
            }
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 98
        }
        else {
            return 40
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return tableView.sectionHeaderHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            //用户信息,编辑,展示切换
            //let user = User.currentUser()
            
            let cell = tableView.dequeueReusableCellWithIdentifier(AddUserAvatarCell) as! UserAvatarCell
            let user = User.currentUser()
            cell.nameLabel.text = user.name
            cell.levelTextLabel.text = "用户等级"
            
            if uploadingAvatar {
                
                cell.complete()
                cell.dimView.alpha = 0.3
                cell.hudView.alpha = 1.0
                cell.avatarView.image = imageUploading
                cell.hudView.startAnimating()
                
            }
            
            if !self.uploadingAvatar {
                cell.dimView.alpha = 0.0
                cell.hudView.alpha = 0.0
                cell.hudView.stopAnimating()
                let url = NSURL(string: user.avatarURL)!
                cell.avatarView.kf_setImageWithURL(url)
                
            }
            
            cell.avatarTapHandler = { (cell) in
                self.avatarTap()
            }
            
            cell.editTapHandler =  { [weak self] in
                cell.firstNameField.text = "名"
                cell.secondNameField.text = "姓"
                
                self?.insertLogOutCell()
                
            }
            
            cell.cancelTapHandler = { [weak self] in
                self?.removeLogOutCell()
            }
            
            cell.nameNoneHandler = {
                
                DDAlert.alert(title: "提示", message: "请输入完整姓名", dismissTitle: "OK", inViewController: self, withDismissAction: nil)
            }
            
            return cell
            
        }
        else if indexPath.section == 1 {
            //隐私与安全
            let cellID = "cellIDs1"
            let cell = UITableViewCell(style: .Default, reuseIdentifier: cellID)
            
            cell.textLabel?.text = section1[indexPath.row]
            cell.selectionStyle = .None
            return cell
        }
            
//        else if indexPath.section == 2 {
//            let cellID = "cellIDs2"
//            let cell = UITableViewCell(style: .Default, reuseIdentifier: cellID)
//            cell.imageView?.layer.cornerRadius = (cell.imageView?.ddWidth)!/2
//            cell.imageView?.layer.masksToBounds = true
//            cell.imageView?.backgroundColor = UIColor ( red: 1.0, green: 0.874, blue: 0.7309, alpha: 1.0 )
//            cell.textLabel?.text = section2[indexPath.row]
//            
//            cell.selectionStyle = .None
//            
//            return cell
//        }
//        else if indexPath.section == 3 {
//            let cellID = "cellIDs2"
//            let cell = UITableViewCell(style: .Default, reuseIdentifier: cellID)
//            cell.imageView?.layer.cornerRadius = (cell.imageView?.ddWidth)!/2
//            cell.imageView?.layer.masksToBounds = true
//            cell.imageView?.backgroundColor = UIColor ( red: 1.0, green: 0.874, blue: 0.7309, alpha: 1.0 )
//            cell.textLabel?.text = section3[indexPath.row]
//            
//            cell.selectionStyle = .None
//            
//            return cell
//        }
        else {
            //退出
            let cell = tableView.dequeueReusableCellWithIdentifier(logOutCellId, forIndexPath: indexPath) as! SingleTapCell
            
            cell.middleLabel.text = "退出"
            cell.middleLabel.textColor = UIColor.redColor()
            
            return cell
            
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            //认证
            let vc = MineVC()
            vc.title = "隐私与安全"
            navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.section == 0 {
            
        }
        else {
            
            if indexPath.row == 0 {
                //退出
                userLogOut()
            }
            
        }
    }
    
    
    private func insertLogOutCell() {
        
        self.editUserInfo = true
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 2)
        
        
        userTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    private func removeLogOutCell() {
        
        self.editUserInfo = false
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 2)
        
        
        userTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    private func userLogOut() {
        
        //先退出IM
        ChatKitExample.invokeThisMethodBeforeLogoutSuccess({
            
            self.logOutOwnUserSystem()
            
            }, failed: { (error) in
                //TODO:leanCloud IM 退出失败
                let hud = MBProgressHUD.showHUDAddedTo((self.view)!, animated: true)
                hud.mode = .Text
                hud.labelText = error.description
                
                hud.hide(true, afterDelay: 1.5)
        })
        
    }
    
    
    private func logOutOwnUserSystem() {
        
        let user = User.currentUser()
        user.logOut({ [weak self] (success,_,error) in
            if success {
                
                
                //show intro
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.showLoginVC()
                
            }
            else {
                let hud = MBProgressHUD.showHUDAddedTo((self?.view)!, animated: true)
                hud.mode = .Text
                hud.labelText = error
                
                hud.hide(true, afterDelay: 1.5)
            }
            })
    }
    
    
    
}

extension UserCentreVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func avatarTap() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        //选择照片
        let choosePhotoAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose Photo", comment: ""), style: .Default) { action -> Void in
            
            let openCameraRoll: ProposerAction = { [weak self] in
                
                guard UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) else {
                    self?.alertCanNotAccessCameraRoll()
                    return
                }
                
                if let strongSelf = self {
                    strongSelf.imagePicker.sourceType = .PhotoLibrary
                    strongSelf.presentViewController(strongSelf.imagePicker, animated: true, completion: nil)
                }
            }
            
            proposeToAccess(.Photos, agreed: openCameraRoll, rejected: {
                self.alertCanNotAccessCameraRoll()
            })
        }
        alertController.addAction(choosePhotoAction)
        
        //拍照
        let takePhotoAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .Default) { action -> Void in
            
            let openCamera: ProposerAction = { [weak self] in
                
                guard UIImagePickerController.isSourceTypeAvailable(.Camera) else {
                    self?.alertCanNotOpenCamera()
                    return
                }
                
                if let strongSelf = self {
                    strongSelf.imagePicker.sourceType = .Camera
                    strongSelf.presentViewController(strongSelf.imagePicker, animated: true, completion: nil)
                }
            }
            
            proposeToAccess(.Camera, agreed: openCamera, rejected: {
                self.alertCanNotOpenCamera()
            })
        }
        alertController.addAction(takePhotoAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { action -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        // touch to create (if need) for faster appear
        delay(0.2) { [weak self] in
            self?.imagePicker.hidesBarsOnTap = false
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        defer {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        //save image to local and back
        self.uploadingAvatar = true
        self.imageUploading = image
        self.userTableView.reloadData()
        
        User.saveAvatarWith(image) { (success) in
            
            if success == true {
                
                self.uploadingAvatar = false
                self.userTableView.reloadData()
                NSNotificationCenter.defaultCenter().postNotificationName(UserAvatarUpdatedNoti, object: nil)
            }
            else {
                
            }
            
        }
        
    }
}



















