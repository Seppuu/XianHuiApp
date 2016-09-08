//
//  DailyFormVC.swift
//  XianHui
//
//  Created by Seppuu on 16/8/12.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class DailyFormVC: RadarChartVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDailyReportDataWith(date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    var date:String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        let date = NSDate()
        
        return formatter.stringFromDate(date)
    }
    
    func getDailyReportDataWith(date:String) {
        
        NetworkManager.sharedManager.getDailyReportDataWith(date) { (success, json, error) in
            
            if success == true {
                
            }
            else {
                
            }
            
        }
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        var dataArray = [[FormData]]()
        
        let title = self.names[indexPath.row]
        
        var sections = [String]()
        
        var names = [[String]]()
        
        var details = [[String]]()
        
        if indexPath.row == 0 {
            
            sections = ["会员卡","产品"]
            
            names = [
                
                ["A卡","B卡","C卡"],
                ["产品A","产品B"]
                         ]
            details = [
                
                ["10,000","20,000","100,000"],
                       
                ["500","500"]
                           ]
            
        }
        else if indexPath.row == 1 {
            
            sections = ["会员卡","产品"]
            
            names = [
                
                ["A卡","B卡"],
                ["产品A","产品B"]
            ]
            details = [
                
                ["10,000","20,000"],
                
                ["500","500"]
            ]
            
        }
        else if indexPath.row == 2 {
            
            sections = ["产品"]
            
            names = [
                
                ["产品A","产品B","产品C"]
            ]
            details = [
                
                ["8000","3000","3000"]
                
            ]

            
        }
        else if indexPath.row == 3 {
            
            sections = [" "]
            
            names = [
                
                ["客户A","客户B","客户C"]
            ]
            details = [
                
                ["8000","3000","3000"]
                
            ]
            
        }
        else if indexPath.row == 4 {
            
            sections = [" "]
            
            names = [
                
                ["1000元以内","1000-2000元","2000元以上"]
            ]
            details = [
                
                ["2人","2人","5人"]
                
            ]
            
        }
        else if indexPath.row == 5 {
            
            sections = [" "]
            
            names = [
                
                ["1个","2个","3个"]
            ]
            details = [
                
                ["2人","2人","2人"]
                
            ]
        }
        else {
            
            sections = [" "]
            
            names = [
                
                ["500元以内","500-1000元","1000元以上"]
            ]
            details = [
                
                ["3个","10个","15个"]
                
            ]
        }
        
        
        for section in 0..<sections.count {
            var sectionData = [FormData]()
            for row in 0..<names[section].count {
                let data = FormData()
                data.name = names[section][row]
                data.detail = details[section][row]
                
                sectionData.append(data)
                
            }
            dataArray.append(sectionData)
        }
        
        let vc = FormDetailVC()
        vc.title = title
        vc.sections = sections
        vc.dataArray = dataArray
        
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

class FormData: NSObject {
    
    var name = ""
    
    var detail = ""
    
}

class FormDetailVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    var titleName = ""
    
    var tableView:UITableView!
    
    var sections = [String]()
    
    var dataArray = [[FormData]]()
    
    let cellId = "typeCell"
    
    override func viewDidLoad() {
        
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        view.backgroundColor = UIColor.whiteColor()
        
    }
    
    
   func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let datas = dataArray[section]
        return datas.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! typeCell
        cell.selectionStyle = .None
        let datas = dataArray[indexPath.section]
        cell.leftLabel.text = datas[indexPath.row].name
        cell.typeLabel.text = datas[indexPath.row].detail
        
        return cell
        
    }
    
    
    
}


class  PieViewController: PieChartViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    var rightBarItem = UIBarButtonItem()
    
    func setBarItem() {
        
        rightBarItem = UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FormVC.settingTap(_:)))
        navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    
    func settingTap(sender:UIBarButtonItem) {
        
        let vc = FormSettingVC()
        vc.title = "设置"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
