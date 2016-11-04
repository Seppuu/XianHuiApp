//
//  MessageListModel.swift
//  XianHui
//
//  Created by Seppuu on 16/7/22.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import ChatKit

class MessageListModel: LCCKConversationListViewModel {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
}
