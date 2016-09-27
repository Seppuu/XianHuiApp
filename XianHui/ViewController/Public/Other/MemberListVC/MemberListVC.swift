//
//  MemberListVC.swift
//  XianHui
//
//  Created by Seppuu on 16/8/11.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class MemberListVC: UIViewController {
    
    var tableView:UITableView!
    
    var members = [User]()
    
    var listOfMemberSelected = [User]()
    
    var cellId = "typeCell"
    
    var memberSelectedHandler:((members:[User])->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "选择成员"
        view.backgroundColor = UIColor.ddViewBackGroundColor()
        
        members = getMembers()
        
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getMembers() -> [User]{
        
        var allUser = User.getAllUser()
        
        let currentUser = User.currentUser()
        
        allUser.forEach { (user) in
            if user.id  == currentUser.id {
                allUser.removeObject(user)
            }
            
        }
        
        return allUser
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        tableView.delegate   = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}


extension MemberListVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! typeCell
        
        cell.typeLabel.alpha = 0.0
        cell.leftLabel.alpha = 0.0
        
        cell.selectionStyle = .Default
        
        let id = members[indexPath.row].id
        
        listOfMemberSelected.forEach { (user) in
            if id == user.id {
                cell.accessoryType = .Checkmark
                
            }
        }
        
        cell.textLabel!.text = members[indexPath.row].displayName
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else {return}
        
        if cell.accessoryType == .None {
            cell.accessoryType = .Checkmark
            
            let member = members[indexPath.row]
            
            listOfMemberSelected.append(member)
            
        }
        else {
            cell.accessoryType = .None
            
            let member = members[indexPath.row]
            
            listOfMemberSelected.forEach({ (user) in
                
                if user.id == member.id {
                    listOfMemberSelected.removeObject(user)
                }
            })
            
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //try to save member id
        saveMemberSelected()
    }
    
    
    func saveMemberSelected() {
        
        
        memberSelectedHandler?(members:listOfMemberSelected)
        
    }
    
    
    
    
    
    
}
