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
        
        leftButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(self.ddWidth/2)
        }
        
        leftButton.setTitle("不同意", for: UIControlState())
        leftButton.addTarget(self, action: #selector(bottomSubmitView.leftTap), for: .touchUpInside)
        leftButton.setTitleColor(UIColor.white, for: UIControlState())
        leftButton.backgroundColor = UIColor ( red: 0.747, green: 0.747, blue: 0.747, alpha: 1.0 )
        
        rightButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(self.ddWidth/2)
        }
        rightButton.setTitle("同意", for: UIControlState())
        rightButton.addTarget(self, action: #selector(bottomSubmitView.rightTap), for: .touchUpInside)
        rightButton.setTitleColor(UIColor.white, for: UIControlState())
        rightButton.backgroundColor = UIColor ( red: 0.9647, green: 0.259, blue: 0.2673, alpha: 1.0 )
    }
    
    func leftTap() {
        leftTapHandler?()
    }
    
    func rightTap() {
        rightTapHandler?()
    }
}

//审核页面
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
        
        view.backgroundColor = UIColor.white
        setSubViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setSubViews() {
        
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(200)
        }
        
        topView.backgroundColor = UIColor ( red: 1.0, green: 0.0, blue: 0.0, alpha: 0.31 )
        
        setTableView()
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
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
        let frame = CGRect(x: 0, y: 200,width: screenWidth, height: screenHeight - 200)
        bottomTableView = UITableView(frame: frame, style: .plain)
        bottomTableView.delegate = self
        bottomTableView.dataSource = self
        bottomTableView.bounces = false
        bottomTableView.separatorStyle = .none
        
        let nib = UINib(nibName: cellId, bundle: nil)
        bottomTableView.register(nib, forCellReuseIdentifier: cellId)
        
        view.addSubview(bottomTableView)
        
    }
    
    var lastContentOffset:CGPoint = CGPoint.zero
    
    var dismissed = false
    
    //下方确认按钮的动画.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset
        if (currentOffset.y > self.lastContentOffset.y)
        {
            lastContentOffset = currentOffset
            print("down")
            // Downward
            if dismissed == true {return}
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: { 
                self.bottomConstraint?.update(offset: self.bottomView.ddHeight)
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
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.bottomConstraint?.update(offset: 0.0)
                self.bottomView.layoutIfNeeded()
            }, completion: { (success) in
            self.dismissed = false
            })
        }
        
        
    }

}
extension ApproveVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listOfSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listOfSection[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 22))
        l.backgroundColor = UIColor ( red: 0.8797, green: 0.8755, blue: 0.884, alpha: 1.0 )
        l.textAlignment = .center
        l.text = listOfSection[section]
        
        return l
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! typeCell
        cell.selectionStyle = .none
        
        
        cell.leftLabel.text = "天地藏浴"
        cell.typeLabel.text = "萍萍/珍珍"
        
        return cell
    }
    
    
}

