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
    
    var remindLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        
        view.addSubview(remindLabel)
        remindLabel.snp_makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(200)
        }
        
        remindLabel.text = "解释在这里!!"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

}
