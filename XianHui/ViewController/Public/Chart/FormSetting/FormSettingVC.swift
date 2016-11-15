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
    
    var isCustomMode = true
    
    var remmandText = "A,B,C 提供了现金,实操,产品的三种推荐档位标准.如果不符合要求,请自定义柱形图高度标准."
    
    var currentOrgName:String {
        return Defaults.currentOrgNameForMaxValueSetting.value!
    }
    var currentOrgId:Int {
        return Defaults.currentOrgIdForMaxValueSetting.value!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "设置" + "(\(currentOrgName))"
        setTableView()
        getDailyMaxValue()
        setNavBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getDailyMaxValue() {
        
        NetworkManager.sharedManager.getDailyReportMaxVaule(currentOrgId) { (success, json, error) in
            if success == true {
                self.listOfMaxVal =  self.makeMaxValueListWith(json!)
                self.tableView.reloadData()
            }
        }
        
    }
    
    var maxValKey = ["cash_amount","project_amount","product_amount","room_turnover","employee_hours"]
    
    var topButtonName = ["A档","B档","C档","自定义"]
    
    func makeMaxValueListWith(_ json:JSON) -> [MaxValue] {
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
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate   = self
        tableView.dataSource = self

        view.addSubview(tableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func setNavBarItem() {
        
        let rightBar = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(FormSettingVC.confirmTap))
        
        self.navigationItem.rightBarButtonItem = rightBar
        
        let leftBar = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(FormSettingVC.cancel))
        
        self.navigationItem.leftBarButtonItem = leftBar
        
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func confirmTap() {
        
        //Save to back
        let path10 = IndexPath(item: 0, section: 1)
        let path11 = IndexPath(item: 1, section: 1)
        let path12 = IndexPath(item: 2, section: 1)
        
        var cashMax = listOfMaxVal[0].value
        var projectmax = listOfMaxVal[1].value
        var prodMax = listOfMaxVal[2].value
        
        if let cashMaxCell = tableView.cellForRow(at: path10) as? SliderCell {
             cashMax = cashMaxCell.slider.value
        }
        
        if let projectmaxCell = tableView.cellForRow(at: path11) as? SliderCell {
             projectmax = projectmaxCell.slider.value
        }
        
        if let prodMaxCell = tableView.cellForRow(at: path12) as? SliderCell {
             prodMax = prodMaxCell.slider.value
        }
        
        let path20 = IndexPath(item: 0, section: 2)
        let path21 = IndexPath(item: 1, section: 2)
        
        var customerMax = listOfMaxVal[3].value
        var employeemax = listOfMaxVal[4].value
        
        if let customerMaxCell = tableView.cellForRow(at: path20) as? SliderCell {
            customerMax = customerMaxCell.slider.value
        }
        
        if let employeemaxCell = tableView.cellForRow(at: path21) as? SliderCell {
            employeemax = employeemaxCell.slider.value
        }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = .indeterminate
        
        NetworkManager.sharedManager.saveDailyReportMaxVaule(currentOrgId,cashMax:cashMax, projectmax: projectmax, prodMax: prodMax, roomTurnoverMax: customerMax, employeeHoursmax: employeemax) { (success, json, error) in
            
            if success == true {
                hud?.hide(true)
                self.dismiss(animated: true, completion: nil)
                //save local seeting
                Defaults.cashMaxValue.value = cashMax * 1000
                Defaults.projectMaxValue.value = projectmax * 1000
                Defaults.productMaxValue.value = prodMax * 1000
                Defaults.roomTurnoverMaxValue.value = customerMax
                Defaults.employeeHoursMaxValue.value = employeemax
                
                self.saveCompletion?()
                
            }
        }
    }
    
    func buttonTap(_ index:Int) {
        
        if index == 3 {
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
        let set = IndexSet(integer: 1)
        self.tableView.reloadSections(set, with: .none)
        
    }
    
}

extension FormSettingVC:UITableViewDelegate,UITableViewDataSource {
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            if listOfMaxVal.count > 0 {
                return 3
            }
            else {
                return 0
            }
        }
        else {
            if listOfMaxVal.count > 0 {
                return 2
            }
            else {
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return remmandText
        }
        else if section == 1 {
            return "K:1000元"
        }
        else {
            return "R:倍数,比率 H:小时"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0 {
            let cellId = "FourButtonCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? FourButtonCell
            if cell == nil {
                let nib = UINib(nibName: cellId, bundle: nil)
                tableView.register(nib, forCellReuseIdentifier: cellId)
                cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? FourButtonCell
            }
            
            for i in 0..<topButtonName.count {
                cell!.buttons[i].setTitle(topButtonName[i], for: UIControlState())
            }
            cell?.buttons.forEach({ (button) in
                button.setTitleColor(UIColor.darkText, for: UIControlState())
            })
            
            cell?.buttonTapHandler = {
                (index) in
                self.buttonTap(index)
            }
            
            return cell!
        }
        else if (indexPath as NSIndexPath).section == 1 {
            let cellId = "SliderCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? SliderCell
            if cell == nil {
                let nib = UINib(nibName: cellId, bundle: nil)
                tableView.register(nib, forCellReuseIdentifier: cellId)
                cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? SliderCell
            }
            cell?.selectionStyle = .none
            
            let maxModel = listOfMaxVal[(indexPath as NSIndexPath).row]
            
            cell?.leftLabel.text = maxModel.name
            cell?.slider.minimumValue = Float(maxModel.min)
            cell?.slider.maximumValue = Float(maxModel.max)
            cell?.step = Float(maxModel.step)
            cell?.unit = maxModel.unit
            cell?.rightLabel.text = String(maxModel.value) + maxModel.unit
            
            cell?.slider.value = Float(maxModel.value)
            
            if isCustomMode == true {
                cell?.slider.isEnabled = true
            }
            else  {
                cell?.slider.isEnabled = false
            }
            
            return cell!
        }
        else {
            
            let cellId = "SliderCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? SliderCell
            if cell == nil {
                let nib = UINib(nibName: cellId, bundle: nil)
                tableView.register(nib, forCellReuseIdentifier: cellId)
                cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? SliderCell
            }
            cell?.selectionStyle = .none
            
            let maxModel = listOfMaxVal[(indexPath as NSIndexPath).row + 3]
            
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

}




