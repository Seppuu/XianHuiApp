//
//  CreateTaskVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/20.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import SwiftString

class CreateTaskVC: BaseViewController {
    
    var tableView: UITableView!
    
    let titleCellId = "formCell"
    //let positionCellId = "formCell"
    let timeSelectCellId = "typeCell"
    
    //let memberCellId = "typeCell"
    
    let remindCellId = "BasicInfoCell"
    
    let remarkCellId = "ProfileCell"
    
    let datePickerCellId = "pickerCell"
    
    var showBeginTimePicker  = false
    var showEndTimePicker    = false
    
    var beginDate = NSDate() {
        didSet {
            delayEndDate()
        }
    }
    
    var endDate = NSDate()
    
    func delayEndDate() {
        let timeInterval:Double = 1*60*60 //一小时
        endDate = NSDate(timeInterval: timeInterval, sinceDate: beginDate)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delayEndDate()
        
        setTableView()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTableView() {
        tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight), style: .Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let cellIds = [titleCellId,timeSelectCellId,remindCellId,remarkCellId,datePickerCellId]
        for id in cellIds {
            tableView.registerNib(UINib(nibName: id,bundle: nil), forCellReuseIdentifier: id)
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

extension CreateTaskVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //标题,位置
            return 2
        }
        else if section == 1 {
            //开始时间,结束时间
            
            if showBeginTimePicker == true ||
               showEndTimePicker   == true   {
                return 3
            }
            return 2
        }
        else if section == 2 {
            //发起者,参与者
            return 2
        }
        else if section == 3 {
            //提醒
            return 1
        }
        else {
            //备注
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 100
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
            else if showEndTimePicker == true {
                if indexPath.row == 0 || indexPath.row == 1 {
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
            return 44
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(titleCellId, forIndexPath: indexPath) as! formCell
            
            if indexPath.row == 0 {
                //标题
                cell.leftTextField.placeholder = "标题"
            }
            else {
                //位置
                cell.leftTextField.placeholder = "位置"
                cell.leftTextField.userInteractionEnabled = false
                
            }
            
            return cell
        }
        else if indexPath.section == 1 {
            
                func returnTextCellWith(text:String,date:NSDate) -> typeCell {
                    
                    let textCell = tableView.dequeueReusableCellWithIdentifier(timeSelectCellId, forIndexPath: indexPath) as! typeCell
                    textCell.leftLabel.text = text
                    textCell.typeLabel.text = convertDateToTextWith(date)
                    return textCell
                }
            
                func returnDatePickerCell(isBegin:Bool) -> pickerCell {
                    
                    let timePickerCell = tableView.dequeueReusableCellWithIdentifier(datePickerCellId, forIndexPath: indexPath) as! pickerCell
                    let picker = timePickerCell.datePickerView
                    if isBegin == true {
                        let date = beginDate
                        setMinimumDateWith(picker, date: date)
                        
                    }
                    else {
                        let date = endDate
                        setMinimumDateWith(picker, date: date)
                    }
                    
                    //Value change
                    timePickerCell.dateChangeHandler = { [weak self](date) in
                        
                        guard let strongSelf = self else {return}
                        strongSelf.dateChangeHandler(date)
                        
                    }
                    
                    return timePickerCell
                }
            
            if showBeginTimePicker == true {
                if indexPath.row == 0 {
                    
                    return returnTextCellWith("开始", date: beginDate)
                }
                else if indexPath == 2 {
                    return returnTextCellWith("结束", date: endDate)
                }
                else {
                    return returnDatePickerCell(true)
                }
            }
            else if showEndTimePicker == true {
                if indexPath.row == 0 {
                    return returnTextCellWith("开始", date: beginDate)
                }
                else if indexPath == 1 {
                    return returnTextCellWith("结束", date: endDate)
                }
                else {
                    return returnDatePickerCell(false)
                }
            }
            else {
                //默认情况
                if indexPath.row == 0 {
                    return returnTextCellWith("开始", date: beginDate)
                }
                else {
                    return returnTextCellWith("结束", date: endDate)
                }
            }

        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(timeSelectCellId, forIndexPath: indexPath) as! typeCell
            if indexPath.row == 0 {
                cell.leftLabel.text = "发起者"
                cell.typeLabel.text = "陈红"
            }
            else {
                cell.leftLabel.text = "参与者"
                cell.typeLabel.text = "罗林等7人"
                cell.accessoryType = .DisclosureIndicator
            }
            
            return cell
        }
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier(remindCellId, forIndexPath: indexPath) as! BasicInfoCell
            cell.leftLabel.text = "提醒"
            
            return cell
        }
        else {
            //备注
            let cell = tableView.dequeueReusableCellWithIdentifier(remarkCellId, forIndexPath: indexPath) as! ProfileCell
            cell.profileTextView.placeholder = "备注"
            
            return cell
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            //时间section点击
            sectionOfTimeTapWith(tableView, indexPath: indexPath)
            
        }
        
    }
    
    private func setMinimumDateWith(picker:UIDatePicker,date:NSDate) {
        
        picker.minimumDate = date
        
    }
    
    private func convertDateToTextWith(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 ahh:mm"
        
        return dateFormatter.stringFromDate(date)
    }
    
    private func dateChangeHandler(date:NSDate) {
        
        if showBeginTimePicker == true {
            beginDate = date //此时endDate也会改变
            let time = convertDateToTextWith(date)
            updateEndTimeCellWith(time)
        }
        else {
            
        }
        
        if showEndTimePicker == true {
            endDate = date
            if endDate
            
            
        }
        else {
            
        }
    }
    
    private func updateBeginTimeCellWith(string:String) {
        
    }
    
    private func updateEndTimeCellWith(string:String) {
        
    }
    
    private func sectionOfTimeTapWith(tableView:UITableView,indexPath:NSIndexPath) {
        
        if indexPath.row == 0 {
            //如果结束选择器打开,先关闭
            
            if showEndTimePicker == true {
                showEndTimePicker = !showEndTimePicker
                let indexpath = NSIndexPath(forRow: 2, inSection: 1)
                tableView.deleteRowsAtIndexPaths([indexpath], withRowAnimation: .Fade)
            }
            
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
        else {
            //如果起始选择器打开,先关闭
            
            if showBeginTimePicker == true {
                showBeginTimePicker = !showBeginTimePicker
                let indexpath = NSIndexPath(forRow: 1, inSection: 1)
                tableView.deleteRowsAtIndexPaths([indexpath], withRowAnimation: .Fade)
            }
            
            //只找结束时间.
            guard let _ = tableView.cellForRowAtIndexPath(indexPath) as? typeCell else {return}
            showEndTimePicker = !showEndTimePicker
            
            let indexpath2 = NSIndexPath(forRow: 2, inSection: 1)
            
            if showEndTimePicker == true {
                
                tableView.insertRowsAtIndexPaths([indexpath2], withRowAnimation: .Fade)
                
            }
            else {
                tableView.deleteRowsAtIndexPaths([indexpath2], withRowAnimation: .Fade)
            }
            
            //TODO:分割线消失的问题.
            
        }
        
    }
}
