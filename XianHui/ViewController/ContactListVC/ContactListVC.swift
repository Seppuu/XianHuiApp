//
//  ContactListVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/19.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import ChatKit

class ContactListVC: LCCKContactListViewController {

    //var searchController: UISearchController!
    
    var topTableView:UITableView!
    
    var topView:UIView!
    
    var cellId = "ChannelCell"
    
    var topTitle = ["助手","提醒","任务"]
    
    var topColors = [UIColor.navBarColor(),UIColor.orangeColor(),UIColor.redColor()]
    
    override func viewDidLoad() {
        
        setTableView()
        
        super.viewDidLoad()
        
        setTopView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setTableView() {
        
        //tableView
        topTableView = UITableView(frame: CGRect(x: 0, y: 44, width: screenWidth, height:44*3), style: .Plain)
        topTableView.delegate = self
        topTableView.dataSource = self
        topTableView.scrollEnabled = false
        
        let nib = UINib(nibName: cellId, bundle: nil)
        topTableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        topView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44 + 44*3))
        
        topView.addSubview(topTableView)
    }
    
    func setTopView() {
        
        topView.addSubview(self.searchController.searchBar)
        
        tableView.tableHeaderView = topView

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toTaskVC" {
            
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
        if (tableView == topTableView) {
            return 44
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == topTableView) {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ChannelCell
            cell.accessoryType = .DisclosureIndicator
            cell.nameLabel.text = topTitle[indexPath.item]
            
            cell.leftImageView.backgroundColor = topColors[indexPath.item]
            
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
                
            }
            else {
                //performSegueWithIdentifier("toTaskVC", sender: nil)
                let vc = UIStoryboard.init(name: "TaskList", bundle: nil).instantiateViewControllerWithIdentifier("TaskListVC") as! TaskListVC
                
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
