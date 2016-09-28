//
//  MyWorkListModel.swift
//  XianHui
//
//  Created by jidanyu on 2016/9/28.
//  Copyright © 2016年 mybook. All rights reserved.
//

import Foundation

class MyWorkObject:NSObject {
    
    var leftImageUrl = ""
    var nameLabelString = ""
    var nameDetailString = ""
    
    var firstTagImage = UIImage()
    var secondTagImage = UIImage()
    var thirdTagImage = UIImage()
    
    var firstTagString = ""
    var secondTagString = ""
    var thirdTagString = ""
    
    var rightLabelString = ""
}



class MyWorkListHepler: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var dataArray = [MyWorkObject]()
    var cellHeight:CGFloat = 64
    var cellId = "MyWorkCell"
    
    var cellSelectedHandler:(()->())?
    
    override init() {
        super.init()
        
    }
    
   
    //tableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? MyWorkCell
        if cell == nil {
            let nib = UINib(nibName: cellId, bundle: nil)
            
            tableView.registerNib(nib, forCellReuseIdentifier: cellId)
            
            cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? MyWorkCell
        }
        
        cell?.selectionStyle = .None
        
        let obj = dataArray[indexPath.row]
//        
//        if let url = NSURL(string:) {
//            cell?.leftImageIView.kf_setImageWithURL(url)
//        }
        
        cell?.leftImageIView.layer.cornerRadius = 25
        cell?.leftImageIView.layer.masksToBounds = true
        
        cell?.leftImageIView.backgroundColor = UIColor.lightGrayColor()
        
        cell?.nameLabel.text = obj.nameLabelString
        
        cell?.firstTagImageView.image = obj.firstTagImage
        cell?.secondTagImageView.image = obj.secondTagImage
        cell?.thirdTagImageView.image = obj.thirdTagImage
        
        cell?.firstTagLabel.text = obj.firstTagString
        cell?.secondTagLabel.text = obj.secondTagString
        cell?.thirdTagLabel.text = obj.thirdTagString
        
        cell?.rightLabel.text = obj.rightLabelString
        
        
        
       return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO:
        
        cellSelectedHandler?()
        
    }
    
    
    
  
    
}
