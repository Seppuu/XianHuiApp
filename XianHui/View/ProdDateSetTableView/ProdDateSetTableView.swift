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
    
    var beginDate = NSDate() {
        didSet {
            delayEndDate()
        }
    }
    
    var endDate = NSDate()
    
    func delayEndDate() {
        let timeInterval:Double = 1*60*60*24 //一天
        endDate = NSDate(timeInterval: timeInterval, sinceDate: beginDate)
    }
    
    override func didMoveToSuperview() {
        
        backgroundColor = UIColor.whiteColor()
        
        tableView = UITableView(frame: bounds, style: .Grouped)
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: timeSelectCellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: timeSelectCellId)
        
        let nib2 = UINib(nibName: datePickerCellId, bundle: nil)
        tableView.registerNib(nib2, forCellReuseIdentifier: datePickerCellId)
        
        
        let nib3 = UINib(nibName: ReMarkCellId, bundle: nil)
        tableView.registerNib(nib3, forCellReuseIdentifier: ReMarkCellId)
        
        
        
        let nib4 = UINib(nibName: StepperCellId, bundle: nil)
        tableView.registerNib(nib4, forCellReuseIdentifier: StepperCellId)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }
        else if indexPath.section == 1 {
            //时间选择
            if showBeginTimePicker == true {
                if indexPath.row == 0 || indexPath.row == 2 {
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(timeSelectCellId, forIndexPath: indexPath) as! typeCell
                cell.leftLabel.text = "数量"
                cell.typeLabel.text = String(production.total) + production.unit
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier(StepperCellId, forIndexPath: indexPath) as! StepperCell
                cell.nameLabel.text = "每日用量/(\(production.unit))"
                
                cell.stepperView.minimumValue = 0.0
                cell.stepperView.maximumValue = 20.0
                cell.stepperView.stepValue = 1.0
                cell.stepperView.value = self.production.oneTimeUse
                cell.stepperView.autorepeat = true
                cell.stepperView.addTarget(self, action: #selector(ProdDateSetTableView.stepValueChanged(_:)), forControlEvents: .ValueChanged)
                cell.selectionStyle = .None
                return cell
            }
            
            
        }
        else if indexPath.section == 1 {
            func returnTextCellWith(text:String,date:NSDate) -> typeCell {
                
                let textCell = tableView.dequeueReusableCellWithIdentifier(timeSelectCellId, forIndexPath: indexPath) as! typeCell
                textCell.leftLabel.text = text
                
                if date == beginDate {
                    textCell.typeLabel.text = convertDateToTextWith(date)
                }
                
                return textCell
            }
            
            func returnDatePickerCell(isBegin:Bool) -> pickerCell {
                
                let timePickerCell = tableView.dequeueReusableCellWithIdentifier(datePickerCellId, forIndexPath: indexPath) as! pickerCell
                
                timePickerCell.datePickerView.datePickerMode = .Date
                
                //Value change
                timePickerCell.dateChangeHandler = { [weak self](date) in
                    
                    guard let strongSelf = self else {return}
                    strongSelf.dateChangeHandler(date)
                    
                }
                
                return timePickerCell
            }
            
            if showBeginTimePicker == true {
                if indexPath.row == 0 {
                    
                    return returnTextCellWith("开始日期", date: beginDate)
                }
                else if indexPath.row == 1{
                    return returnDatePickerCell(true)
                }
                else {
                    let cell = tableView.dequeueReusableCellWithIdentifier(timeSelectCellId, forIndexPath: indexPath) as! typeCell
                    
                    cell.leftLabel.text = "预定结束日期"
                    
                    cell.typeLabel.text = production.endDay
                
                    return cell
                }
            }
            else {
                if indexPath.row == 0 {
                    
                    return returnTextCellWith("开始日期", date: beginDate)
                }
                else {
                    let cell = tableView.dequeueReusableCellWithIdentifier(timeSelectCellId, forIndexPath: indexPath) as! typeCell
                    
                    cell.leftLabel.text = "预定结束日期"
                    
                    cell.typeLabel.text = production.endDay
                   
                    return cell
                }
            }

        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(ReMarkCellId, forIndexPath: indexPath) as! ReMarkCell
            cell.textView.placeholder = "您的特别备注"
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            //时间section点击
            sectionOfTimeTapWith(tableView, indexPath: indexPath)
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //
    func stepValueChanged(sender: ValueStepper) {
        
        self.production.oneTimeUse = sender.value
        self.production.endTime
        if showBeginTimePicker == true {
            let path = NSIndexPath(forItem: 2, inSection: 1)
            self.tableView.reloadRowsAtIndexPaths([path], withRowAnimation: .Fade)
        }
        else {
            let path = NSIndexPath(forItem: 1, inSection: 1)
            self.tableView.reloadRowsAtIndexPaths([path], withRowAnimation: .Fade)
        }
        

    }
    
    //MARK: 时间选择功能点如下.
    private func setMinimumDateWith(picker:UIDatePicker,date:NSDate) {
        
        picker.minimumDate = date
        
    }
    
    private func convertDateToTextWith(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        return dateFormatter.stringFromDate(date)
    }
    
    private func convertDateToTextWithOutDay(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        return dateFormatter.stringFromDate(date)
    }
    
    private func dateChangeHandler(date:NSDate) {
        
        if showBeginTimePicker == true {
            beginDate = date //此时endDate也会改变
            updateBeginTimeCellWith(beginDate)
            
        }
        else {
            
        }
        
        let path = NSIndexPath(forItem: 2, inSection: 1)
        self.tableView.reloadRowsAtIndexPaths([path], withRowAnimation: .Fade)
    }
    
    private func updateBeginTimeCellWith(date:NSDate) {
        
        let time = convertDateToTextWith(date)
        changeBeginDateCellText(time)
        
        self.production.startDay = time
        
        self.production.endTime
    }

    
    private func changeBeginDateCellText(time:String) {
        
        //beigin time cell is 0 1 always
        let indexPath = NSIndexPath(forRow: 0, inSection: 1)
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? typeCell else {return}
        cell.typeLabel.text = time
        
    }

    
    private func sectionOfTimeTapWith(tableView:UITableView,indexPath:NSIndexPath) {
        
        if indexPath.row == 0 {
            //起始时间
            showBeginTimePicker = !showBeginTimePicker
            let indexpath = NSIndexPath(forRow: 1, inSection: 1)
            if showBeginTimePicker == true {
                
                tableView.insertRowsAtIndexPaths([indexpath], withRowAnimation: .Fade)
            }
            else {
                tableView.deleteRowsAtIndexPaths([indexpath], withRowAnimation: .Fade)
            }
            
        }
    }



}
