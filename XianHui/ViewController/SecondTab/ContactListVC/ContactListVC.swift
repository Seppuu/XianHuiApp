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

    //var searchController: UISearchController!
    
    var topTableView:UITableView!
    
    var topView:UIView!
    
    var topTitle = ["助手","提醒","工作"]
    
    var topIcon = [UIImage]()
    
    var topColors = [UIColor.navBarColor(),UIColor.orangeColor(),UIColor.redColor()]
    
    override func viewDidLoad() {
        
        topIcon = [
            UIImage(named: "analyze")!,
            UIImage(named: "bell")!,
            UIImage(named: "paperPencil")!
        ]
        
        //setTableView()
        
        super.viewDidLoad()
        
        //self.tableView.layoutMargins = UIEdgeInsetsMake(0, 64, 0, 0)
        //setTopView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ContactListVC.changeAllContacts), name: accountHasChangedNoti, object: nil)
        
        addRefresh()
    }
    
    func addRefresh() {
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.reSetUserIds()
        })
    }
    
    //TODO:refresh contact list data
    func reSetUserIds() {
        let hud = showHudWith(view, animated: true, mode: .Text, text: "更新联系人...")
        User.getContactList { (success, json, error) in
            self.tableView.mj_header.endRefreshing()
            if success == true {
                hud.hide(true)
                self.changeAllContacts()
            }
            else {
                hud.labelText = error
                hud.hide(true, afterDelay: 2.0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.searchController.searchResultsTableView {
            return super.numberOfSectionsInTableView(tableView)
        }
        else {
            return super.numberOfSectionsInTableView(tableView) + 1
        }
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchController.searchResultsTableView {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        else {
            if (section == 0) {
                return 3
            }
            else {
                return super.tableView(tableView, numberOfRowsInSection: section - 1)
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 64
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == self.searchController.searchResultsTableView {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
        else {
            if (indexPath.section == 0) {
                let cellId = "ChannelCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? ChannelCell
                
                if cell == nil {
                    let nib = UINib(nibName: cellId, bundle: nil)
                    tableView.registerNib(nib, forCellReuseIdentifier: cellId)
                    cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? ChannelCell
                }
                
                cell!.nameLabel.text = topTitle[indexPath.item]
                
                cell!.leftImageView.image = topIcon[indexPath.item]
                cell!.leftImageView.contentMode = .Center
                cell!.layoutMargins = UIEdgeInsetsMake(0, 64, 0, 0)
                return cell!
            }
            else {
                let actualIndexPath = NSIndexPath(forItem: indexPath.row, inSection: indexPath.section - 1)
                let cell = super.tableView(tableView, cellForRowAtIndexPath: actualIndexPath)
                cell.layoutMargins = UIEdgeInsetsMake(0, 64, 0, 0)
                print(indexPath.row)
                return cell
            }
        }

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.searchController.searchResultsTableView {
            return super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
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
                else {
                    let vc = MyWorkVC()
                    vc.title = "我的工作"
                    navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            else {
                let actualIndexPath = NSIndexPath(forItem: indexPath.row, inSection: indexPath.section - 1)
                super.tableView(tableView, didSelectRowAtIndexPath: actualIndexPath)
            }
        }
        
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        var arr:[String]? = super.sectionIndexTitlesForTableView(tableView)
        
        arr?.append("")
        
        return arr
        
    }
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}


