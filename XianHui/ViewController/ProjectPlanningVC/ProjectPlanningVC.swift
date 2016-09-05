//
//  ProjectPlanningVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/5.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class ProjectPlanningVC: UIViewController {

    var tableView:UITableView!
    
    let topCellId = "CustomerLargeCell"
    
    let typeCellId = "typeCell"
    
    //Data
    var customer:Customer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "项目计划"
        view.backgroundColor = UIColor.whiteColor()
        setTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        let bottomView = PlanningTableView(frame:view.bounds)
        bottomView.addRowTapHandler = {
            let vc = ProjectListVC()
            
            vc.projectsPreSelected = bottomView.listOfProject
            vc.prodsPreSelected    = bottomView.listOfProd
            let nav = UINavigationController(rootViewController: vc)
            
            self.presentViewController(nav, animated: true, completion: nil)
            
            vc.confirmTapHandler = {
                (projectsSelected,prodsSelected) in
                
                bottomView.listOfProject = projectsSelected
                bottomView.listOfProd = prodsSelected
                bottomView.tableView.reloadData()
            }
        }
        
        view.addSubview(bottomView)
        
    }
    

}


