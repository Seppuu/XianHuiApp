//
//  MyCustomerListVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/28.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON
import DZNEmptyDataSet
import MJRefresh


class MyWorkListVC: UIViewController ,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var tableView:UITableView!
    
    let dataHelper = MyWorkListHepler()
    
    var parentNavigationController : UINavigationController?
    
    var parentVC:UIViewController?
    
    var type:MyWorkType = .customer
    
    var jsons = [JSON]()
    
    var searchController =  UISearchController()
    
    var filterParams = JSONDictionary()
    
    var originalDatas = [MyWorkObject]() {
        didSet {
            dataHelper.dataArray = originalDatas
        }
    }
    
    var searchResults = [MyWorkObject]() {
        didSet {
            dataHelper.dataArray = searchResults
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        addNoti()
        setTableView()
        setSearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func addNoti() {
        //客户计划更新.
        NotificationCenter.default.addObserver(self, selector: #selector(MyWorkListVC.refreshData), name:CustomerPlannHasAddNoti, object: nil)
    }
    
    func refreshData() {
        needRefresh = true
        
        if needRefresh == true {
            clearDataBeforeFilterSuccess()
            tableView.mj_footer.beginRefreshing()
            needRefresh = false
        }
        else {
            
        }
    }
    
    var needRefresh = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reSetNavBarItem()
    }
    
    
    let searchButton = UIButton()
    var searchItem   = UIBarButtonItem()
    var filterItem   = UIBarButtonItem()
    var negativeSpacer = UIBarButtonItem()
    var searchBar    = UISearchBar()
    
    func setSearchBar() {
        //searchButton.setTitle("搜索", forState: .Normal)
        searchButton.setImage(UIImage(named: "searchIcon"), for: UIControlState())
        searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        searchButton.setTitleColor(UIColor.white, for: UIControlState())
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        searchButton.addTarget(self, action: #selector(MyWorkListVC.searchButtonTapped), for: .touchUpInside)
        
        self.searchItem = UIBarButtonItem(customView: searchButton)
        
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        //button.setTitle("筛选", forState: .Normal)
        button.setImage(UIImage(named: "filterIcon"), for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.addTarget(self, action: #selector(MyWorkListVC.filterButtonTap), for: .touchUpInside)
        filterItem = UIBarButtonItem(customView: button)
        
        negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        
        self.parentVC!.navigationItem.rightBarButtonItems = [negativeSpacer,filterItem,searchItem]
        
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.tintColor = UIColor.white
        
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            
            textFieldInsideSearchBar.textColor = UIColor.white
        }
        
        searchBar.setImage(UIImage(named: "Search Icon"), for: UISearchBarIcon.search, state: UIControlState())

        searchBar.setImage(UIImage(named: "Clear"), for: .clear, state: UIControlState())
        
    }
    
    func setSearch() {
        
        isSearch = true
        //move tableView into superVC
        tableView.removeFromSuperview()
        searchResults = [MyWorkObject]()
        tableView.reloadData()
        tableView.frame = CGRect(x: 0.0, y: 64, width: self.parentVC!.view.frame.width, height: self.parentVC!.view.frame.height - 64)
        self.parentVC?.view.addSubview(tableView)
        
        tableView.mj_footer.removeFromSuperview()
        
    }
    
    func reSetTableView() {
        
        isSearch = false
        tableView.removeFromSuperview()
        dataHelper.dataArray = originalDatas
        tableView.reloadData()
        tableView.frame = CGRect(x: 0.0,y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(tableView)
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.getDataFromServer(self.filterParams)
        })
    }
    
    func reSetNavBarItem() {
        
        self.parentVC!.navigationItem.rightBarButtonItems = [negativeSpacer,filterItem,searchItem]
    }
    
    func searchButtonTapped() {
        
        UIView.animate(withDuration: 0.15, animations: {
            
            self.searchButton.alpha = 0.0
            
            }, completion: { (finished) in
                
                self.setSearch()
                
                self.parentVC!.navigationItem.rightBarButtonItems = nil
                self.parentVC!.navigationItem.titleView = self.searchBar
                self.searchBar.alpha = 0.0
                
                
                UIView.animate(withDuration: 0.15, animations: {
                    self.searchBar.alpha = 1.0
                    }, completion: { (finish) in
                        self.searchBar.becomeFirstResponder()
                        
                })
                
        }) 

    }

    func setTableView() {
        tableView = UITableView(frame: CGRect(x: 0.0,y: 0.0, width: self.view.frame.width, height: self.view.frame.height), style: .grouped)
        view.addSubview(tableView)
        tableView.delegate = dataHelper
        tableView.dataSource = dataHelper
        
        // add MJRefresh
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            self.getDataFromServer(self.filterParams)
        })        

        
        dataHelper.cellSelectedHandler = {
            (index,objectId,objectName,obj) in
            
            self.toProfileVC(objectId,index:index,objName:objectName)
            
        }
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        tableView.mj_footer.beginRefreshing()
        
        setFilterView()
        getFilterData(JSONDictionary())
    }
    
    func toProfileVC(_ objectId:Int,index:Int,objName:String) {
        
        if self.type == .customer {
            let vc = CustomerProfileVC()
            vc.title = "详细资料"
            vc.customerId = objectId
            
            self.parentNavigationController?.pushViewController(vc, animated: true)
        }
        else if self.type == .employee {
            
            let vc = EmployeeProfileVC()
            vc.title = "详细资料"
            vc.type = self.type
            vc.profileJSON = self.jsons[index]
            vc.profileDetailJSON = self.jsons[index]
            
            vc.objectId = objectId
            vc.objectName = objName
            
            self.parentNavigationController?.pushViewController(vc, animated: true)
            
        }
        else if self.type == .project {
            let hud = showHudWith(view, animated: true, mode: .indeterminate, text: "")
            
            NetworkManager.sharedManager.getProjectProfileWith(objectId, completion: { (success, json, error) in
                hud.hide(true)
                if success == true {
                    let vc = GoodProfileVC()
                    vc.title = "详细资料"
                    vc.type = self.type
                    vc.profileJSON = json
                    vc.profileDetailJSON = json
                    vc.isProject = true
                    vc.objectId = objectId
                    vc.objectName = objName
                    self.parentNavigationController?.pushViewController(vc, animated: true)
                }
                else {
                    
                }
            })
            
        }
        else if self.type == .prod {
            let hud = showHudWith(view, animated: true, mode: .indeterminate, text: "")
            NetworkManager.sharedManager.getProdProfileWith(objectId, completion: { (success, json, error) in
                hud.hide(true)
                if success == true {
                    let vc = GoodProfileVC()
                    vc.title = "详细资料"
                    vc.type = self.type
                    vc.profileJSON = json
                    vc.profileDetailJSON = json
                    vc.isProject = false
                    vc.objectId = objectId
                    vc.objectName = objName
                    self.parentNavigationController?.pushViewController(vc, animated: true)
                }
                else {
                    
                }
                
            })
        }
        else {
            
        }
        
    }

    
    var filterView:XHSideFilterView!

    var blackOverlay = UIControl()
    
    func setFilterView() {
        
        let inView = UIApplication.shared.keyWindow!
        self.blackOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blackOverlay.frame = CGRect(x: 0, y: 0, width: inView.bounds.width, height: inView.bounds.height)
        
        self.blackOverlay.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        self.blackOverlay.alpha = 0
        
        inView.addSubview(self.blackOverlay)
        
        self.blackOverlay.addTarget(self, action: #selector(MyWorkListVC.blackOverlayTap), for: .touchUpInside)
        
        filterView = XHSideFilterView(frame: CGRect(x: 40, y: 0, width: screenWidth - 40, height: screenHeight))
        filterView.frame.origin.x = screenWidth
        
        inView.addSubview(filterView)
        
        
        filterView.confirmHandler = {
            (models) in
            self.blackOverlayTap()
            self.clearDataBeforeFilterSuccess()
            self.getDataFromServer(self.filterParams)
        }
        
        filterView.filterSelected = {
            (models) in
            var dict = JSONDictionary()
            for model in models {
                let name = model.paramName
                let id = model.id
                
                var isSameParam = false
                
                for (key,value) in dict {
                    
                    if key == name {
                        //参数类型相同
                        isSameParam = true
                        let stringValue = value as! String
                        dict[key] = stringValue + "," + id
                    }
                    
                }
                
                //无相同参数类型,新增一个.
                if isSameParam == false {
                    dict += [
                       name:id
                    ]
                }
            }
            
            self.getFilterData(dict)
            
        }
        
    }
    
    func filterButtonTap() {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.filterView.frame.origin.x = 40
            self.blackOverlay.alpha = 1.0
            }, completion: nil)
        
    }
    
    func blackOverlayTap() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.filterView.frame.origin.x = screenWidth
            self.blackOverlay.alpha = 0.0
            }, completion: nil)
        
    }
    
    func clearDataBeforeFilterSuccess() {
        
        self.originalDatas =  [MyWorkObject]()
        self.pageNumber = 1
        self.jsons = [JSON]()
        self.tableView.reloadData()
        
    }
    
    func getFilterData(_ params:JSONDictionary) {
        
        var urlString = ""
        switch self.type {
        case .customer:
            urlString = getMyCustomerListFilterDataUrl
        case .employee:
            urlString = getMyColleaguesListFilterDataUrl
        case .project:
            urlString = getMyProjectListFilterDataUrl
        case .prod:
            urlString = getMyProdListFilterDataUrl
        }
        
        
        let hud = showHudWith(filterView, animated: true, mode: .indeterminate, text: "")
        
        NetworkManager.sharedManager.getMyWorkListFilterDataWith(params,urlString:urlString) { (success, json, error) in
            hud.hide(true)
            if success == true {
                
                if let datas = json?.array {
                    self.filterView.dataArray = self.makeFilterTableViewWith(datas)
                    self.filterView.collectionView.reloadData()
                    
                    self.filterParams = params
                    
                }
                
            }
            else {
                
            }
        }
        
    }
    
    func makeFilterTableViewWith(_ datas:[JSON])  -> [XHSideFilterDataList] {
        var arr = [XHSideFilterDataList]()
        for data in datas {
            
            let list = XHSideFilterDataList()
            if let sectionName = data["name"].string {
                list.name = sectionName
            }
            
            //筛选结果总计.
            if let filterResult = data["filterResult"].int {
                self.total = filterResult
            }
            
            if let sectionDatas = data["list"].array {
                
                for sectionData in sectionDatas {
                    let model = XHSideFilterDataModel()
                    
                    if let paramName = data["param"].string{
                        model.paramName = paramName
                    }
                    
                    if let name = sectionData["text"].string{
                        model.name = name
                    }
                    
                    if let idString = sectionData["value"].string {
                        model.id = idString
                    }
                    
                    if let selected = sectionData["selected"].bool {
                        model.selected = selected
                    }
                    
                    if let disabled = sectionData["disabled"].bool {
                        model.disabled = disabled
                    }
                    
                    list.list.append(model)
                }
            }
            
            arr.append(list)

        }
        return arr
    }
    
    //空数据提示
    
    var hasLoadData = false {
        
        didSet {
            if hasLoadData == true {
                self.tableView.reloadData()
            }
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text =  isSearch == true ? "搜索全部:无结果":"暂无数据"
        
        let attrString = NSAttributedString(string: text)
        
        return attrString
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return hasLoadData
    }
    
    
    var pageSize = 20
    
    var pageNumber = 1
    
    
    var searchText = "" {
        didSet {
            //当前是搜索模式
            self.searchResults.removeAll()
           // let _ = showHudWith(tableView, animated: true, mode: .indeterminate, text: "")
            if searchText != "" {
               self.getDataFromServer(self.filterParams)
            }
            else {
                self.tableView.reloadData()
            }
            
        }
    }

    
    var isSearch = false
    
    var totalUnit:String {
        
        switch type {
        case .customer:
            return "人"
        case .employee:
            return "人"
        case .project:
            return "种"
        case .prod:
            return "种"
        }
    }
    
    var total = 0 {
        didSet {
            
            self.filterView.statusString = "筛选结果:" + String(total) + totalUnit
        }
    }
    
    func getDataFromServer(_ params:JSONDictionary) {
        var urlString = ""
        switch self.type {
        case .customer:
            urlString = GetMyWorkCustomerUrl
        case .employee:
            urlString = GetMyWorkEmployeeUrl
        case .project:
            urlString = GetMyWorkProjectUrl
        case .prod:
            urlString = GetMyWorkProdUrl
        }
        
        var pageSize = self.pageSize
        
        var pageNumber = self.pageNumber
        
        //如果是搜索情况的时候,不需要分页.
        if isSearch == true {
            pageSize = 10000
            pageNumber = 1
        }
        
        NetworkManager.sharedManager.getMyWorkListWith(searchText,params:params,urlString:urlString, pageSize: pageSize, pageNumber: pageNumber) { (success, json, error) in
            hideHudFrom(self.view)
            hideHudFrom(self.filterView)
            if success == true {
                if let rows = json!["rows"].array {
                    
                    if rows.count == 0 {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        self.tableView.mj_footer.isAutomaticallyHidden = true
                    }
                    else {
                        self.tableView.mj_footer.endRefreshing()
                        self.tableView.mj_footer.isAutomaticallyHidden = false
                        
                        self.getDataWith(rows)
                    }
                }
            }
            else {
                
            }
            
            self.hasLoadData = true
            
        }

        
    }
    
    func getDataWith(_ datas:[JSON]) {
        
        var dataArray = [MyWorkObject]()
        
        switch self.type {
        case .customer:
            dataArray = getCustomerDataWith(datas)
        case .employee:
            dataArray = getEmployeeData(datas)
        case .project:
            dataArray = getProjectData(datas)
        case .prod:
            dataArray = getProductionData(datas)
        }
        
        if isSearch == true {
            self.searchResults += dataArray
        }
        else {
            
            self.pageNumber += 1
            self.jsons += datas
            self.originalDatas += dataArray
        }
        
        tableView.reloadData()
        
        
    }
    
    func getCustomerDataWith(_ datas:[JSON]) -> [MyWorkObject] {
        
        var list = [Customer]()
        
        for data in datas {
            let c = Customer()
            if let fullName = data["fullname"].string {
               c.name = fullName
            }
            if let orgName = data["org_name"].string {
                c.place = orgName
            }
            if let days = data["days"].string {
                c.time  = days
            }
            
            if let avatarUrl = data["avator_url"].string {
                c.avatarUrlString = avatarUrl
            }
            
            if let customer_id = data["customer_id"].int {
               c.id = customer_id
            }
            
            if let status = data["status"].int {
                let statusInt = status
                
                switch statusInt {
                case 1:
                    c.scheduleStatus = "服务中"
                case 2:
                    c.scheduleStatus = "未到店"
                case 3:
                    c.scheduleStatus = "已离店"
                case 4:
                    c.scheduleStatus = "已预约"
                case 5:
                    c.scheduleStatus = "未预约"
                case 6:
                    c.scheduleStatus = "未预约"
                default:
                    break;
                }
                
            }
            
            if let total = data["project_total"].int {
                c .projectTotal = total
            }
            
            list.append(c)
        }
        
        var dataArray = [MyWorkObject]()
        for c in list {
            let work = MyWorkObject()
            work.nameLabelString = c.name
            work.leftImageUrl = c.avatarUrlString
            work.firstTagString = c.place
            work.secondTagString = c.time
            work.thirdTagString = String(c.projectTotal)
            work.id = c.id
            
            work.rightLabelString = c.scheduleStatus
            
            work.firstTagImage = UIImage(named: "place")!
            work.secondTagImage = UIImage(named: "clock")!
            work.thirdTagImage = UIImage(named: "planIcon")!
            
            dataArray.append(work)
            
        }
        
        return dataArray
    }
    
    func getEmployeeData(_ datas:[JSON]) -> [MyWorkObject] {
        var list = [Employee]()
        
        for data in datas {
            let employee = Employee()
            if let displayName = data["display_name"].string {
                employee.displayName = displayName
            }
            
            if let avatarUrl = data["avator_url"].string {
                employee.avatarURL = avatarUrl
            }
            
            if let orgName = data["org_name"].string {
                employee.place = orgName
            }
            
            if let project_hours = data["project_hours"].float {
                
                employee.workTime = String(project_hours)
            }
            
            if let userId = data["user_id"].int {
                employee.id = userId
            }
            
            if let projectTotal = data["project_qty"].int {
                employee.projectTotal = projectTotal
            }
            
            if let status = data["status"].int {
                let statusInt = status
                
                switch statusInt {
                case 1:
                    employee.status = "服务中"
                case 2,3:
                    employee.status = "等待中"
                default:
                    break;
                }
            }
            
            list.append(employee)
        }
        
        var dataArray = [MyWorkObject]()
        for employee in list {
            let work = MyWorkObject()
            work.nameLabelString = employee.displayName
            work.leftImageUrl = employee.avatarURL
            work.firstTagString = employee.place
            work.secondTagString = String(employee.projectTotal)
            work.thirdTagString = employee.workTime
            work.id = employee.id
            work.rightLabelString = employee.status
            
            work.firstTagImage = UIImage(named: "place")!
            work.secondTagImage = UIImage(named: "calander")!
            work.thirdTagImage = UIImage(named: "timeTotal")!
            
            dataArray.append(work)
            
        }
        
        return dataArray

    }
    
    func getProjectData(_ datas:[JSON])  -> [MyWorkObject] {
        var list = [Project]()
        
        for data in datas {
            let p = Project()
            if let projectName = data["project_name"].string {
                p.name = projectName
            }
            
            if let orgName = data["org_name"].string {
                p.place = orgName
            }
            
            if let avator_url = data["avator_url"].string {
                p.avatarUrl = avator_url
            }
            
            if let scheduleNum = data["schedule_num"].int {
                p.scheduleNum = scheduleNum
            }
            
            if let paidNum = data["paid_num"].string {
                if let paidNumInt = paidNum.toInt() {
                    p.paidNum  = paidNumInt
                }
            }
            
            if let projectId = data["project_id"].int {
                p.id = projectId
            }
            
            list.append(p)
        }
        
        var dataArray = [MyWorkObject]()
        for p in list {
            let work = MyWorkObject()
            work.nameLabelString = p.name
            work.leftImageUrl = p.avatarUrl
            work.firstTagString = p.place
            work.secondTagString = String(p.scheduleNum)
            work.thirdTagString = String(p.paidNum)
            work.id = p.id
            work.firstTagImage = UIImage(named: "place")!
            work.secondTagImage = UIImage(named: "calander")!
            work.thirdTagImage = UIImage(named: "littlePeopleNum")!
            
            dataArray.append(work)
            
        }
        
        return dataArray

    }
    
    func getProductionData(_ datas:[JSON])  -> [MyWorkObject] {
        
        var list = [Production]()
        
        for data in datas {
            let prod = Production()
            if let itemId = data["item_id"].int {
                prod.id = itemId
            }
            if let itemName = data["item_name"].string {
                prod.name = itemName
            }
            
            if let orgName = data["org_name"].string {
                prod.place = orgName
            }
            
            if let avator_url = data["avator_url"].string {
                prod.avatarUrl = avator_url
            }
            
            if let stockNum = data["stock_qty"].string {
                    prod.stockNum = stockNum
            }
            if let slaeNum = data["buy_qty"].string {
                    prod.saleNum = slaeNum
            }
            
            
            list.append(prod)
        }
        
        var dataArray = [MyWorkObject]()
        for p in list {
            let work = MyWorkObject()
            work.nameLabelString = p.name
            work.leftImageUrl = p.avatarUrl
            work.firstTagString = p.place
            work.secondTagString = p.stockNum
            work.thirdTagString = p.saleNum
            work.id            = p.id
            work.firstTagImage = UIImage(named: "place")!
            work.secondTagImage = UIImage(named: "stockIcon")!
            work.thirdTagImage = UIImage(named: "shoppingCar")!
            
            dataArray.append(work)
            
        }
        
        return dataArray

    }
    
}

//搜索
extension MyWorkListVC:UISearchBarDelegate{
    
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let searchText = searchBar.text  {
            
            getSearchResultFormBack(searchText)
          
            
        }
    }
    
    
    func getSearchResultFormBack(_ searchString:String) {
        
        searchText = searchString
        
    }
    
    
    func updateFilteredContentFor(_ searchString:String) {
        
        let searchDatas = originalDatas
        // 移除之前的查询结果
        
        // 遍历模型数据
        
        //  for (NSString *searchString in searchItems) {
        // each searchString creates an OR predicate for: name, id
        //
        // example if searchItems contains "iphone 599 2007":
        //      name CONTAINS[c] "lanmaq"
        //      id CONTAINS[c] "1568689942"

        let searchResults = searchDatas
        
        
        var andMatchPredicates = [NSCompoundPredicate]()
        var searchItemsPredicate = [NSComparisonPredicate]()
        
        // use NSExpression represent expressions in predicates.
        // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
        
        // name field matching
        let leftExpression = NSExpression.init(forKeyPath: "nameLabelString")
        
        let rightExpression = NSExpression.init(forConstantValue: searchString)
        
        let finalPredicate = NSComparisonPredicate(leftExpression: leftExpression, rightExpression: rightExpression, modifier: .direct, type: .contains, options: .caseInsensitive)
        
        searchItemsPredicate.append(finalPredicate)
        
        // at this OR predicate to our master AND predicate
        let orMatchPredicates = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
        
        andMatchPredicates.append(orMatchPredicates)
        
        // match up the fields of the Product object
        let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        
        if let filterResult = (searchResults as NSArray).filtered(using: finalCompoundPredicate) as? [MyWorkObject] {
            
            dataHelper.dataArray = filterResult
            self.tableView.reloadData()
        }
       
    
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        
        UIView.animate(withDuration: 0.15, animations: {
            
            self.searchBar.alpha = 0.0
            
            }, completion: { (finish) in
                self.reSetTableView()
                self.parentVC!.navigationItem.titleView = nil
                self.parentVC!.navigationItem.rightBarButtonItems = [self.negativeSpacer,self.filterItem,self.searchItem]
                self.searchButton.alpha = 0.0
                
                UIView.animate(withDuration: 0.15, animations: {
                    self.searchButton.alpha = 1.0
                    }, completion: nil)
        }) 
        
    }
    
    
}
