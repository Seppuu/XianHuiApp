//
//  CustomerProfileVCViewController.swift
//  XianHui
//
//  Created by jidanyu on 16/8/22.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import Kingfisher

enum WorkType {
    //待计划,待咨询,待跟踪
    case plan
    case chat
    case track
}

class CustomerProfileVCViewController: BaseViewController {
    
    var profileView: CustomerCardView!
    
    //var tableView:UITableView!
    
    var workType:WorkType = .plan
    
    //Data
    var customer = Customer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customer.name = "松隆子"
        customer.sex = "女"
        customer.level = "Vip6"
        customer.birthDay = "1977.06.10"
        customer.avatarUrlString = "http://h.hiphotos.baidu.com/baike/pic/item/21a4462309f7905287076cd90cf3d7ca7bcbd538.jpg"
        
        setTopView()
        
        setTableViewWith(workType)
        
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setTopView() {
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: 334)
        profileView = CustomerCardView.instanceFromNib()
        profileView.frame = frame
        view.addSubview(profileView)
        
        profileView.nameLabel.text = customer.name
        profileView.detailLabel.text = customer.detail
        
        let url = NSURL(string: customer.avatarUrlString)!
        profileView.avatarImageView.kf_setImageWithURL(url)
        profileView.avatarImageView.contentMode = .ScaleAspectFill
        
        profileView.leftTag.text = "计划项目数"
        profileView.leftTextLabel.text = "3个"
        
        profileView.middleTag.text = "上次到店"
        profileView.middleTextLabel.text = "16.05.06"
        
        profileView.rightTag.text = "近期达成率"
        profileView.rightTextLabel.text = "78%"
        
        profileView.backButtonHandler = {
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    func setTableViewWith(type:WorkType) {
        let frame = CGRect(x: 0, y:profileView.frame.size.height, width: screenWidth, height: screenHeight - profileView.frame.size.height)
        
        switch type {
        case .plan:
            
            let bottomView = PlanningTableView(frame:frame)
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
            
        case .chat:
            let bottomView = ChattingTableView(frame:frame)
            bottomView.listOfProject = getListOfProjectPlanned()
            
            view.addSubview(bottomView)
            
        case .track:
            let bottomView = TrackingTableView(frame:frame)
            bottomView.listOfProject = getListOfProjectTracked()
            bottomView.listOfProduction = getListOfProduction()
            bottomView.parentVC = self
            view.addSubview(bottomView)

        }
        
        
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
    
    func getListOfProjectTracked() -> [Project] {
        
        let p0 = Project()
        p0.name = "天地藏浴"
        p0.remainingTimeString = "3"
        p0.remainingTime = 0.25
        
        
        let p1 = Project()
        p1.name = "炸猪排"
        p1.remainingTime = 0.75
        p1.remainingTimeString = "1"

        return [p0,p1]
    }
    
    func getListOfProduction() -> [Production] {
        
        let prod1 = Production()
        prod1.name = "牛樟芝"
        prod1.total = 20
        prod1.unit = "盒"
        prod1.oneTimeUse = 1
        
        let prod2 = Production()
        prod2.name = "益畅菌"
        prod1.total = 30
        prod1.unit = "包"
        prod1.oneTimeUse = 2
        
        return [prod1,prod2]
    }

}





















