//
//  CreateTaskVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/20.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import SwiftDate
import IQKeyboardManagerSwift

class CreateTaskVC: BaseViewController {
    
    var tableView: UITableView!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    let titleCellId = "formCell"
    //let positionCellId = "formCell"
    let timeSelectCellId = "typeCell"
    
    //let memberCellId = "typeCell"
    
    let remindCellId = "BasicInfoCell"
    
    let remarkCellId = "ProfileCell"
    
    let datePickerCellId = "pickerCell"
    
    var showBeginTimePicker  = false
    var showEndTimePicker    = false
    
    var beginDate = Date() {
        didSet {
            delayEndDate()
        }
    }
    
    var endDate = Date()
    
    func delayEndDate() {
        let timeInterval:Double = 1*60*60 //一小时
        endDate = Date(timeInterval: timeInterval, since: beginDate)
    }
    
    //标题
    var taskTitle = ""
    
    //发起者(TODO:默认是当然用户)
    var initiator = ""
    
    //参与者
    var listOfMember = [User]()
    var members = ""
    
    //备注
    var remark = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delayEndDate()
        
        setTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let cellIds = [titleCellId,timeSelectCellId,remindCellId,remarkCellId,datePickerCellId]
        for id in cellIds {
            tableView.register(UINib(nibName: id,bundle: nil), forCellReuseIdentifier: id)
        }

    }
    
    @IBAction func addButtonTap(_ sender: UIBarButtonItem) {
        
        if taskTitle == "" {
            showAlertWith("请设定标题")
            return
        }
        
        if members == "" {
            showAlertWith("请设定参与人员")
            return
        }
        
        //TODO:创建任务
        showAlertWith("任务添加成功")
        
    }
    
    func showAlertWith(_ text:String) {
        
        DDAlert.alert(title: "提示", message: text, dismissTitle: "OK", inViewController: self, withDismissAction: nil)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //标题
            return 1
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
        else {
            //备注
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 3 {
            return 100
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
            else if showEndTimePicker == true {
                if (indexPath as NSIndexPath).row == 0 || (indexPath as NSIndexPath).row == 1 {
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.titleCellId, for: indexPath) as! formCell
            
            if (indexPath as NSIndexPath).row == 0 {
                //标题
                cell.leftTextField.placeholder = "标题"
                cell.endEditHandler = { (textField) in
                    
                    
                }
            }
//            else {
//                //位置
//                cell.leftTextField.placeholder = "位置"
//                cell.leftTextField.userInteractionEnabled = false
//                
//            }
            
            return cell
        }
        else if indexPath.section == 1 {
            
                func returnTextCellWith(_ text:String,date:Date) -> typeCell {
                    
                    let textCell = tableView.dequeueReusableCell(withIdentifier: timeSelectCellId, for: indexPath) as! typeCell
                    textCell.leftLabel.text = text
                    
                    if date == beginDate {
                        textCell.typeLabel.text = convertDateToTextWith(date)
                    }
                    else {
                        textCell.typeLabel.text = convertDateToTextWithOutDay(date)
                    }
                    
                    return textCell
                }
            
                func returnDatePickerCell(_ isBegin:Bool) -> pickerCell {
                    
                    let timePickerCell = tableView.dequeueReusableCell(withIdentifier: datePickerCellId, for: indexPath) as! pickerCell
                    let picker = timePickerCell.datePickerView
                    if isBegin == true {
                        //开始时间的最早时间是当前时间.
                        let date = Date()
                        setMinimumDateWith(picker!, date: date)
                        
                    }
                    else {
                        //结束时间的最早时间是开始时间的延后一个小时.
                        let timeInterval:Double = 1*60*60 //一小时
                        let date = Date(timeInterval: timeInterval, since: beginDate)
                        setMinimumDateWith(picker!, date: date)
                    }
                    
                    //Value change
                    timePickerCell.dateChangeHandler = { [weak self](date) in
                        
                        guard let strongSelf = self else {return}
                        strongSelf.dateChangeHandler(date as Date)
                        
                    }
                    
                    return timePickerCell
                }
            
            if showBeginTimePicker == true {
                if indexPath.row == 0 {
                    
                    return returnTextCellWith("开始", date: beginDate)
                }
                else if indexPath.row == 2 {
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
                else if indexPath.row == 1 {
                    return returnTextCellWith("结束", date: endDate)
                }
                else {
                    return returnDatePickerCell(false)
                }
            }
            else {
                //默认情况
                if (indexPath as NSIndexPath).row == 0 {
                    return returnTextCellWith("开始", date: beginDate)
                }
                else {
                    return returnTextCellWith("结束", date: endDate)
                }
            }

        }
        else if (indexPath as NSIndexPath).section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: timeSelectCellId, for: indexPath) as! typeCell
            if (indexPath as NSIndexPath).row == 0 {
                cell.leftLabel.text = "发起者"
                cell.typeLabel.text = User.currentUser().displayName
            }
            else {
                cell.leftLabel.text = "参与者"
                if listOfMember.count != 0 {
                    
                    let firstUser = listOfMember[0]
                    
                    if listOfMember.count == 1 {
                        cell.typeLabel.text = firstUser.displayName
                    }
                    else if listOfMember.count == 2 {
                        cell.typeLabel.text = firstUser.displayName + "," + listOfMember[1].displayName
                    }
                    else if listOfMember.count == 3 {
                        cell.typeLabel.text = firstUser.displayName + "," + listOfMember[1].displayName + "," + listOfMember[2].displayName
                    }
                    else {
                       cell.typeLabel.text = firstUser.displayName + "等\(listOfMember.count)人"
                    }
                    
                }
                else {
                    cell.typeLabel.text = "无"
                }
                
                cell.accessoryView = UIImageView.xhAccessoryView()
            }
            
            return cell
        }
        else {
            //备注
            let cell = tableView.dequeueReusableCell(withIdentifier: remarkCellId, for: indexPath) as! ProfileCell
            cell.profileTextView.placeholder = "备注"
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 1 {
            //时间section点击
            sectionOfTimeTapWith(tableView, indexPath: indexPath)
            
        }
        else if (indexPath as NSIndexPath).section == 2 {
            if (indexPath as NSIndexPath).row == 1 {
                //成员选择
                let vc = MemberListVC()
                vc.listOfMemberSelected = listOfMember
                vc.memberSelectedHandler = {
                    (listOfMemberSelected) in
                    
                    self.listOfMember = listOfMemberSelected
                    self.tableView.reloadData()
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    
    //MARK: 时间选择功能点如下.
    fileprivate func setMinimumDateWith(_ picker:UIDatePicker,date:Date) {
        
        picker.minimumDate = date
        
    }
    
    fileprivate func convertDateToTextWith(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 ahh:mm"
        
        return dateFormatter.string(from: date)
    }
    
    fileprivate func convertDateToTextWithOutDay(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " ahh:mm"
        
        return dateFormatter.string(from: date)
    }
    
    fileprivate func dateChangeHandler(_ date:Date) {
        
        if showBeginTimePicker == true {
            beginDate = date //此时endDate也会改变
            updateBeginTimeCellWith(beginDate)
            updateEndTimeCellWith(endDate)
        }
        else {
            
        }
        
        if showEndTimePicker == true {
            endDate = date
            updateEndTimeCellWith(endDate)
            
        }
        else {
            
        }
    }
    
    fileprivate func updateBeginTimeCellWith(_ date:Date) {
        
        let time = convertDateToTextWith(date)
        changeBeginDateCellText(time)
    }
    
    fileprivate func updateEndTimeCellWith(_ date:Date) {
        
        if endDate.day == beginDate.day {
            let time = convertDateToTextWithOutDay(endDate)
            changeEndDateCellText(time)
        }
        else {
            let time = convertDateToTextWith(endDate)
            changeEndDateCellText(time)
        }
        
        
    }
    
    fileprivate func changeEndDateCellText(_ time:String) {
        
        if showBeginTimePicker == true {
            //end time cell is 2 1
            let indexPath = IndexPath(row: 2, section: 1)
            guard let cell = tableView.cellForRow(at: indexPath) as? typeCell else {return}
            cell.typeLabel.text = time
        }
        else {
            
        }
        
        if showEndTimePicker == true {
            //end time cell is 1 1
            let indexPath = IndexPath(row: 1, section: 1)
            guard let cell = tableView.cellForRow(at: indexPath) as? typeCell else {return}
            cell.typeLabel.text = time
        }
        else {
            
        }
        
    }
    
    fileprivate func changeBeginDateCellText(_ time:String) {
        
        //beigin time cell is 0 1 always
        let indexPath = IndexPath(row: 0, section: 1)
        guard let cell = tableView.cellForRow(at: indexPath) as? typeCell else {return}
        cell.typeLabel.text = time
        
    }
    
    fileprivate func sectionOfTimeTapWith(_ tableView:UITableView,indexPath:IndexPath) {
        
        if (indexPath as NSIndexPath).row == 0 {
            //如果结束选择器打开,先关闭
            
            if showEndTimePicker == true {
                showEndTimePicker = !showEndTimePicker
                let indexpath = IndexPath(row: 2, section: 1)
                tableView.deleteRows(at: [indexpath], with: .fade)
            }
            
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
        else {
            //如果起始选择器打开,先关闭
            
            if showBeginTimePicker == true {
                showBeginTimePicker = !showBeginTimePicker
                let indexpath = IndexPath(row: 1, section: 1)
                tableView.deleteRows(at: [indexpath], with: .fade)
            }
            
            //只找结束时间.
            guard let _ = tableView.cellForRow(at: indexPath) as? typeCell else {return}
            showEndTimePicker = !showEndTimePicker
            
            let indexpath2 = IndexPath(row: 2, section: 1)
            
            if showEndTimePicker == true {
                
                tableView.insertRows(at: [indexpath2], with: .fade)
                
            }
            else {
                tableView.deleteRows(at: [indexpath2], with: .fade)
            }
            
            //TODO:分割线消失的问题.
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
