//
//  PasswordSettingVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/21.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import BKPasscodeView

class PasswordSettingVC: BaseViewController ,BKPasscodeViewControllerDelegate{

    
    var tableView:UITableView!
    
    var titles = ["设置密码","修改密码","确认","直接使用Touch ID"]
    
    var SwitchCellId = "SwitchCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setTableView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let nib = UINib(nibName: SwitchCellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SwitchCellId)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension PasswordSettingVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if (indexPath as NSIndexPath).row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCellId, for: indexPath) as! SwitchCell
            cell.leftLabel.text = titles[(indexPath as NSIndexPath).item]
            let useTouchID = Defaults.useTouchID.value!
            cell.switchButton.isOn = useTouchID ? true : false
            cell.switchTapHandler = { (on) in
                
                Defaults.useTouchID.value = on
            }
            
            return cell
            
        }
        else {
            
            let cell = UITableViewCell()
            cell.accessoryView = UIImageView.xhAccessoryView()
            cell.textLabel?.text = titles[(indexPath as NSIndexPath).item]
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row == 0{
            self.presentPasscodeViewControllerWithType(BKPasscodeViewControllerNewPasscodeType)
        }
        else if (indexPath as NSIndexPath).row == 1 {
            self.presentPasscodeViewControllerWithType(BKPasscodeViewControllerChangePasscodeType)
        }
        else if (indexPath as NSIndexPath).row == 2 {
            self.presentPasscodeViewControllerWithType(BKPasscodeViewControllerCheckPasscodeType)
        }
        else {
            
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func presentPasscodeViewControllerWithType(_ type:BKPasscodeViewControllerType) {
        
        let vc = BKPasscodeViewController()
        vc.delegate = self
        vc.type = type
        vc.passcodeStyle = BKPasscodeInputViewNumericPasscodeStyle
        
        // Setup Touch ID manager
        vc.touchIDManager = BKTouchIDManager(keychainServiceName: "XianHuiKeychain")
        vc.touchIDManager.promptText = "通过Home键验证已有手机指纹"
        
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PasswordSettingVC.passcodeViewCloseButtonPressed(_:)))
        let nav = UINavigationController(rootViewController: vc)
        
        
        
        if (Defaults.useTouchID.value! == true && vc.type == BKPasscodeViewControllerCheckPasscodeType) {
            
            // To prevent duplicated selection before showing Touch ID user interface.
            self.tableView.isUserInteractionEnabled = false
            
            // Show Touch ID user interface
            vc.startTouchIDAuthenticationIfPossible({ (prompted) in
                
                self.tableView.isUserInteractionEnabled = true
                
                if prompted == true {
                    guard let selectedPath = self.tableView.indexPathForSelectedRow else {return}
                    self.tableView.deselectRow(at: selectedPath, animated: true)
                }
                else {
                    self.present(nav, animated: true, completion: nil)
                }
                
                
            })
            
        } else {
            
            self.present(nav, animated: true, completion: nil)
        }
        
        
    }
    
    
    
    func passcodeViewCloseButtonPressed(_ sender:UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //Delegate
    func passcodeViewController(_ aViewController: BKPasscodeViewController!, didFinishWithPasscode aPasscode: String!) {
        
        if aViewController.type == BKPasscodeViewControllerNewPasscodeType {
            
            Defaults.localPassword.value = aPasscode
        }
        else if aViewController.type == BKPasscodeViewControllerChangePasscodeType {
            Defaults.localPassword.value = aPasscode
        }
        
        aViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func passcodeViewController(_ aViewController: BKPasscodeViewController!, authenticatePasscode aPasscode: String!, resultHandler aResultHandler: ((Bool) -> Void)!) {
        
        if aPasscode == Defaults.localPassword.value! {
            aResultHandler(true)
        }
        else {
            aResultHandler(false)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
