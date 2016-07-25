//
//  MessageListVC.swift
//  XianHui
//
//  Created by Seppuu on 16/7/22.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import MJRefresh

class MessageListVC: LCCKConversationListViewController {
    
    var listModel: MessageListModel!
    
    var topTableView:UITableView!
    
    var topCellId = "LCCKConversationListCell"
    
    var topTitles = ["助手","提醒","任务"]

    override func viewDidLoad() {
        super.viewDidLoad()

        listModel = MessageListModel(conversationListViewController: self)
        
        setTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTableView() {
        
        self.tableView.delegate = listModel
        self.tableView.dataSource = listModel
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.listModel.refresh()
            
        })
        
        self.tableView.mj_header.beginRefreshing()
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        
        let cellHeight = LCCKConversationListCellDefaultHeight
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: cellHeight * 3))
        topView.backgroundColor = UIColor ( red: 0.5, green: 0.5, blue: 0.5, alpha: 0.29 )
        
        topTableView = getTopTableView(cellHeight * 3)
        topView.addSubview(topTableView)
        
        self.tableView.tableHeaderView = topView
        
    }
    
    func getTopTableView(height:CGFloat) -> UITableView {
        
        let tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, height), style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
        
    }

}

extension MessageListVC {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topTitles.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return LCCKConversationListCellDefaultHeight
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = MessageListCell.dequeueOrCreateCellByTableView(tableView)
        
        cell.nameLabel.text = topTitles[indexPath.row]
        cell.avatarImageView.backgroundColor = UIColor ( red: 0.9671, green: 0.8294, blue: 0.7451, alpha: 0.8 )
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.ddWidth/2
        cell.avatarImageView.layer.masksToBounds = true
        cell.timestampLabel.text = "20:47"
        
        return cell
    }
    
}
