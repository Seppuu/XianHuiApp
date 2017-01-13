//
//  ContactListVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/19.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import ChatKit
import MJRefresh

let accountHasChangedNoti = "accountHasChangedNoti"

class ContactListVC: LCCKContactListViewController {
    
    var topTitle = ["助手","提醒","工作","进度"]
    
    var topIcon = [UIImage]()
    
    override func viewDidLoad() {
        
        topIcon = [
            UIImage(named: "analyze")!,
            UIImage(named: "bell")!,
            UIImage(named: "paperPencil")!,
            UIImage(named: "TaskIcon")!
        ]
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactListVC.changeAllContacts), name: NSNotification.Name(rawValue: accountHasChangedNoti), object: nil)
        
        addRefresh()
    }
    
    func addRefresh() {
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.reSetUserIds()
        })
    }
    
    //TODO:refresh contact list data
    func reSetUserIds() {
        
        User.getContactList { (success, json, error) in
            self.tableView.mj_header.endRefreshing()
            if success == true {
                //hud.hide(true)
                self.changeAllContacts()
            }
            else {
                let hud = showHudWith(self.view, animated: true, mode: .text, text: "提示")
                hud.detailsLabelText = error
                hud.hide(true, afterDelay: 2.0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    func changeAllContacts() {
        
        let ids = ChatKitExample.getAllUserIds()
        do {
            let contacts = try LCChatKit.sharedInstance().getProfilesForUserIds(ids)
            self.contacts = NSSet(array: contacts) as! Set<LCCKContact>
            self.userIds = NSSet(array: ids) as! Set<String>
        } catch {
            // deal with error
        }
    }
    
}

extension ContactListVC {

    override func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.searchController.searchResultsTableView {
            return super.numberOfSections(in: tableView)
        }
        else {
            return super.numberOfSections(in: tableView) + 1
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchController.searchResultsTableView {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        else {
            if (section == 0) {
                return topTitle.count
            }
            else {
                return super.tableView(tableView, numberOfRowsInSection: section - 1)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 64
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.searchController.searchResultsTableView {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        else {
            if (indexPath.section == 0) {
                let cellId = "ChannelCell"
                var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ChannelCell
                
                if cell == nil {
                    let nib = UINib(nibName: cellId, bundle: nil)
                    tableView.register(nib, forCellReuseIdentifier: cellId)
                    cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ChannelCell
                }
                
                cell!.nameLabel.text = topTitle[indexPath.item]
                
                cell!.leftImageView.image = topIcon[indexPath.item]
                cell!.leftImageView.contentMode = .center
                cell!.layoutMargins = UIEdgeInsetsMake(0, 64, 0, 0)
                return cell!
            }
            else {
                let actualIndexPath = IndexPath(item: indexPath.row, section: indexPath.section - 1)
                let cell = super.tableView(tableView, cellForRowAt: actualIndexPath)
                cell.layoutMargins = UIEdgeInsetsMake(0, 64, 0, 0)
               // print((indexPath as NSIndexPath).row)
                return cell
            }
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.searchController.searchResultsTableView {
            return super.tableView(tableView, didSelectRowAt: indexPath)
        }
        else{
            if (indexPath.section == 0) {
                
                if indexPath.item == 0 {
                    let vc = HelperVC()
                    vc.title = "助手"
                    navigationController?.pushViewController(vc, animated: true)
                    
                }
                else if indexPath.item == 1 {
                    
                    //通知,提醒
                    let vc = NoticeListVC()
                    vc.title = "提醒"
                    navigationController?.pushViewController(vc, animated: true)
                    
                }
                else if indexPath.item == 2 {
                    //工作
                    let vc = MyWorkVC()
                    vc.title = "我的工作"
                    navigationController?.pushViewController(vc, animated: true)
                    
                }
                else {
                    //任务,进度
                    let vc = TaskListVC()
                    vc.title = "进度"
                    navigationController?.pushViewController(vc, animated: true)
                }
                
                tableView.deselectRow(at: indexPath, animated: true)
            }
            else {
                let actualIndexPath = IndexPath(item: indexPath.row, section: indexPath.section - 1)
                super.tableView(tableView, didSelectRowAt: actualIndexPath)
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView == self.searchController.searchResultsTableView {
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
        else{
            if (section == 0) {
                return nil
            }
            else {
                
                return super.tableView(tableView, titleForHeaderInSection: section - 1)
            }
        }
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        var arr:[String]? = super.sectionIndexTitles(for: tableView)
        
        arr?.append("")
        
        return arr
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}


