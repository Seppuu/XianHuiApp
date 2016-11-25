//
//  TaskVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/20.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON

class  Task: NSObject {
    
    var id = 0
    var range = TaskOption()
    var type  = TaskOption()
    var target = ""
    var progress:CGFloat = 0.0
    
    var progressText = ""
    
    var isUpdated = false
    
    var startDateString = "" {
        didSet {
            startDate = makeDate(startDateString)
        }
    }
    var endDateString = "" {
        didSet {
            endDate = makeDate(endDateString)
        }
    }
    var publishDateString = "" {
        didSet {
            publishDate = makeDate(publishDateString)
        }
    }
    
    var startDate = Date()
    var endDate = Date()
    var publishDate = Date()
    //备注
    var remark = ""
    
    var members = [User]()
    
    func makeDate(_ dateString:String) -> Date {
        
        let formmat = DateFormatter()
        formmat.dateFormat = "YYYY-MM-dd"
        
        return formmat.date(from: dateString) == nil ? Date() : formmat.date(from: dateString)!
    }
}

class TaskListVC: BaseViewController {
    
    var tableView: UITableView!
    
    var searchController: UISearchController!
    
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
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.getTaskList()
            
        })
        
        tableView.mj_header.beginRefreshing()
        
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
    
    
    func getTaskList() {
        
        NetworkManager.sharedManager.getTaskList { (success, json, error) in
            self.tableView.mj_header.endRefreshing()
            if success == true {
                self.makeData(data: json!)
            }
            else {
                
            }
        }
        
    }
    
    var listOfTask = [Task]()
    func makeData(data:JSON) {
        listOfTask.removeAll()
        if let rows = data["rows"].array {
            
            for row in rows {
                let t = Task()
                
                if let id = row["task_id"].int {
                    t.id = id
                }
                
                if let rangeName = row["range_name"].string {
                    t.range.text = rangeName
                }
                
                if let typeName = row["type_name"].string {
                    t.type.text = typeName
                }
                
                if let percentage = row["percentage"].float {
                    t.progress = CGFloat(percentage/100)
                    t.progressText = String(Int(percentage)) + "%"
//                    t.progress = CGFloat(100.0/100)
//                    t.progressText = String(Int(100.0)) + "%"
                }
                
                if let isUpdated = row["is_update"].int {
                    if isUpdated == 0 {
                        t.isUpdated = false
                    }
                    else {
                        t.isUpdated = true
                    }
                }
                
                if let startDate = row["start_date"].string {
                    t.startDateString = startDate
                }
                
                if let endDate = row["end_date"].string {
                    t.endDateString = endDate
                }
                
                if let publishDate = row["publish_date"].string {
                    t.publishDateString = publishDate
                }
                
                
                listOfTask.append(t)
            }
        }
        
        tableView.reloadData()
    }
    
    func setNavBar() {
        
        let rightBar = UIBarButtonItem(title: "新建", style: .plain, target: self, action: #selector(TaskListVC.createNewTask))
        
        navigationItem.rightBarButtonItem = rightBar
        
    }

    func createNewTask() {
        
        let vc = CreateTaskVC()
        vc.title = "新建任务"
        vc.taskSaveSuccessHandler = {
            
            self.getTaskList()
        }
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
        
        let task = listOfTask[indexPath.row]
        
        cell.layoutMargins = UIEdgeInsetsMake(0, 76, 0, 0)
        cell.avatarImageView.image = UIImage(named: "TaskIcon")
        
        let formmat = DateFormatter()
        formmat.dateFormat = "MM-dd"
        
        cell.nameLabel.text = "范围:" + task.range.text + "  类型:" + task.type.text + "  截止:" + formmat.string(from: task.endDate)
            
        
        cell.progressLabel.text = task.progressText
        cell.progressView.progress = task.progress
        
        if task.isUpdated == true {
            cell.unReadView.alpha = 1.0
        }
        else {
            cell.unReadView.alpha = 0.0
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let task = listOfTask[indexPath.row]
        let vc = TaskDetailVC()
        vc.title = "进度详细"
        task.isUpdated = false
        vc.task = task
        navigationController?.pushViewController(vc ,animated: true)
        
        tableView.reloadData()
        
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
    
    //置顶
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // 设置删除按钮
        let setTopAction = UITableViewRowAction(style: .default, title: "置顶") { (action, indexPath) in
            
            let task = self.listOfTask[indexPath.row]
            let hud = showHudWith(self.view, animated: true, mode: .indeterminate, text: "")
            NetworkManager.sharedManager.setTaskTopInBack(task.id, completion: { (success, json, error) in
                hud.hide(true)
                if success == true {
                    self.getTaskList()
                }
                else {
                    
                }
            })
            
        }
        setTopAction.backgroundColor = UIColor.init(hexString: "AFAFAF")

        return [setTopAction]
        
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
