//
//  LoginViewController.swift
//  XianHui
//
//  Created by Seppuu on 16/7/28.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SnapKit
import UITextView_Placeholder

class LoginTopView: UIView {
    
    var imageView:UIImageView!
    
    var topLabel:UILabel!
    
    override func layoutSubviews() {
        
        imageView = UIImageView()
        imageView.backgroundColor = UIColor ( red: 0.9868, green: 0.1651, blue: 0.2019, alpha: 0.66 )
        addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(22 + 10)
            make.centerX.equalTo(self)
            make.width.height.equalTo(80)
        }
        imageView.layer.cornerRadius = 80/2
        imageView.layer.masksToBounds = true
        
        topLabel = UILabel()
        addSubview(topLabel)
        topLabel.snp_makeConstraints { (make) in
            make.top.equalTo(imageView.snp_bottom).offset(8)
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(21)
        }
        topLabel.textAlignment = .Center
        topLabel.text = "登录"
        topLabel.font = UIFont.systemFontOfSize(15)
        
        
    }
}


class LoginViewController: UIViewController {
    
    var tableView:UITableView!
    
    var cellId = "UserNameCell"
    
    var singleCellId = "SingleTapCell"
    
    var clientIdHandler:((clientId:String)->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        let singleTapCellNib = UINib(nibName: singleCellId, bundle: nil)
        tableView.registerNib(singleTapCellNib, forCellReuseIdentifier: singleCellId)
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 20))
        tableView.tableFooterView = footerView
        
        
    }
}

extension LoginViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        }
        else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if indexPath.row == 0 {
            
            let view = LoginTopView()
            cell.contentView.addSubview(view)
            view.snp_makeConstraints(closure: { (make) in
                make.left.top.right.bottom.equalTo(cell.contentView)
            })
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserNameCell
            
            cell.textField.placeholder = "手机号码"
            cell.textField.keyboardType = .NumberPad
            cell.codeButtonTapHandler = {
                cell.codeButton.setTitle("验证码已发送", forState: .Normal)
            }
            cell.textField.resignFirstResponder()
            return cell
            
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserNameCell
            cell.textField.keyboardType = .NumberPad
            cell.textFieldDidTapHandler = {
                (text) in
                if text == "1234" {
                    cell.textField.endEditing(true)
                   self.clientIdHandler?(clientId:"Tom")
                }
                
            }
            cell.textField.placeholder = "验证码"
            cell.codeButton.alpha = 0.0
            return cell
        }
        else  {
            let cell = tableView.dequeueReusableCellWithIdentifier(singleCellId, forIndexPath: indexPath) as! SingleTapCell
            
            cell.middleLabel.text = "忘记了密码?"
            cell.middleLabel.textAlignment = .Center
            cell.middleLabel.font = UIFont.systemFontOfSize(10)
            cell.middleLabel.textColor = UIColor ( red: 0.4079, green: 0.6937, blue: 1.0, alpha: 1.0 )
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}



