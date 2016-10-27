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
    
    var id:Int!
}



class MyWorkListHepler: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var dataArray = [MyWorkObject]()
    var cellHeight:CGFloat = 64
    var cellId = "MyWorkCell"
    
    var cellSelectedHandler:((_ index:Int,_ objectId:Int,_ objectName:String,_ obj:MyWorkObject)->())?

    override init() {
        super.init()
        
    }
    
   
    //tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MyWorkCell
        if cell == nil {
            let nib = UINib(nibName: cellId, bundle: nil)
            
            tableView.register(nib, forCellReuseIdentifier: cellId)
            
            cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MyWorkCell
        }
        
        cell?.selectionStyle = .none
        
        let obj = dataArray[(indexPath as NSIndexPath).row]
        
        if let url = URL(string:obj.leftImageUrl) {
            cell?.leftImageIView.kf.setImage(with: url)
        }
        
        cell?.leftImageIView.layer.cornerRadius = 25
        cell?.leftImageIView.layer.masksToBounds = true
        
        cell?.leftImageIView.backgroundColor = UIColor.lightGray
        
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let obj = self.dataArray[(indexPath as NSIndexPath).row]
        cellSelectedHandler?((indexPath as NSIndexPath).row,obj.id,obj.nameLabelString,obj)
        
    }
    
    
    
  
    
}
