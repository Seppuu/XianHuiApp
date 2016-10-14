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
    
    var unit = ""
    
    var min:Float = 1
    
    var max:Float = 10
    
    var step:Float = 1
    
    var value:Float = 0
    
    //A B C 档位
    var remmandValues = [Float]()
    
}



class FormSettingVC: UIViewController {
    
    var tableView: UITableView!
    
    var listOfMaxVal = [MaxValue]()
    
    var saveCompletion:(()->())?
    
    var isCustomMode = false
    
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
    
    var maxValKey = ["cash_amount","project_amount","product_amount","room_turnover","employee_hours"]
    
    var topButtonName = ["A档","B档","C档","自定义"]
    
    func makeMaxValueListWith(json:JSON) -> [MaxValue] {
        var list = [MaxValue]()
        
        for i in 0..<maxValKey.count {
            
            let maxModel = MaxValue()
            let jsonName = maxValKey[i]
            
            let data = json[jsonName]
            
            if let name = data["name"].string {
                maxModel.name = name
            }
            
            if let unit = data["unit"].string {
                maxModel.unit = unit
            }
            
            if let min = data["min"].float{
                maxModel.min = min
            }
            
            if let max = data["max"].float{
                maxModel.max = max
            }
            
            if let value = data["value"].float {
                maxModel.value = value
            }
            
            if let step = data["step"].float {
                maxModel.step = step
            }
            
            let defaultData = data["default"]
            
            if let a = defaultData["A"].float {
                maxModel.remmandValues.append(a)
            }
            
            if let b = defaultData["B"].float {
                maxModel.remmandValues.append(b)
            }
            
            if let c = defaultData["C"].float {
                maxModel.remmandValues.append(c)
            }
            list.append(maxModel)
        }
        
        return list
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        tableView.delegate   = self
        tableView.dataSource = self

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
        
        self.dismissViewControllerAnimated(true, completion: nil)
        return


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
                Defaults.roomTurnoverMaxValue.value = customerMax
                Defaults.employeeHoursMaxValue.value = employeemax
                
                self.saveCompletion?()
                
            }
        }
        
        
    }
    
    
    func buttonTap(index:Int) {
        
        if index == 4 {
            //自定义
            isCustomMode = true
        }
        else {
            //A B C 档位
            isCustomMode = false
            listOfMaxVal.forEach({ (maxModel) in
                maxModel.value = maxModel.remmandValues[index]
            })
        }
        
        self.tableView.reloadData()
        
    }
    
}

extension FormSettingVC:UITableViewDelegate,UITableViewDataSource {
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return listOfMaxVal.count
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cellId = "FourButtonCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? FourButtonCell
            if cell == nil {
                let nib = UINib(nibName: cellId, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellId)
                cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? FourButtonCell
            }
            
            for i in 0..<topButtonName.count {
                cell!.buttons[i].setTitle(topButtonName[i], forState: .Normal)
            }
            cell?.buttons.forEach({ (button) in
                button.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
            })
            
            cell?.buttonTapHandler = {
                (index) in
                self.buttonTap(index)
            }
            
            return cell!
        }
        else {
            let cellId = "SliderCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? SliderCell
            if cell == nil {
                let nib = UINib(nibName: cellId, bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: cellId)
                cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? SliderCell
            }
            cell?.selectionStyle = .None
            
            let maxModel = listOfMaxVal[indexPath.row]
            
            cell?.leftLabel.text = maxModel.name
            cell?.slider.minimumValue = Float(maxModel.min)
            cell?.slider.maximumValue = Float(maxModel.max)
            cell?.step = Float(maxModel.step)
            cell?.unit = maxModel.unit
            cell?.rightLabel.text = String(maxModel.value) + maxModel.unit
            
            cell?.slider.value = Float(maxModel.value)
            
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
}




