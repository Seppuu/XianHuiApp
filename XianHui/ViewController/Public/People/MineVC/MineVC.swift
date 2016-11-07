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
        
        let cell = UITableViewCell()
        cell.accessoryView = UIImageView.xhAccessoryView()
        cell.textLabel?.text = titles[(indexPath as NSIndexPath).item]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row == 0{
            let vc = PasswordSettingVC()
            
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}




