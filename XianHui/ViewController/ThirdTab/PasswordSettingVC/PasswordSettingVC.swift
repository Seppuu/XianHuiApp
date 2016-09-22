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
        
        view.backgroundColor = UIColor.whiteColor()
        setTableView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenWidth), style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let nib = UINib(nibName: SwitchCellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: SwitchCellId)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier(SwitchCellId, forIndexPath: indexPath) as! SwitchCell
            cell.leftLabel.text = titles[indexPath.item]
            let useTouchID = Defaults.useTouchID.value!
            cell.switchButton.on = useTouchID ? true : false
            cell.switchTapHandler = { (on) in
                
                Defaults.useTouchID.value = on
            }
            
            return cell
            
        }
        else {
            
            let cell = UITableViewCell()
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = titles[indexPath.item]
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0{
            self.presentPasscodeViewControllerWithType(BKPasscodeViewControllerNewPasscodeType)
        }
        else if indexPath.row == 1 {
            self.presentPasscodeViewControllerWithType(BKPasscodeViewControllerChangePasscodeType)
        }
        else if indexPath.row == 2 {
            self.presentPasscodeViewControllerWithType(BKPasscodeViewControllerCheckPasscodeType)
        }
        else {
            
            return
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func presentPasscodeViewControllerWithType(type:BKPasscodeViewControllerType) {
        
        let vc = BKPasscodeViewController()
        vc.delegate = self
        vc.type = type
        vc.passcodeStyle = BKPasscodeInputViewNumericPasscodeStyle
        
        // Setup Touch ID manager
        vc.touchIDManager = BKTouchIDManager(keychainServiceName: "XianHuiKeychain")
        vc.touchIDManager.promptText = "通过Home键验证已有手机指纹"
        
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(PasswordSettingVC.passcodeViewCloseButtonPressed(_:)))
        let nav = UINavigationController(rootViewController: vc)
        
        
        
        if (Defaults.useTouchID.value! == true && vc.type == BKPasscodeViewControllerCheckPasscodeType) {
            
            // To prevent duplicated selection before showing Touch ID user interface.
            self.tableView.userInteractionEnabled = false
            
            // Show Touch ID user interface
            vc.startTouchIDAuthenticationIfPossible({ (prompted) in
                
                self.tableView.userInteractionEnabled = true
                
                if prompted == true {
                    guard let selectedPath = self.tableView.indexPathForSelectedRow else {return}
                    self.tableView.deselectRowAtIndexPath(selectedPath, animated: true)
                }
                else {
                    self.presentViewController(nav, animated: true, completion: nil)
                }
                
                
            })
            
        } else {
            
            self.presentViewController(nav, animated: true, completion: nil)
        }
        
        
    }
    
    
    
    func passcodeViewCloseButtonPressed(sender:UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //Delegate
    func passcodeViewController(aViewController: BKPasscodeViewController!, didFinishWithPasscode aPasscode: String!) {
        
        if aViewController.type == BKPasscodeViewControllerNewPasscodeType {
            
            Defaults.localPassword.value = aPasscode
        }
        else if aViewController.type == BKPasscodeViewControllerChangePasscodeType {
            Defaults.localPassword.value = aPasscode
        }
        
        aViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    func passcodeViewController(aViewController: BKPasscodeViewController!, authenticatePasscode aPasscode: String!, resultHandler aResultHandler: ((Bool) -> Void)!) {
        
        if aPasscode == Defaults.localPassword.value! {
            aResultHandler(true)
        }
        else {
            aResultHandler(false)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
