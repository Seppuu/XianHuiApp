//
//  HelperVC.swift
//  XianHui
//
//  Created by Seppuu on 16/8/3.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class HelperVC: BaseViewController {
    
    var tableView:UITableView!
    
    var listOfHelper = [Helper]()
    
    var cellId = "HeplerCell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfHelper = [Helper(),Helper()]
        getHelperList()
        setTableView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    var pageSize = 20
    
    var pageNumber = 1
    
    func getHelperList() {
        
        
        NetworkManager.sharedManager.getHelperListWith(pageSize, pageNumber: pageNumber) { (success, json, error) in
            
            if success == true {
                
            }
            else {
                
            }
            
        }
    }
    
    
    func setTableView() {
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard listOfHelper.count > 0 else {return}
        let indexPath = NSIndexPath(forItem: listOfHelper.count - 1, inSection: 0)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
    }
}

extension HelperVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfHelper.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (screenHeight / 3)*2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! HeplerCell
        cell.selectionStyle = .None
        let hepler = listOfHelper[indexPath.row]
        
        if indexPath.row == 0 {
            cell.pushTimeLabel.text = hepler.pushTime
            cell.nameLabel.text     = hepler.name
            cell.dayTimeLabel.text  = hepler.dayTime
            cell.descLabel.text     = hepler.desc
            cell.middleImageView.backgroundColor = UIColor ( red: 0.1176, green: 0.7176, blue: 0.502, alpha: 1.0 )
            
        }
        else {
            
            cell.pushTimeLabel.text = "21:30"
            cell.nameLabel.text     = "日报表"
            cell.dayTimeLabel.text  = "8月11号"
            cell.descLabel.text     = "今日的公司运营状况是...."
            cell.middleImageView.backgroundColor = UIColor ( red: 0.1976, green: 0.5842, blue: 0.6739, alpha: 1.0 )
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            let vc = ApproveVC()
            vc.title = "折扣审批"
            navigationController?.pushViewController(vc, animated: true)
            
        }
        else {
            let vc = DailyFormVC()
            vc.title = "日报表"
            navigationController?.pushViewController(vc, animated: true)

        }
        

        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
}


class DemoPageViewController: BaseViewController {
    
    
    override func viewDidLoad() {
        
        
    }
}














