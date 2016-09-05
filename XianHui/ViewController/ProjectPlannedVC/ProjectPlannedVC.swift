//
//  ProjectPlannedVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/5.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class ProjectPlannedVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        setTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        let bottomView = ChattingTableView(frame:view.bounds)
        bottomView.listOfProject = getListOfProjectPlanned()
        
        view.addSubview(bottomView)

        
    }
    

    func getListOfProjectPlanned() -> [Project] {
        
        let p0 = Project()
        p0.name = "天地藏浴"
        p0.planType = .customer
        p0.time = "13:30 - 15:30"
        
        
        let p1 = Project()
        p1.name = "炸猪排"
        p1.planType = .salesman
        p1.time = "15:40 - 16:30"
        
        let p2 = Project()
        p2.name = "春暖花开"
        p2.planType = .customer
        p2.time = "16:50 - 17:30"
        
        
        return [p0,p1,p2]
    }
}
