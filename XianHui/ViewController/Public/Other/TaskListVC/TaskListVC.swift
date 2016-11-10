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
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.setContentOffset(CGPoint(x: 0,y: 44), animated: false)
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
        
        
        //解决 搜索框点击之后,view 下移.
        definesPresentationContext = true
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        
    }
    
    
    func setNavBar() {
        
        let rightBar = UIBarButtonItem(title: "新建", style: .plain, target: self, action: #selector(TaskListVC.createNewTask))
        
        navigationItem.rightBarButtonItem = rightBar
        
    }

    func createNewTask() {
        
        let vc = CreateTaskVC()
        vc.title = "新建任务"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
     }
 

}

extension TaskListVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTask.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ConversationCell
        
        cell.layoutMargins = UIEdgeInsetsMake(0, 76, 0, 0)
        cell.avatarImageView.image = UIImage(named: "TaskIcon")
        cell.nameLabel.text = listOfTask[(indexPath as NSIndexPath).item]
       
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = TaskDetailVC()
        vc.title = "进度详细"
        navigationController?.pushViewController(vc ,animated: true)
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let yOffSet = scrollView.contentOffset.y
        
        //顶部搜索框在某些位置自动上拉或者下拉.
        if yOffSet >= -64  && yOffSet < -64 + 22 {
            scrollView.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
        }
        else if yOffSet >= -64 + 22 && yOffSet < -20 {
            scrollView.setContentOffset(CGPoint(x: 0, y: -20), animated: true)
        }
        else {
            
        }
        
    }

}

extension TaskListVC:UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // No need to update anything if we're being dismissed.
        if !searchController.isActive {
            return
        }
        
        // you can access the text in the search bar as below
        // filterString = searchController.searchBar.text
        
        // write some code to filter the data provided to your tableview
    }
    
}
