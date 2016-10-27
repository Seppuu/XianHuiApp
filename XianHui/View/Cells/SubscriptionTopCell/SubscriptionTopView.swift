//
//  SubscriptionTopView.swift
//  DingDong
//
//  Created by Seppuu on 16/5/30.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubscriptionTopView: UIView,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellID = "SubscriptionDetailCell"
    
    var photos = [UIImage]()
    
    var namesOfForm = [String]()
    
    var authorCellTapHandler:((_ authorID:String,_ authorName:String)->())?
    
    var cellTapHandler:((_ index:Int)->())?
    
    class func instanceFromNib() -> SubscriptionTopView {
        
        return UINib(nibName: "SubscriptionTopView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SubscriptionTopView
    }
    
    override func didMoveToWindow() {
        super.didMoveToSuperview()
        setCollectionview()
    }
    
    func setCollectionview() {
        
        collectionView.frame = self.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.ddViewBackGroundColor()
    
        let nib = UINib(nibName: cellID, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellID)
        
        collectionView.reloadData()
        
    }

    // MARK: UICollectionView Methods.
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return namesOfForm.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SubscriptionDetailCell
        
        cell.avatarView.backgroundColor = UIColor.init(hexString: "#6CC3EC")
        
        cell.typeLabel.font = UIFont.systemFont(ofSize: 12)
        cell.typeLabel.text = namesOfForm[(indexPath as NSIndexPath).row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        cellTapHandler?((indexPath as NSIndexPath).row)
    }


}



