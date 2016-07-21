//
//  TaskVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/20.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class TaskListVC: BaseViewController {
    
    var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var listOfTask = ["销售计划","培训任务","任务","周年庆"]
    
    var listOfDetail = [
        "已加密,解锁后查看",
        "@我,张三,李四,王五",
        "@我,张三,李四",
        "@我,李小花"
    ]
    
    var listOftime = [
        "20:00",
        "07/16",
        "07/23",
        "10/02"
    ]
    
    let cellId = "ConversationCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setSearchView()
        setNavBar()
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight), style: .Plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.setContentOffset(CGPointMake(0,44), animated: false)
    }
    
    func setSearchView() {
        
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        
        // Determines whether the underlying content is dimmed during a search.
        // if we are presenting the display results in the same view, this should be false
        searchController.dimsBackgroundDuringPresentation = true
        
        // Make sure the that the search bar is visible within the navigation bar.
        searchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    
    func setNavBar() {
        
        let rightBar = UIBarButtonItem(title: "新建", style: .Plain, target: self, action: #selector(TaskListVC.createNewTask))
        
        navigationItem.rightBarButtonItem = rightBar
        
    }

    func createNewTask() {
        
        performSegueWithIdentifier("toCreateVC", sender: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
     }
 

}

extension TaskListVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTask.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ConversationCell
        
        cell.avatarImageView.backgroundColor = UIColor.redColor()
        cell.nameLabel.text = listOfTask[indexPath.item]
        cell.chatLabel.text = listOfDetail[indexPath.item]
        
        if indexPath.row == 0 {
            cell.chatLabel.textColor = UIColor.grayColor()
        }
        else {
            cell.chatLabel.textColor = UIColor ( red: 0.0, green: 0.5586, blue: 1.0, alpha: 1.0 )
        }
        
        cell.timeAgoLabel.text = listOftime[indexPath.item]
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let yOffSet = scrollView.contentOffset.y
        
        //顶部搜索框在某些位置自动上拉或者下拉.
        if yOffSet >= -64  && yOffSet < -64 + 22 {
            scrollView.setContentOffset(CGPointMake(0, -64), animated: true)
        }
        else if yOffSet >= -64 + 22 && yOffSet < -20 {
            scrollView.setContentOffset(CGPointMake(0, -20), animated: true)
        }
        else {
            
        }
        
    }

}

extension TaskListVC:UISearchResultsUpdating {
    
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
