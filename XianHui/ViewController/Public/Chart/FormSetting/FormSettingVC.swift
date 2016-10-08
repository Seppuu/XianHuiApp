//
//  FormSettingVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/27.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class MaxValue: NSObject {
    
    var name = ""
    
    var value = 0
    
    var list = [String:String]()
    
}


class FormSettingVC: UIViewController {
    
    var tableView: UITableView!
    
    var cellId = "typeCell"
    
    var listOfMaxVal = [MaxValue]()
    
    var saveCompletion:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDailyMaxValue()
        setTableView()
        setNavBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getDailyMaxValue() {
        
        NetworkManager.sharedManager.getDailyReportMaxVaule { (success, json, error) in
            if success == true {
               self.listOfMaxVal =  self.makeMaxValueListWith(json!)
                self.tableView.reloadData()
            }
        }
    }
    
    var maxValKey = ["cash_amount","project_amount","product_amount","customer_total","employee_amount"]
    var maxKeyName = ["现金","项目","产品","客流","员工"]
    
    func makeMaxValueListWith(json:JSON) -> [MaxValue] {
        var list = [MaxValue]()
        for i in 0..<maxValKey.count {
            let someMaxVal = MaxValue()
            
            someMaxVal.name = maxKeyName[i]
            let key = maxValKey[i]
            
            if let defaultVal = json[key]["value"].int {
                someMaxVal.value = defaultVal
            }
            if let list = json[key]["list"].dictionaryObject as? [String:String] {
                someMaxVal.list = list
            }
            list.append(someMaxVal)
        }

        return list
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        tableView.delegate   = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func setNavBarItem() {
        
        let rightBar = UIBarButtonItem(title: "确定", style: .Done, target: self, action: #selector(FormSettingVC.confirmTap))
        
        self.navigationItem.rightBarButtonItem = rightBar
        
    }
    
    func confirmTap() {
        
        //TODO:check if all set done
        for maxVal in listOfMaxVal {
            if maxVal.value == 0 {
                
                DDAlert.alert(title: "提示", message: "请设置所有的项目", dismissTitle: "好的", inViewController: self, withDismissAction: nil)
                
                return
            }
        }
        
        //Save to back
        let cashMax = listOfMaxVal[0].value
        let projectmax = listOfMaxVal[1].value
        let prodMax = listOfMaxVal[2].value
        let customerMax = listOfMaxVal[3].value
        let employeemax = listOfMaxVal[4].value
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = .Indeterminate
        
        NetworkManager.sharedManager.saveDailyReportMaxVaule(cashMax, projectmax: projectmax, prodMax: prodMax, customerMax: customerMax, employeemax: employeemax) { (success, json, error) in
            
            if success == true {
                hud.hide(true)
                self.dismissViewControllerAnimated(true, completion: nil)
                //save local seeting
                Defaults.cashMaxValue.value = cashMax
                Defaults.projectMaxValue.value = projectmax
                Defaults.productMaxValue.value = prodMax
                Defaults.customerMaxValue.value = customerMax
                Defaults.employeeMaxValue.value = employeemax
                
                self.saveCompletion?()
                
            }
        }
        
        
    }
    
}

extension FormSettingVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            
            return "日报表峰值"
        }
        else {
            return nil
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfMaxVal.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! typeCell
        
        cell.accessoryType = .DisclosureIndicator
        
        let maxVal = listOfMaxVal[indexPath.row]
        
        cell.leftLabel.text = maxVal.name
        
        if maxVal.value == 0 {
            cell.typeLabel.text = "请设置"
        }
        else {
            cell.typeLabel.text = String(maxVal.value)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = MaxValueSettingVC()
        vc.title = "最大值"
        vc.maxValue = listOfMaxVal[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}
