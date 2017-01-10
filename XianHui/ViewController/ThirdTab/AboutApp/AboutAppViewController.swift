//
//  AboutAppViewController.swift
//  XianHui
//
//  Created by jidanyu on 2017/1/9.
//  Copyright © 2017年 mybook. All rights reserved.
//

import UIKit

//关于本App
class AboutAppViewController: BaseViewController {
    
    var tableView:UITableView!
    
    var nameList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameList = ["功能介绍","系统通知"]
        setTableView()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setHeaderView()
        setFooterView()
    }
    
    func setHeaderView() {
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 130))
        container.backgroundColor = UIColor.ddViewBackGroundColor()
        let imageView = UIImageView()
        imageView.image = UIImage(named: "IconAlpha")
        container.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(container)
            make.width.height.equalTo(80)
            make.top.equalTo(container).offset(10)
        }
        
        let label = UILabel()
        container.addSubview(label)
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "闲惠"
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
           label.text = "闲惠" + version
        }
        
        label.snp.makeConstraints { (make) in
            
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.right.equalTo(container)
        }
        
        
        tableView.tableHeaderView = container
        
    }
    
    func setFooterView() {
        let height = screenHeight - 64 - 130 - 44*2
        let container = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: height))
        container.backgroundColor = UIColor.ddViewBackGroundColor()
        
        tableView.tableFooterView = container
        
        let label0 = UILabel()
        container.addSubview(label0)
        label0.textColor = UIColor.gray
        label0.font = UIFont.systemFont(ofSize: 12)
        label0.textAlignment = .center
        label0.text = "迈簿科技 版权所有"
        label0.snp.makeConstraints { (make) in
            make.bottom.equalTo(container.snp.bottom).offset(-50)
            make.left.right.equalTo(container)
        }
        
        
        let label1 = UILabel()
        container.addSubview(label1)
        label1.textColor = UIColor.gray
        label1.font = UIFont.systemFont(ofSize: 12)
        label1.textAlignment = .center
        label1.text = "Copyright © 2014-2016 MyBook.All Rights Reserved."
        label1.snp.makeConstraints { (make) in
            make.bottom.equalTo(container.snp.bottom).offset(-30)
            make.left.right.equalTo(container)
        }
        
    }
    
    

}

extension AboutAppViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "cell"
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        cell.selectionStyle = .none
        
        cell.textLabel?.text = nameList[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //return
        if indexPath.row == 0 {
            //功能介绍
            let vc = BaseViewController()
            vc.title = nameList[indexPath.row]
            let l = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
            l.text = "该版本暂无功能介绍."
            l.textColor = UIColor.darkText
            l.font = UIFont.systemFont(ofSize: 14)
            vc.view.addSubview(l)
            navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1 {
            //系统通知
            let vc = BaseViewController()
            vc.title = nameList[indexPath.row]
            let l = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
            l.text = "该版本暂无系统通知"
            l.font = UIFont.systemFont(ofSize: 14)
            l.textColor = UIColor.darkText
            vc.view.addSubview(l)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

