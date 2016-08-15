//
//  ApproveVC.swift
//  XianHui
//
//  Created by Seppuu on 16/8/3.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SnapKit

class bottomSubmitView: UIView {
    var leftButton = UIButton()
    var rightButton = UIButton()
    
    var leftTapHandler:(()->())?
    var rightTapHandler:(()->())?
    
    override func layoutSubviews() {
        
        addSubview(leftButton)
        addSubview(rightButton)
        
        leftButton.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(self.ddWidth/2)
        }
        
        leftButton.setTitle("不同意", forState: .Normal)
        leftButton.addTarget(self, action: #selector(bottomSubmitView.leftTap), forControlEvents: .TouchUpInside)
        leftButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        leftButton.backgroundColor = UIColor ( red: 0.747, green: 0.747, blue: 0.747, alpha: 1.0 )
        
        rightButton.snp_makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(self.ddWidth/2)
        }
        rightButton.setTitle("同意", forState: .Normal)
        rightButton.addTarget(self, action: #selector(bottomSubmitView.rightTap), forControlEvents: .TouchUpInside)
        rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        rightButton.backgroundColor = UIColor ( red: 0.9647, green: 0.259, blue: 0.2673, alpha: 1.0 )
    }
    
    func leftTap() {
        leftTapHandler?()
    }
    
    func rightTap() {
        rightTapHandler?()
    }
}

class ApproveVC: BaseViewController {

    var bottomTableView:UITableView!
    
    var listOfHelper = [Helper]()
    
    var cellId = "typeCell"
    
    var topView = UIView()
    
    var bottomView = bottomSubmitView()
    
    var bottomConstraint: Constraint? = nil
    
    var listOfSection = ["7月7号","6月15号","6月9号","5月17号","5月10号"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        setSubViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setSubViews() {
        
        view.addSubview(topView)
        topView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(200)
        }
        
        topView.backgroundColor = UIColor ( red: 1.0, green: 0.0, blue: 0.0, alpha: 0.31 )
        
        setTableView()
        
        view.addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) in
            make.left.right.equalTo(view)
            bottomConstraint  = make.bottom.equalTo(view).constraint
            make.height.equalTo(44)
        }
        
        bottomView.leftTapHandler = {
            
        }
        
        bottomView.rightTapHandler = {
            
        }
    }
    
    func setTableView() {
        let frame = CGRectMake(0, 200,screenWidth, screenHeight - 200)
        bottomTableView = UITableView(frame: frame, style: .Plain)
        bottomTableView.delegate = self
        bottomTableView.dataSource = self
        bottomTableView.bounces = false
        bottomTableView.separatorStyle = .None
        
        let nib = UINib(nibName: cellId, bundle: nil)
        bottomTableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        view.addSubview(bottomTableView)
        
    }
    
    var lastContentOffset:CGPoint = CGPointZero
    
    var dismissed = false
    
    //下方确认按钮的动画.
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset
        if (currentOffset.y > self.lastContentOffset.y)
        {
            lastContentOffset = currentOffset
            print("down")
            // Downward
            if dismissed == true {return}
            UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseOut, animations: { 
                self.bottomConstraint?.updateOffset(self.bottomView.ddHeight)
                self.bottomView.layoutIfNeeded()
                }, completion: { (success) in
                    self.dismissed = true
            })
        }
        else
        {
            lastContentOffset = currentOffset
            print("up")
            // Upward
            if dismissed == false {return}
            UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseOut, animations: {
                self.bottomConstraint?.updateOffset(0.0)
                self.bottomView.layoutIfNeeded()
            }, completion: { (success) in
            self.dismissed = false
            })
        }
        
        
    }

}
extension ApproveVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return listOfSection.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listOfSection[section]
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 22))
        l.backgroundColor = UIColor ( red: 0.8797, green: 0.8755, blue: 0.884, alpha: 1.0 )
        l.textAlignment = .Center
        l.text = listOfSection[section]
        
        return l
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! typeCell
        cell.selectionStyle = .None
        
        
        cell.leftLabel.text = "天地藏浴"
        cell.typeLabel.text = "萍萍/珍珍"
        
        return cell
    }
    
    
}

