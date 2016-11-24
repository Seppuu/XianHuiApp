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
import SwiftyJSON

//创建任务页面同时也是任务资料页面

class CreateTaskVC: BaseViewController{
    
    var tableView: UITableView!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    let titleCellId = "formCell"
    let timeSelectCellId = "typeCell"
    
    let remindCellId = "BasicInfoCell"
    
    let remarkCellId = "ProfileCell"
    
    let datePickerCellId = "pickerCell"
    
    var showBeginTimePicker  = false
    var showEndTimePicker    = false
    
    var task = Task()
    
    var isShowDetail = false {
        didSet {
            
            if isShowDetail == true {
                setEditMenu()
            }
            else {
                setSaveCancelMenu()
            }
        }
    }
    
    var beginDate = Date() {
        didSet {
            if isShowDetail == false {
               delayEndDate()
            }
            
        }
    }
    
    var endDate = Date()
    
    func delayEndDate() {
        let timeInterval:Double = 1*60*60*24 //一天
        endDate = Date(timeInterval: timeInterval, since: beginDate)
    }
    
    //参与者
    var listOfMember = [User]()
    var members = ""
    
    //备注
    var remark = ""
    
    //目标
    var target = ""
    
    //date picker
    var datePicker = MIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isShowDetail == true {
            setData()
        }
        else {
            delayEndDate()
        }
        
        setTableView()
        getTaskOptions()
        
        setNavBarItem()
        
        setDatePicker()
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
    
    func setDatePicker() {
        
        datePicker = MIDatePicker.getFromNib()
        
        datePicker.delegate = self
        
        datePicker.config.startDate = beginDate
        
        datePicker.config.animationDuration = 0.4
        
        datePicker.config.cancelButtonTitle = "取消"
        datePicker.config.confirmButtonTitle = "确定"
        
        datePicker.config.contentBackgroundColor = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
        datePicker.config.headerBackgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        datePicker.config.confirmButtonColor = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
        datePicker.config.cancelButtonColor = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
        
    }
    
    func setNavBarItem() {
        
        if isShowDetail == true {
            setEditMenu()
        }
        else {
            setSaveMenu()
        }
        
    }
    
    func setEditMenu() {
        navigationItem.rightBarButtonItems?.removeAll()
        let rightBarItem = UIBarButtonItem(title: "修改", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateTaskVC.showEditMode))
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func setSaveMenu() {
        let rightBarItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateTaskVC.saveTask))
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func setSaveCancelMenu() {
        let cancelBarItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateTaskVC.cancelEdit))
        let rightBarItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateTaskVC.saveTask))
        navigationItem.rightBarButtonItems = [cancelBarItem,rightBarItem]
    }
    
    var taskSaveSuccessHandler:(()->())?
    
    func showEditMode() {
        
        isShowDetail = false
        tableView.reloadData()
    }
    
    func cancelEdit() {
        isShowDetail = true
        tableView.reloadData()
    }
    
    func saveTask() {
        
        let range = taskRange.value
        if range == "" {
            DDAlert.alert(title: "提示", message: "请选择范围", dismissTitle: "好的", inViewController: self, withDismissAction: nil)
            return
        }
        let type = taskType.value
        if type == "" {
            DDAlert.alert(title: "提示", message: "请选择类型", dismissTitle: "好的", inViewController: self, withDismissAction: nil)
            return
        }
        
        
        let path = IndexPath(item: 2, section: 0)
        let cell = tableView.cellForRow(at: path) as! BasicInfoCell
        target = cell.realNumString
        if target == "" {
            DDAlert.alert(title: "提示", message: "请设定目标", dismissTitle: "好的", inViewController: self, withDismissAction: nil)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let startDate = dateFormatter.string(from:self.beginDate)
        let endDate = dateFormatter.string(from: self.endDate)
        
        
        var userList = ""
        for member in listOfMember {
            let str = String(member.id) + ","
            userList += str
        }
        if userList == "" {
            DDAlert.alert(title: "提示", message: "请选择参与人员", dismissTitle: "好的", inViewController: self, withDismissAction: nil)
            return
        }
        userList.characters.removeLast()
        
        //备注
        let path2 = IndexPath(item: 0, section: 3)
        let cell2 = tableView.cellForRow(at: path2) as! ProfileCell
        let note = cell2.profileTextView.text

        let hud = showHudWith(view, animated: true, mode: .indeterminate, text: "")
        NetworkManager.sharedManager.saveTaskInBack(task.id,type:type, range: range, target: Int(target)!, startDate: startDate, endDate: endDate, userList: userList, note: note!) { (success, json, error) in
            
            if success == true {
                hud.hide(true, afterDelay: 1.0)
                self.taskSaveSuccessHandler?()
                self.navigationController?.popViewController(animated: true)
                
            }
            else {
                
            }
            
        }
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
    
    var rangeOptions = [TaskOptionList]()
    
    var typeOptions = [TaskOptionList]()
    
    var taskRange = TaskOption()
    
    var taskType  = TaskOption()
    
    var publishDate = Date()
    
    func getTaskOptions() {
        
        NetworkManager.sharedManager.getTaskOptions { (success, json, error) in
            
            if success == true {
                 self.makeTaskOptions(json!)
                
            }
            else {
                
            }
        }
    }
    
    func makeTaskOptions(_ data:JSON) {
        rangeOptions.removeAll()
        typeOptions.removeAll()
        if let rangeDatas = data["task_range"].array {
            let optionList = TaskOptionList()
            optionList.text = ""
            for rangeData in rangeDatas {
                
                let op = TaskOption()
                if let value = rangeData["value"].string {
                    op.value = value
                }
                
                if let text = rangeData["text"].string {
                    op.text = text
                }
                
                optionList.options.append(op)
            }
            rangeOptions.append(optionList)
            
        }
        
        
        if let typeDatas = data["task_type"].array {
            
            for array in typeDatas {
                let optionList = TaskOptionList()
                if let listText = array["text"].string {
                    optionList.text = listText
                }
                
                if let childrens = array["children"].array {
                    
                    for children in childrens {
                        
                        let op = TaskOption()
                        if let value = children["value"].string {
                            op.value = value
                        }
                        
                        if let text = children["text"].string {
                            op.text = text
                        }
                        
                        optionList.options.append(op)
                    }
                }
                
               typeOptions.append(optionList)
            }
            
            
        }
        
    }
    
    func setData() {
     
        taskRange = task.range
        taskType  = task.type
        target    = task.target
        
        beginDate = task.startDate
        endDate   = task.endDate
        publishDate = task.publishDate
        
        listOfMember = task.members
        
        remark = task.remark
        
        
    }

}

extension CreateTaskVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isShowDetail == true ? 5:4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //标题
            return 3
        }
        else if section == 1 {
            //开始时间,结束时间
            return 2
        }
        else if section == 2 {
            //发起者,参与者
            return 2
        }
        else if section == 3 {
            //备注
            return 1
        }
        else {
            //删除
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 3 {
            return 100
        }
        else {
            return 44
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                //标题
                let cell = tableView.dequeueReusableCell(withIdentifier: timeSelectCellId, for: indexPath) as! typeCell
                cell.leftLabel.text = "范围"
                cell.typeLabel.text = taskRange.text == "" ? "请选择":taskRange.text
                if isShowDetail == true {
                  cell.accessoryView = nil
                }
                else {
                  cell.accessoryView = UIImageView.xhAccessoryView()
                }
                
                return cell
            }
            else if indexPath.row == 1 {
                //标题
                let cell = tableView.dequeueReusableCell(withIdentifier: timeSelectCellId, for: indexPath) as! typeCell
                cell.leftLabel.text = "类型"
                cell.typeLabel.text = taskType.text == "" ? "请选择":taskType.text
                cell.accessoryView = UIImageView.xhAccessoryView()
                if isShowDetail == true {
                    cell.accessoryView = nil
                }
                else {
                    cell.accessoryView = UIImageView.xhAccessoryView()
                }
                return cell
                
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: remindCellId, for: indexPath) as! BasicInfoCell
                //位置
                cell.leftLabel.text = "目标"
                cell.rightTextField.placeholder = "请输入"
                cell.rightTextField.keyboardType = .numberPad
                cell.rightTextField.textColor = UIColor.init(hexString: "B2B2B2")
                if isShowDetail == true {
                    cell.rightTextField.isEnabled = false
                    
                    let fmt = NumberFormatter()
                    fmt.numberStyle = .decimal
                    
                    if let num = fmt.number(from: target) {
                        
                        let numString = fmt.string(from: num)
                        
                        cell.rightTextField.text = numString
                    }
                    
                    
                }
                else {
                    cell.rightTextField.isEnabled = true
                    
                }
                return cell
            }
            
            
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

            
            //默认情况
            if indexPath.row == 0 {
                return returnTextCellWith("开始", date: beginDate)
            }
            else {
                return returnTextCellWith("结束", date: endDate)
            }
            
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: timeSelectCellId, for: indexPath) as! typeCell
            if indexPath.row == 0 {
                cell.leftLabel.text = "发布时间"
                cell.accessoryView = nil
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM月dd日"
                
                cell.typeLabel.text = dateFormatter.string(from: publishDate)
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
                
                if isShowDetail == true {
                    cell.accessoryView = nil
                }
                else {
                    cell.accessoryView = UIImageView.xhAccessoryView()
                }
            }
            
            return cell
        }
        else if indexPath.section == 3 {
            //备注
            let cell = tableView.dequeueReusableCell(withIdentifier: remarkCellId, for: indexPath) as! ProfileCell
            cell.profileTextView.placeholder = "备注"
            
            if isShowDetail == true {
                cell.profileTextView.isEditable = false
                cell.profileTextView.text = remark
            }
            else {
                cell.profileTextView.isEditable = true
            }
            
            return cell
        }
        else {
            //删除
            let cell = UITableViewCell(style: .default, reuseIdentifier: "deleteCell")
            cell.selectionStyle = .none
            let button = UIButton(frame: cell.bounds)
            button.setTitle("删除任务", for: .normal)
            button.setTitleColor(UIColor.red, for: .normal)
            cell.addSubview(button)
            button.addTarget(self, action: #selector(CreateTaskVC.deleteTap), for: .touchUpInside)
            
            return cell
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isShowDetail == true  && indexPath.section != 4 {
            return
        }
        else {
            
        }
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0  {
                
                let vc = TaskOptionsVC()
                vc.data = rangeOptions
                vc.title = "范围"
                vc.optionSelectedHandler = {
                    (option) in
                    self.taskRange = option
                    self.tableView.reloadData()
                }
                navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 1 {
                
                let vc = TaskOptionsVC()
                vc.data = typeOptions
                vc.title = "类型"
                vc.optionSelectedHandler = {
                    (option) in
                    self.taskType = option
                    self.tableView.reloadData()
                }
                navigationController?.pushViewController(vc, animated: true)
            }
            else {
                
            }
        }
        else if indexPath.section == 1 {
            //时间section点击
            sectionOfTimeTapWith(tableView, indexPath: indexPath)
            
        }
        else if indexPath.section == 2 {
            if indexPath.row == 1 {
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
    
    
    func deleteTap() {
        
        
        let alert = UIAlertController(title: "提示", message: "确认删除任务吗?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler:  nil)
        
        let confirmAction = UIAlertAction(title: "删除", style: .destructive, handler: { (action) in
            
            //删除任务
            //TODO:
            let hud = showHudWith(self.view, animated: true, mode: .indeterminate, text: "")
            NetworkManager.sharedManager.deleteTaskTopInBack(self.task.id, completion: { (success, json, error) in
                hud.hide(true)
                if success == true {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                else {
                    
                }
            })
            
            
        })
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: 时间选择功能点如下.
    fileprivate func setMinimumDateWith(_ picker:UIDatePicker,date:Date?) {
        
        picker.minimumDate = date
        
    }
    
    fileprivate func convertDateToTextWith(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy年MM月dd日 ahh:mm"
        dateFormatter.dateFormat = "MM月dd日"
        
        return dateFormatter.string(from: date)
    }
    
    fileprivate func convertDateToTextWithOutDay(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM月dd日"
        
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
            let indexPath = IndexPath(row: 1, section: 1)
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
        
        if indexPath.row == 0 {
            //开始
            showEndTimePicker   = false
            showBeginTimePicker = true
            //不需要设置最早时间
            //开始时间的最早时间是当前时间.
            let date = beginDate
            datePicker.config.startDate = date
            setMinimumDateWith(datePicker.datePicker, date: nil)
            datePicker.show(inVC: self)
            
           
        }
        else {
            //结束
            showEndTimePicker   = true
            showBeginTimePicker = false
            let date = endDate
            datePicker.config.startDate = date
            setMinimumDateWith(datePicker.datePicker, date: date)
            datePicker.show(inVC: self)
            
            
        }
        
    }

   
}



extension CreateTaskVC: MIDatePickerDelegate {
    
    func miDatePicker(amDatePicker: MIDatePicker, didSelect date: Date) {
        
        dateChangeHandler(date)
        
    }
    func miDatePickerDidCancelSelection(amDatePicker: MIDatePicker) {
        // NOP
    }
    
}
