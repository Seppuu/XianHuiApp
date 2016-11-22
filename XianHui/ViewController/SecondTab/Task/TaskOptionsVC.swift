//
//  TaskOptionsVC.swift
//  XianHui
//
//  Created by jidanyu on 2016/11/11.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit


class TaskOption: NSObject {
    
    var text = ""
    var value = ""
    var selected = false
}

class TaskOptionList: NSObject {
    
    var text = ""
    var options = [TaskOption]()
}

class TaskOptionsVC: UIViewController {
    
    var tableView:UITableView!

    var data = [TaskOptionList]()
    
    var optionsSelected = [TaskOption]()
    
    var optionSelectedHandler:((_ option:TaskOption)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate   = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    

}

extension TaskOptionsVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].text
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "typeCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? typeCell
        if cell == nil {
            let nib = UINib(nibName: cellId, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: cellId)
            cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? typeCell
        }
        
        let option = data[indexPath.section].options[indexPath.row]
        
        if option.selected == true {
            cell?.accessoryType = .checkmark
        }
        else {
            cell?.accessoryType = .none
        }
        
        cell!.typeLabel.alpha = 0.0
        cell!.leftLabel.text = option.text
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        let option = data[indexPath.section].options[indexPath.row]
        if cell.accessoryType == .none {
            
            cell.accessoryType = .checkmark
            
           option.selected = true
            
            optionSelectedHandler?(option)
            
        }
        else {
            
            cell.accessoryType = .none
            
            option.selected = false
            
            optionSelectedHandler?(TaskOption())
        }

        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let option = data[indexPath.section].options[indexPath.row]
        
        option.selected = false
        
        tableView.reloadData()
    }
    


    
}
