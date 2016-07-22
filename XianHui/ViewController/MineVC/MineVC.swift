//
//  MineVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/21.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit


class MineVC: BaseViewController {
    
    var tableView:UITableView!

    var titles = ["密码设置"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension MineVC:UITableViewDelegate,UITableViewDataSource {
    
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
        
        let cell = UITableViewCell()
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.text = titles[indexPath.item]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0{
            let vc = PasswordSettingVC()
            
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}




