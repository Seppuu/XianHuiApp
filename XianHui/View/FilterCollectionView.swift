//
//  FilterCollectionView.swift
//  MeiBu
//
//  Created by Seppuu on 16/7/13.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class FilterCollectionView: UIView {
    
    var cellID = "FilterCell"
    
    var titlesArray = [String]()
    
    var collectionView:UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.addSubview(collectionView)
        
        let nib = UINib(nibName: cellID, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellID)
        
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.reloadData()
    }
}

extension FilterCollectionView:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    // MARK: UICollectionView Methods
    func numberOfItemsInSection(_ section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FilterCell
        
        cell.titleLabel.text = titlesArray[(indexPath as NSIndexPath).row]
        
        //设置时间
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
