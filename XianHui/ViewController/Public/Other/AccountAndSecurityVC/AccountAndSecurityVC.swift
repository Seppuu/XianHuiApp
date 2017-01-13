//
//  AccountAndSecurityVC.swift
//  XianHui
//
//  Created by jidanyu on 2017/1/12.
//  Copyright © 2017年 mybook. All rights reserved.
//

import UIKit

class AccountAndSecurityVC: BaseViewController {

    var tableView:UITableView!
    
    var SwitchCellId = "SwitchCell"
    
    let titles = ["账号切换","指纹"]
    
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
        
        
    }

    
}

extension AccountAndSecurityVC:UITableViewDelegate,UITableViewDataSource {
    
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
        
        let cellID = "cell"
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        cell.selectionStyle = .none
        
        cell.textLabel?.text = titles[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let vc = AccountManagerVC()
            vc.title = "切换账号"
            navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1 {
            let vc = TouchIDSettingVC()
            vc.title = "指纹"
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            
        }
    }
    
}
