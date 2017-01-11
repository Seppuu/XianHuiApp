//
//  UserCentreVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/28.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

import Proposer
import Kingfisher
import MBProgressHUD
import SwiftyJSON

let HistoryNoti = "HistoryNoti"
let LessonsLikedNoti = "LessonsLikedNoti"
let FeedBackNoti = "FeedBackNoti"
let CertificateNoti = "CertificateNoti"
let UserAvatarUpdatedNoti = "UserAvatarUpdatedNoti"


class UserCentreVC: BaseViewController {
    
    var userTableView: UITableView!
    
    fileprivate let AddUserAvatarCell = "UserAvatarCell"
    
    fileprivate let UserAvatarEditCellId = "UserAvatarEditCell"
    
    fileprivate let logOutCellId = "SingleTapCell"
    
    fileprivate var editUserInfo = false
    
    fileprivate var uploadingAvatar = false
    
    var section1 = [String]()
    
    var section2 = [String]()

    var agentId:Int?
    
    fileprivate var imageUploading = UIImage()
    
    fileprivate lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "设置"
        
        section1 = ["账号管理","修改密码"]
        
        section2 = ["问题反馈","关于闲惠"]
        
        setTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserCentreVC.changeAllContacts), name: NSNotification.Name(rawValue: accountHasChangedNoti), object: nil)
    }
    
    func setTableView() {
        
        var frame = view.bounds
        frame.size.height -= 20

        userTableView = UITableView(frame: frame, style: .grouped)
        view.addSubview(userTableView)
        
        userTableView.delegate = self
        userTableView.dataSource = self
        
        userTableView.register(UINib(nibName: AddUserAvatarCell, bundle: nil), forCellReuseIdentifier: AddUserAvatarCell)
        userTableView.register(UINib(nibName: UserAvatarEditCellId, bundle: nil), forCellReuseIdentifier: UserAvatarEditCellId)
        userTableView.register(UINib(nibName: logOutCellId, bundle: nil), forCellReuseIdentifier: logOutCellId)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func changeAllContacts() {
        userTableView.reloadData()
    }
    
    
    func showPasswordAlert() {
        let title = "验证原密码"
        let message = "为了保障您的数据安全,修改密码前请填写原密码"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
            textField.isSecureTextEntry = true
        }
        
        let passWordTextField = alert.textFields?.first!
        
        
        let cancelButton = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        
        
        let submitButton = UIAlertAction(title: "确认", style: .default) { (action) in
            
            let password = passWordTextField?.text
            
            self.checkPassword(with: password!)
            
        }
        
        alert.addAction(submitButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func checkPassword(with password:String) {
        
        let userName = Defaults.currentAccountName.value
        let hud = showHudWith(view, animated: true, mode: .indeterminate, text: "")
        NetworkManager.sharedManager.verifyUserPassWordWith(userName!, usertype: .Employee, passWord: password, completion: { (success, json, error) in
            
            if success == true {
                
                hud.hide(true)
                
                let vc = UpdatePassWordVC()
                vc.title = "修改密码"
                self.navigationController?.pushViewController(vc, animated: true)            }
            else {
                hud.labelText = error!
                hud.hide(true, afterDelay: 1.0)
            }
            
        })
        
    }
    
    
    func showWrongAlert() {
        
        let title = "提示"
        let message = "密码错误，请重新输入。如果忘记密码，可以联系管理员在电脑端进行修改。"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let submitButton = UIAlertAction(title: "确认", style: .default) { (action) in
            
            self.showPasswordAlert()
            
        }
        
        alert.addAction(submitButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension UserCentreVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 1{
            return section1.count
        }
        else {
            return section2.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).section == 0 {
            return 98
        }
        else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            //用户信息,编辑,展示切换
            //let user = User.currentUser()
            
            let cell = tableView.dequeueReusableCell(withIdentifier: AddUserAvatarCell) as! UserAvatarCell
            let user = User.currentUser()
            cell.nameLabel.text = user?.displayName
            cell.levelTextLabel.text = user?.orgName
            
            if uploadingAvatar {
                
                cell.complete()
                cell.dimView.alpha = 0.3
                cell.hudView.alpha = 1.0
                if let url = URL(string: (user?.avatarURL)!) {
                    cell.avatarView.kf.setImage(with: url)
                }
                cell.hudView.startAnimating()
                
            }
            
            if !self.uploadingAvatar {
                cell.dimView.alpha = 0.0
                cell.hudView.alpha = 0.0
                cell.hudView.stopAnimating()
                if let url = URL(string: (user?.avatarURL)!) {
                   cell.avatarView.kf.setImage(with: url)
                }
                
                
            }
            
            cell.avatarTapHandler = { (cell) in
                self.avatarTap()
            }
            
            cell.editTapHandler =  {
                cell.firstNameField.text = "名"
                cell.secondNameField.text = "姓"
                
            }
            
            cell.cancelTapHandler = {
               
            }
            
            cell.nameNoneHandler = {
                
                DDAlert.alert(title: "提示", message: "请输入完整姓名", dismissTitle: "OK", inViewController: self, withDismissAction: nil)
            }
            
            return cell
            
        }
        else if indexPath.section == 1 {
            
            let cellID = "cellIDs1"
            let cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
            cell.selectionStyle = .none

            cell.textLabel?.text = section1[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
            
        }
        else {
            let cellID = "cellIDs2"
            let cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
            cell.selectionStyle = .none
            
            cell.textLabel?.text = section2[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let vc = AccountManagerVC()
                vc.title = "账号管理"
                navigationController?.pushViewController(vc, animated: true)
                
            }
            else if indexPath.row == 1 {
                
                //TODO:输入现有密码.
                showPasswordAlert()
                
            }
            
        }
        else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                //问题反馈
                let vc = FeedBackViewController()
                vc.title = "问题反馈"
                navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 1 {
                //关于本App
                let vc = AboutAppViewController()
                vc.title = "关于闲惠"
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension UserCentreVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func avatarTap() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //选择照片
        let choosePhotoAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("图库", comment: ""), style: .default) { action -> Void in
            
            let openCameraRoll: ProposerAction = { [weak self] in
                
                guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                    self?.alertCanNotAccessCameraRoll()
                    return
                }
                
                if let strongSelf = self {
                    strongSelf.imagePicker.sourceType = .photoLibrary
                    strongSelf.present(strongSelf.imagePicker, animated: true, completion: nil)
                }
            }
            
            proposeToAccess(.photos, agreed: openCameraRoll, rejected: {
                self.alertCanNotAccessCameraRoll()
            })
        }
        alertController.addAction(choosePhotoAction)
        
        //拍照
        let takePhotoAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("相机", comment: ""), style: .default) { action -> Void in
            
            let openCamera: ProposerAction = { [weak self] in
                
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    self?.alertCanNotOpenCamera()
                    return
                }
                
                if let strongSelf = self {
                    strongSelf.imagePicker.sourceType = .camera
                    strongSelf.present(strongSelf.imagePicker, animated: true, completion: nil)
                }
            }
            
            proposeToAccess(.camera, agreed: openCamera, rejected: {
                self.alertCanNotOpenCamera()
            })
        }
        alertController.addAction(takePhotoAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .cancel) { action -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        // touch to create (if need) for faster appear
        delay(0.2) { [weak self] in
            self?.imagePicker.hidesBarsOnTap = false
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        //save image to local and back
        self.uploadingAvatar = true
        self.imageUploading = image
        self.userTableView.reloadData()
        
        User.saveAvatarWith(image) { (success) in
            
            if success == true {
                self.uploadingAvatar = false
                self.userTableView.reloadData()
                NotificationCenter.default.post(name: Notification.Name(rawValue: UserAvatarUpdatedNoti), object: nil)
            }
            else {
                
            }
        }
    }
}

