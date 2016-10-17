//
//  XHSideFilterView.swift
//  XianHui
//
//  Created by jidanyu on 2016/10/14.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit

class XHSideFilterDataModel: NSObject {
    
    var name = ""
    var id = ""
    
    var paramName = ""
    var selected = false
    
}

class XHSideFilterDataList: NSObject {
    
    var name = ""
    var list = [XHSideFilterDataModel]()
    
    var multipleSelectEnabled = false
}

class AllFilterButton:UIButton {
    
    var indexPath = NSIndexPath()
    var isShowAll = false
}

class XHSideFilterView: UIView {

    var collectionView:UICollectionView!
    
    var cellID = "FilterCell"
    
    let reuseIdentifierHeader = "XHCollectionViewHeader"
    
    var dataArray = [XHSideFilterDataList]()
    
    var reSetButton = UIButton()
    
    var confirmButton = UIButton()
    
    var filterSelected:((models:[XHSideFilterDataModel])->())?
    
    var confirmHandler:(()->())?
    
    var selectedModels = [XHSideFilterDataModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        setCollectionView()
        setBottom()
    }
    
    private func setCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        var frame = self.bounds
        frame.origin.y = 22
        frame.size.height -= (44 + 22 + 22)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsVerticalScrollIndicator = false
        self.addSubview(collectionView)
        
        
        let nib = UINib(nibName: cellID, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellID)
        
        let nib1 = UINib(nibName: reuseIdentifierHeader, bundle: nil)
        collectionView.registerNib(nib1, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifierHeader)

        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")

        collectionView.reloadData()
    }
    
    func setBottom() {
        
        reSetButton = UIButton()
        addSubview(reSetButton)
        reSetButton.snp_makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.width.equalTo(ddWidth/2)
            make.height.equalTo(44)
        }
        
        reSetButton.setTitle("重置", forState: .Normal)
        reSetButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        reSetButton.addTarget(self, action: #selector(XHSideFilterView.reSetButtonTap), forControlEvents: .TouchUpInside)
        reSetButton.backgroundColor = UIColor.whiteColor()
        
        confirmButton = UIButton()
        addSubview(confirmButton)
        confirmButton.snp_makeConstraints { (make) in
            make.right.bottom.equalTo(self)
            make.width.equalTo(ddWidth/2)
            make.height.equalTo(44)
        }
        
        confirmButton.setTitle("确认", forState: .Normal)
        confirmButton.addTarget(self, action: #selector(XHSideFilterView.confirmTap), forControlEvents: .TouchUpInside)
        confirmButton.backgroundColor = UIColor.init(hexString: "D3B88D")
        
        let line = UIView()
        addSubview(line)
        line.backgroundColor = UIColor.darkGrayColor()
        line.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-44)
            make.height.equalTo(0.5)
        }
        
        
    }
    
    func checkSelectedState() {
        //TODO:check if multiple select enable
        collectionView.reloadData()
        
    }
    
    func reSetButtonTap() {
        self.selectedModels.removeAll()
        
        filterSelected?(models:selectedModels)
    }
    
    func confirmTap() {
        
        confirmHandler?()
    }
    
    
    func updateFilterModels() {
        
        self.selectedModels.removeAll()
        
        for list in self.dataArray {
            
            for data in list.list {
                if data.selected == true {
                    
                   self.selectedModels.append(data)
                }

            }
        }
        
        filterSelected?(models:selectedModels)
    }
    
    var sectionsNeedShowAll = [Int]()
    
    func showAllSectionData(sender:AllFilterButton) {
        
        sender.isShowAll = !sender.isShowAll
        let indexPath = sender.indexPath
        if sender.isShowAll == true {
            sender.setTitle("收起", forState: .Normal)
            sectionsNeedShowAll.append(indexPath.section)
        }
        else  {
            sender.setTitle("展开", forState: .Normal)
            sectionsNeedShowAll.removeObject(indexPath.section)
        }
        
        self.collectionView.reloadData()
        
    }

}

extension XHSideFilterView:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    // MARK: UICollectionView Methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        //let threePiecesWidth = floor(self.ddWidth / 3.0 - ((10.0 / 3) * 2))
        
        let threePiecesWidth = floor((self.ddWidth - 4*10) / 3)
        
        return CGSizeMake(threePiecesWidth, 28)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    // 设置Header的尺寸
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSizeMake(screenWidth, 44)
    }
    
    //标题
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
      
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath)
    
        headerView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        let lblHeader = UILabel(frame: CGRectMake(15, 10, 100, 30))
        
        lblHeader.backgroundColor = UIColor.whiteColor()
        lblHeader.textColor = UIColor.darkTextColor()
        
        let list = dataArray[indexPath.section]
        lblHeader.text = list.name
        
        headerView.addSubview(lblHeader)
        
        let count = dataArray[indexPath.section].list.count
        if count > 6 {
            
            let rightButton = AllFilterButton(frame: CGRectMake(self.ddWidth - 40, 10, 40, 30))
            rightButton.indexPath = indexPath
            rightButton.titleLabel?.font = UIFont.systemFontOfSize(14)
            rightButton.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
            rightButton.addTarget(self, action: #selector(XHSideFilterView.showAllSectionData(_:)), forControlEvents: .TouchUpInside)
            headerView.addSubview(rightButton)
            
            var hasShowAll = false
            
            for secionShowAll in sectionsNeedShowAll {
                if indexPath.section == secionShowAll {
                    hasShowAll = true
                }
            }
            
            if hasShowAll == true {
                rightButton.setTitle("收起", forState: .Normal)
                rightButton.isShowAll = true
            }
            else {
                
                rightButton.setTitle("展开", forState: .Normal)
                rightButton.isShowAll = false
            }
        }
        else {
            
        }
    
        
       
        
        return headerView
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = dataArray[section].list.count
        var returnCount = 0
        
        var needShowAll = false
        
        for secionShowAll in sectionsNeedShowAll {
            if section == secionShowAll {
                needShowAll = true
            }
            
        }
        
        if needShowAll == true {
            returnCount = count
        }
        else {
            
            if count > 6 {
                returnCount = 6
            }
            else {
                returnCount = count
            }
            
        }
        
        return returnCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! FilterCell
        cell.backgroundColor = UIColor.init(hexString: "F1F2F6")
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
        
        cell.subviews.forEach { (view) in
            
            if view.tag == 10 {
                view.removeFromSuperview()
            }
        }
        
        let model = dataArray[indexPath.section].list[indexPath.row]
        
        cell.titleLabel.text = model.name
        let selectImage = UIImage(named: "filterCellSelected")
        let selectImgaeView = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
        selectImgaeView.tag = 10
        selectImgaeView.image = selectImage
        cell.addSubview(selectImgaeView)
        if model.selected == true {
            selectImgaeView.alpha = 1.0
        }
        else {
            selectImgaeView.alpha = 0.0
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //TODO:once selected one .reload all data ,check if multiple select enable
        let model = dataArray[indexPath.section].list[indexPath.row]
        model.selected = !model.selected
        
        updateFilterModels()
    }
    
}
