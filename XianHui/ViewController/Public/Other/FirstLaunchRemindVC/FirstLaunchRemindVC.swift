//
//  FirstLaunchRemindVC.swift
//  XianHui
//
//  Created by jidanyu on 16/9/20.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SnapKit

class FirstLaunchRemindVC: UIViewController {
    
    var remindLabel = UITextView()
    
    var isRemind = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        
        view.addSubview(remindLabel)
        remindLabel.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(200)
        }
        var text = ""
        if isRemind == true {
            text = "在MyBook中,顾客预约项目之后,App将收到推送消息,提醒准备项目预约."
        }
        else {
            text = "每日晚上9点,App将收到日报表的数据推送提醒,请注意查看."
        }
        
        
        remindLabel.font = UIFont.systemFont(ofSize: 14)
        remindLabel.text = text
        remindLabel.textAlignment = .center
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

}
