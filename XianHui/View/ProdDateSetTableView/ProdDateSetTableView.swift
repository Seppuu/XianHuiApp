//
//  ProdDateSetTableView.swift
//  XianHui
//
//  Created by jidanyu on 16/8/24.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import ValueStepper

class ProdDateSetTableView: UIView , UITableViewDelegate,UITableViewDataSource {

    var tableView:UITableView!
    
    var cellId = "progressCell"
    
    var production:Production!
    
    let timeSelectCellId = "typeCell"
    
    let datePickerCellId = "pickerCell"
    
    let ReMarkCellId = "ReMarkCell"
    
    let StepperCellId = "StepperCell"
    
    var showBeginTimePicker  = false
    var showEndTimePicker    = false
    
    var beginDate = Date() {
        didSet {
            delayEndDate()
        }
    }
    
    var endDate = Date()
    
    func delayEndDate() {
        let timeInterval:Double = 1*60*60*24 //一天
        endDate = Date(timeInterval: timeInterval, since: beginDate)
    }
    
    override func didMoveToSuperview() {
        
        backgroundColor = UIColor.white
        
        tableView = UITableView(frame: bounds, style: .grouped)
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: timeSelectCellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: timeSelectCellId)
        
        let nib2 = UINib(nibName: datePickerCellId, bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: datePickerCellId)
        
        
        let nib3 = UINib(nibName: ReMarkCellId, bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: ReMarkCellId)
        
        
        
        let nib4 = UINib(nibName: StepperCellId, bundle: nil)
        tableView.register(nib4, forCellReuseIdentifier: StepperCellId)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else if section == 1 {
            //开始时间,结束时间
            
            if showBeginTimePicker == true {
                return 3
            }
            else {
                return 2
            }
            
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            return 44
        }
        else if (indexPath as NSIndexPath).section == 1 {
            //时间选择
            if showBeginTimePicker == true {
                if (indexPath as NSIndexPath).row == 0 || (indexPath as NSIndexPath).row == 2 {
                    return 44
                }
                else {
                    return 180
                }
            }
            else {
                //默认情况
                return 44
            }
        }
        else {
            return 80
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0 {
            
            
            if (indexPath as NSIndexPath).row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: timeSelectCellId, for: indexPath) as! typeCell
                cell.leftLabel.text = "数量"
                cell.typeLabel.text = String(production.total) + production.unit
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: StepperCellId, for: indexPath) as! StepperCell
                cell.nameLabel.text = "每日用量/(\(production.unit))"
                
                cell.stepperView.minimumValue = 0.0
                cell.stepperView.maximumValue = 20.0
                cell.stepperView.stepValue = 1.0
                cell.stepperView.value = self.production.oneTimeUse
                cell.stepperView.autorepeat = true
                cell.stepperView.addTarget(self, action: #selector(ProdDateSetTableView.stepValueChanged(_:)), for: .valueChanged)
                cell.selectionStyle = .none
                return cell
            }
            
            
        }
        else if (indexPath as NSIndexPath).section == 1 {
            func returnTextCellWith(_ text:String,date:Date) -> typeCell {
                
                let textCell = tableView.dequeueReusableCell(withIdentifier: timeSelectCellId, for: indexPath) as! typeCell
                textCell.leftLabel.text = text
                
                if date == beginDate {
                    textCell.typeLabel.text = convertDateToTextWith(date)
                }
                
                return textCell
            }
            
            func returnDatePickerCell(_ isBegin:Bool) -> pickerCell {
                
                let timePickerCell = tableView.dequeueReusableCell(withIdentifier: datePickerCellId, for: indexPath) as! pickerCell
                
                timePickerCell.datePickerView.datePickerMode = .date
                
                //Value change
                timePickerCell.dateChangeHandler = { [weak self](date) in
                    
                    guard let strongSelf = self else {return}
                    strongSelf.dateChangeHandler(date as Date)
                    
                }
                
                return timePickerCell
            }
            
            if showBeginTimePicker == true {
                if (indexPath as NSIndexPath).row == 0 {
                    
                    return returnTextCellWith("开始日期", date: beginDate)
                }
                else if (indexPath as NSIndexPath).row == 1{
                    return returnDatePickerCell(true)
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: timeSelectCellId, for: indexPath) as! typeCell
                    
                    cell.leftLabel.text = "预定结束日期"
                    
                    cell.typeLabel.text = production.endDay
                
                    return cell
                }
            }
            else {
                if (indexPath as NSIndexPath).row == 0 {
                    
                    return returnTextCellWith("开始日期", date: beginDate)
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: timeSelectCellId, for: indexPath) as! typeCell
                    
                    cell.leftLabel.text = "预定结束日期"
                    
                    cell.typeLabel.text = production.endDay
                   
                    return cell
                }
            }

        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReMarkCellId, for: indexPath) as! ReMarkCell
            cell.textView.placeholder = "您的特别备注"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 1 {
            //时间section点击
            sectionOfTimeTapWith(tableView, indexPath: indexPath)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //
    func stepValueChanged(_ sender: ValueStepper) {
        
        self.production.oneTimeUse = sender.value
        //TODO:change the way to set data
        self.production.endTime
        if showBeginTimePicker == true {
            let path = IndexPath(item: 2, section: 1)
            self.tableView.reloadRows(at: [path], with: .fade)
        }
        else {
            let path = IndexPath(item: 1, section: 1)
            self.tableView.reloadRows(at: [path], with: .fade)
        }
        

    }
    
    //MARK: 时间选择功能点如下.
    fileprivate func setMinimumDateWith(_ picker:UIDatePicker,date:Date) {
        
        picker.minimumDate = date
        
    }
    
    fileprivate func convertDateToTextWith(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        return dateFormatter.string(from: date)
    }
    
    fileprivate func convertDateToTextWithOutDay(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        return dateFormatter.string(from: date)
    }
    
    fileprivate func dateChangeHandler(_ date:Date) {
        
        if showBeginTimePicker == true {
            beginDate = date //此时endDate也会改变
            updateBeginTimeCellWith(beginDate)
            
        }
        else {
            
        }
        
        let path = IndexPath(item: 2, section: 1)
        self.tableView.reloadRows(at: [path], with: .fade)
    }
    
    fileprivate func updateBeginTimeCellWith(_ date:Date) {
        
        let time = convertDateToTextWith(date)
        changeBeginDateCellText(time)
        
        self.production.startDay = time
        
        self.production.endTime
    }

    
    fileprivate func changeBeginDateCellText(_ time:String) {
        
        //beigin time cell is 0 1 always
        let indexPath = IndexPath(row: 0, section: 1)
        guard let cell = tableView.cellForRow(at: indexPath) as? typeCell else {return}
        cell.typeLabel.text = time
        
    }

    
    fileprivate func sectionOfTimeTapWith(_ tableView:UITableView,indexPath:IndexPath) {
        
        if (indexPath as NSIndexPath).row == 0 {
            //起始时间
            showBeginTimePicker = !showBeginTimePicker
            let indexpath = IndexPath(row: 1, section: 1)
            if showBeginTimePicker == true {
                
                tableView.insertRows(at: [indexpath], with: .fade)
            }
            else {
                tableView.deleteRows(at: [indexpath], with: .fade)
            }
            
        }
    }



}
