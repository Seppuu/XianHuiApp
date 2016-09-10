//
//  NoticeListVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/9.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class Notice: NSObject {

    var id = ""
    
    
    
}

class NoticeListVC: UIViewController {
    
    var tableView:UITableView!
    
    var cellId = "typeCell"

    var pageNumber = 1
    
    var pageSize = 10
    
    var notices = [Notice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()

        getNoticeListWith()
        
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getNoticeListWith() {
        
        NetworkManager.sharedManager.getNoticeListWith(pageSize, pageNumber: pageNumber) { (success, json, error) in
            if success == true {
                
            }
            else {
                
            }
        }
    }
    
    
    func setTableView() {
    
        tableView = UITableView(frame: view.bounds, style: .Plain)
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        
    }
    

}

extension NoticeListVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! typeCell
        
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}