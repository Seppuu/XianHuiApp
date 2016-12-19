//
//  UpdatePassWordVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/12/19.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class UpdatePassWordVC: UIViewController {
    
    var tableView:UITableView!
    
    let remindCellId = "PassWordFieldCell"
    
    var newPassword = ""
    var confirmPassword = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.ddViewBackGroundColor()
        setTableView()
        setNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setNavBar() {
        
        let rightBar = UIBarButtonItem(title: "确认", style: .plain, target: self, action: #selector(UpdatePassWordVC.confirmTap))
        
        navigationItem.rightBarButtonItem = rightBar
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let path0 = IndexPath(item: 0, section: 0)
        let cell0 = tableView.cellForRow(at: path0) as! PassWordFieldCell
        cell0.rightField.becomeFirstResponder()
    }
    
    func confirmTap() {
        
        view.endEditing(true)
        
        let path0 = IndexPath(item: 0, section: 0)
        let cell0 = tableView.cellForRow(at: path0) as! PassWordFieldCell
        
        newPassword = cell0.rightField.text!
        
        
        let path1 = IndexPath(item: 1, section: 0)
        let cell1 = tableView.cellForRow(at: path1) as! PassWordFieldCell
        
        confirmPassword = cell1.rightField.text!
        
        if newPassword != confirmPassword {
    
            DDAlert.alert(title: "提示", message: "密码不一致", dismissTitle: "好的", inViewController: self, withDismissAction: nil)
            return
        }
        
        
        if newPassword == "" {
            
            DDAlert.alert(title: "提示", message: "请输入新密码", dismissTitle: "好的", inViewController: self, withDismissAction: nil)
            return
        }
        
        
        let userName = Defaults.currentAccountName.value
        let hud = showHudWith(view, animated: true, mode: .indeterminate, text: "")
        NetworkManager.sharedManager.updatePassWordWith(userName!, usertype: .Employee, passWord: newPassword, completion: { (success, json, error) in
            
            if success == true {
                hud.labelText = "修改成功!"
                hud.hide(true, afterDelay: 1.0)
                
                Defaults.currentPassWord.value = self.newPassword
                let _ = self.navigationController?.popViewController(animated: true)
            }
            else {
                hud.labelText = error!
                hud.hide(true, afterDelay: 1.0)
            }
            
        })
        
        
        
    }
    
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(UINib(nibName: remindCellId,bundle: nil), forCellReuseIdentifier: remindCellId)
        
    }
    

}

extension UpdatePassWordVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: remindCellId, for: indexPath) as! PassWordFieldCell
        cell.selectionStyle = .none
        cell.rightField.isSecureTextEntry = true
        cell.rightField.keyboardType = .emailAddress
        cell.rightField.keyboardAppearance = .dark
        if indexPath.row == 0 {
            cell.nameLabel.text = "新密码"
            
        }
        else {
            cell.nameLabel.text = "确认密码"
        }
        
        return cell
    }
    
}
