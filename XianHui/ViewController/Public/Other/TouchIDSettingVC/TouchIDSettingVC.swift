//
//  TouchIDSettingVC.swift
//  XianHui
//
//  Created by jidanyu on 2017/1/12.
//  Copyright © 2017年 mybook. All rights reserved.
//

import UIKit

class TouchIDSettingVC: BaseViewController {
    
    var tableView:UITableView!

    var SwitchCellId = "SwitchCell"
    
    let titles = ["指纹登陆","指纹解锁"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
    }

    func setTableView() {
        var frame = view.bounds
        frame.size.height -= 20
        tableView = UITableView(frame: frame, style: .grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: SwitchCellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SwitchCellId)
        
    }
    
    func checkTouchID(result:@escaping XHBaseBoolResult) {
        
        SecurityManager.shared.authenticateWithTouchID(notSupport: {
            //不支持,或者指纹功能关闭着.
            let msg = "您的指纹信息发生变更,请在手机设置中重新添加指纹后返回开启指纹功能。"
            let hud = showHudWith(self.view, animated: true, mode: .text, text: "提示")
            hud.detailsLabelText = msg
            hud.hide(true, afterDelay: 3.0)
            result(false)
        }, succeed: {
            //成功
            result(true)
            
        }, userCancel: {
            //用户取消
            result(false)
        }, falied: { (_, error) in
            let hud = showHudWith(self.view, animated: true, mode: .text, text: error!)
            hud.hide(true, afterDelay: 3.0)
            result(false)

        })
    }
    


}

extension TouchIDSettingVC:UITableViewDelegate,UITableViewDataSource {
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCellId, for: indexPath) as! SwitchCell
        cell.leftLabel.text = titles[indexPath.item]
        
        var isOn = false
        if indexPath.row == 0 {
            //指纹登陆
            isOn = Defaults.useTouchIDLogIn.value!
        }
        else {
            //指纹解锁
            isOn = Defaults.useTouchIDDeblock.value!
        }
        
        cell.switchButton.isOn = isOn
        cell.switchTapHandler = { (on) in
            
            if on == true {
                //需要先验证,再打开.
                self.checkTouchID(result: { (success) in
                    OperationQueue.main.addOperation {
                        if success == true {
                            cell.switchButton.isOn = true
                            if indexPath.row == 0 {
                                Defaults.useTouchIDLogIn.value = true
                            }
                            else {
                                Defaults.useTouchIDDeblock.value = true
                            }
                            
                        }
                        else {
                            cell.switchButton.isOn = false
                            if indexPath.row == 0 {
                                Defaults.useTouchIDLogIn.value = false
                            }
                            else {
                                Defaults.useTouchIDDeblock.value = false
                            }
                        }
                    }
                    
                })
            }
            else {
                cell.switchButton.isOn = false
                if indexPath.row == 0 {
                    Defaults.useTouchIDLogIn.value = on
                }
                else {
                    Defaults.useTouchIDDeblock.value = on
                }
            }
            
        }
        
        return cell
    }
    
}
