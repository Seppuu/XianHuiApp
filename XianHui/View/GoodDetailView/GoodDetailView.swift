//
//  GoodDetailView.swift
//  XianHui
//
//  Created by jidanyu on 16/8/26.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class GoodDetailView: UIView {

    
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var thirdLabel: UILabel!
    
    @IBOutlet weak var forthLabel: UILabel!
    
    var cardList = [GoodCard]()
    
    @IBOutlet weak var detailTableView: UITableView!
    
    
    class func instanceFromNib() -> GoodDetailView {
        
        return UINib(nibName: "GoodDetail", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GoodDetailView
    }
    
    override func didMoveToSuperview() {
        makeUI()
    }
    
    func makeUI() {
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.isScrollEnabled = false
        detailTableView.tableFooterView = UIView()
        
        
        firstLabel.text = "卡名"
        
        
        secondLabel.text = "卡类型"
        
        
        
        thirdLabel.text = "价格"
        
        
        forthLabel.text = "余次"
        
        
    }
    
}

extension GoodDetailView: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        let detailView = GoodDetailContainerView.instanceFromNib()
        detailView.frame = cell.bounds
        cell.addSubview(detailView)
        
        let card = cardList[(indexPath as NSIndexPath).row]
        
        detailView.firstLabel.text = card.cardName
        detailView.secondLabel.text = card.cardType
        detailView.thirdLabel.text = card.cardPrice
        detailView.forthLabel.text = "\(card.cardTimesLeft)"
        
        return cell
        
    }
    
    
    
}

