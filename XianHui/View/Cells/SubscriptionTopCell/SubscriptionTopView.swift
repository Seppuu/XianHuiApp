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
    
    var authorCellTapHandler:((authorID:String,authorName:String)->())?
    
    var cellTapHandler:((index:Int)->())?
    
    class func instanceFromNib() -> SubscriptionTopView {
        
        return UINib(nibName: "SubscriptionTopView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! SubscriptionTopView
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
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellID)
        
        collectionView.reloadData()
        
    }

    // MARK: UICollectionView Methods.
    
    func numberOfItemsInSection(section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(70, 70)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.0
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return namesOfForm.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! SubscriptionDetailCell
        
        cell.avatarView.backgroundColor = UIColor.init(hexString: "#6CC3EC")
        
        cell.typeLabel.font = UIFont.systemFontOfSize(12)
        cell.typeLabel.text = namesOfForm[indexPath.row]

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        cellTapHandler?(index:indexPath.row)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}



