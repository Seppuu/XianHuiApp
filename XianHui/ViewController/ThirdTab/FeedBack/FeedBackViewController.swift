//
//  FeedBackViewController.swift
//  DingDong
//
//  Created by Seppuu on 16/5/29.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MBProgressHUD
import SnapKit

class FeedBackViewController: BaseViewController,UITextViewDelegate {
    
    var topContainer: UIView!
   
    var feedBackTextView: UITextView!
    
    var hud = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "反馈"
        
        topContainer = UIView()
        topContainer.backgroundColor = UIColor.ddViewBackGroundColor()
        view.addSubview(topContainer)
        topContainer.snp.makeConstraints { (make) in
            
            make.left.right.equalTo(view)
            make.top.equalTo(view)
            make.height.equalTo(60)
            
        }
        
        let msgLabel = UILabel()
        topContainer.addSubview(msgLabel)
        msgLabel.snp.makeConstraints { (make) in
            
            make.left.right.top.bottom.equalTo(topContainer)
        }
        msgLabel.textAlignment = .center
        msgLabel.font = UIFont.systemFont(ofSize: 14)
        msgLabel.text = "我们会认真阅读每一份反馈!"
        msgLabel.textColor = UIColor.gray
        
        feedBackTextView = UITextView()
        view.addSubview(feedBackTextView)
        feedBackTextView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(topContainer.snp.bottom).offset(8)
        }
        
        feedBackTextView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(FeedBackViewController.topContainerTap))
        topContainer.isUserInteractionEnabled = true
        topContainer.addGestureRecognizer(tap)
        
        setNavBar()
    }
    
    var confirmButton = UIBarButtonItem()
    
    func setNavBar() {
        
        confirmButton = UIBarButtonItem(title: "确认", style: .done, target: self, action:  #selector(FeedBackViewController.sendFeedBack))

        navigationItem.rightBarButtonItem = confirmButton
    }
    
    func topContainerTap() {
        feedBackTextView.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func sendFeedBack() {
        
        let content = feedBackTextView.text
        
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.hud.mode = .indeterminate
        self.hud.labelText = "提交中..."
        
        let user = User.currentUser()
        let name = user?.userName
        let agentId = Defaults.currentAgentId.value
        NetworkManager.sharedManager.submitFeedback(with: name!, usertype: .Customer, agentId: agentId!, content: content!) { (success, _, _) in
            if success == true {
                self.hud.mode = .text
                self.hud.labelText = "提交成功,感谢您的意见!"
                self.hud.hide(true, afterDelay: 2.5)
            }
        }

    }

    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            confirmButton.isEnabled = false
        }
        else {
            confirmButton.isEnabled = true
        }
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
