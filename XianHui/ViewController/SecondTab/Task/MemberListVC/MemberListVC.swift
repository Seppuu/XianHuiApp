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
    
    var memberSelectedHandler:((_ members:[User])->())?
    
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
            if user.id  == currentUser?.id {
                allUser.removeObject(user)
            }
            
        }
        
        return allUser
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate   = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}


extension MemberListVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! typeCell
        
        cell.selectionStyle = .default
         cell.accessoryType = .none
        let id = members[(indexPath as NSIndexPath).row].id
        
        listOfMemberSelected.forEach { (user) in
            if id == user.id {
                cell.accessoryType = .checkmark
                
            }
        }
        
        cell.leftLabel.text = members[(indexPath as NSIndexPath).row].displayName
        
        cell.typeLabel.alpha = 0.0
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            
            let member = members[indexPath.row]
            
            listOfMemberSelected.append(member)
            
        }
        else {
            cell.accessoryType = .none
            
            let member = members[indexPath.row]
            
            listOfMemberSelected.forEach({ (user) in
                
                if user.id == member.id {
                    listOfMemberSelected.removeObject(user)
                }
            })
            
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //try to save member id
        saveMemberSelected()
    }
    
    
    func saveMemberSelected() {
        
        
        memberSelectedHandler?(listOfMemberSelected)
        
    }
    
    
    
    
    
    
}
