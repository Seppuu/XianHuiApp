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
    
    var cellId = "ChannelCell"
    
    var topTitle = ["助手","提醒","工作"]
    
    var topIcon = [UIImage]()
    
    var topColors = [UIColor.navBarColor(),UIColor.orangeColor(),UIColor.redColor()]
    
    override func viewDidLoad() {
        
        topIcon = [
            UIImage(named: "analyze")!,
            UIImage(named: "bell")!,
            UIImage(named: "paperPencil")!
        ]
        
        setTableView()
        
        super.viewDidLoad()
        
        setTopView()
        
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
    
    func setTableView() {
        
        //tableView
        topTableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:44 + 64*3), style: .Plain)
        topTableView.delegate = self
        topTableView.dataSource = self
        topTableView.scrollEnabled = false
        
        
        let nib = UINib(nibName: cellId, bundle: nil)
        topTableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        topView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44 + 64*3))
        
        topView.addSubview(topTableView)
    }
    
    func setTopView() {
        
        topTableView.tableHeaderView = self.searchController.searchBar
        
        //topView.addSubview(self.searchController.searchBar)
        
        tableView.tableHeaderView = topView

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toTaskVC" {
            
        }
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
        if (tableView == topTableView) {
            return 1
        }
        else {
            return super.numberOfSectionsInTableView(tableView)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == topTableView) {
            return topTitle.count
        }
        else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == topTableView) {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ChannelCell
            cell.accessoryType = .DisclosureIndicator
            cell.nameLabel.text = topTitle[indexPath.item]
            
            cell.leftImageView.image = topIcon[indexPath.item]
            cell.leftImageView.contentMode = .Center
            return cell
            
        }
        else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (tableView == topTableView) {
            
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
            super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        }
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableView == topTableView) {
            return nil
        }
        else {
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        if (tableView == topTableView) {
            return nil
        }
        else {
            return super.sectionIndexTitlesForTableView(tableView)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}

extension ContactListVC: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // No need to update anything if we're being dismissed.
        if !searchController.active {
            return
        }
        
        // you can access the text in the search bar as below
       // filterString = searchController.searchBar.text
        
        // write some code to filter the data provided to your tableview
    }
    
}
