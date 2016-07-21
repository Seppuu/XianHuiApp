//
//  MenuSheetView.swift
//  DingDong
//
//  Created by Seppuu on 16/5/24.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit

class MenuSheetView: UIView ,UITableViewDelegate,UITableViewDataSource{

    var tableView:UITableView!
    
    private let sheetCellId = "SheetCell"
    
    private let titles = ["分享","取消"]
    
    //var deleteRecordHandler:(()->())?
    
    var shareTapHandler:(()->())?
    
    var cancelHandler:(()->())?
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setTableView()
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    
    func setTableView() {
        
        tableView = UITableView(frame:self.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        
        tableView.registerNib(UINib(nibName: sheetCellId, bundle: nil), forCellReuseIdentifier: sheetCellId)
        addSubview(tableView)
        
        tableView.reloadData()
    }
    
    
    //MARK: TableView 
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(sheetCellId) as! SheetCell
        
        cell.iconImageView.backgroundColor = UIColor.brownColor()
        cell.titleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            
            shareTapHandler?()
        }
        else if indexPath.row == 1 {
            cancelHandler?()
        }
    }
    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
