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
    var disabled = false
}

class XHSideFilterDataList: NSObject {
    
    var name = ""
    var list = [XHSideFilterDataModel]()
    
    var multipleSelectEnabled = false
}

class AllFilterButton:UIButton {
    
    var indexPath = IndexPath()
    var isShowAll = false
}

class XHSideFilterView: UIView {

    var collectionView:UICollectionView!
    
    var cellID = "FilterCell"
    
    let reuseIdentifierHeader = "XHCollectionViewHeader"
    
    var dataArray = [XHSideFilterDataList]()
    
    var reSetButton = UIButton()
    
    var confirmButton = UIButton()
    
    var filterSelected:((_ models:[XHSideFilterDataModel])->())?
    
    var confirmHandler:(()->())?
    
    var selectedModels = [XHSideFilterDataModel]()
    
    var statusLabel = UILabel()
    
    var statusString = "" {
        didSet {
            statusLabel.text = statusString
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        setCollectionView()
        setBottom()
    }
    
    fileprivate func setCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var frame = self.bounds
        //frame.origin.x = 10
        frame.origin.y = 22
        frame.size.height -= (44 + 22 + 22)
        //frame.size.width  -= 20
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        self.addSubview(collectionView)
        
        
        let nib = UINib(nibName: cellID, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellID)
        
        let nib1 = UINib(nibName: reuseIdentifierHeader, bundle: nil)
        collectionView.register(nib1, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifierHeader)

        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")

        collectionView.reloadData()
    }
    
    func setBottom() {
        
        reSetButton = UIButton()
        addSubview(reSetButton)
        reSetButton.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.width.equalTo(ddWidth/2)
            make.height.equalTo(44)
        }
        
        reSetButton.setTitle("重置", for: UIControlState())
        reSetButton.setTitleColor(UIColor.darkText, for: UIControlState())
        reSetButton.addTarget(self, action: #selector(XHSideFilterView.reSetButtonTap), for: .touchUpInside)
        reSetButton.backgroundColor = UIColor.white
        
        confirmButton = UIButton()
        addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(self)
            make.width.equalTo(ddWidth/2)
            make.height.equalTo(44)
        }
        
        confirmButton.setTitle("确认", for: UIControlState())
        confirmButton.addTarget(self, action: #selector(XHSideFilterView.confirmTap), for: .touchUpInside)
        confirmButton.backgroundColor = UIColor.init(hexString: "D3B88D")
        
        let line = UIView()
        addSubview(line)
        line.backgroundColor = UIColor.darkGray
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-44)
            make.height.equalTo(0.5)
        }
        
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(line.snp.top)
            make.height.equalTo(21)
        }
        
        statusLabel.text = statusString
        statusLabel.textAlignment = .center
        statusLabel.textColor = UIColor.darkText
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.backgroundColor = UIColor.white
        
    }
    
    func checkSelectedState() {
        //TODO:check if multiple select enable
        collectionView.reloadData()
        
    }
    
    func reSetButtonTap() {
        self.selectedModels.removeAll()
        
        filterSelected?(selectedModels)
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
        
        filterSelected?(selectedModels)
    }
    
    var sectionsNeedShowAll = [Int]()
    
    func showAllSectionData(_ sender:AllFilterButton) {
        
        sender.isShowAll = !sender.isShowAll
        let indexPath = sender.indexPath
        if sender.isShowAll == true {
            sender.setTitle("收起", for: UIControlState())
            sectionsNeedShowAll.append((indexPath as NSIndexPath).section)
        }
        else  {
            sender.setTitle("展开", for: UIControlState())
            sectionsNeedShowAll.removeObject((indexPath as NSIndexPath).section)
        }
        
        self.collectionView.reloadData()
        
    }

}

extension XHSideFilterView:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    // MARK: UICollectionView Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //let threePiecesWidth = floor(self.ddWidth / 3.0 - ((10.0 / 3) * 2))
        
        let threePiecesWidth = floor(((self.ddWidth) - 4*10) / 3)
        
        return CGSize(width: threePiecesWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(3, 10, 0, 10)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    //上下间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    
    // 设置Header的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: screenWidth, height: 44)
    }
    
    //标题
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
      
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
    
        headerView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        let lblHeader = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 30))
        
        lblHeader.backgroundColor = UIColor.white
        lblHeader.textColor = UIColor.darkText
        
        let list = dataArray[(indexPath as NSIndexPath).section]
        lblHeader.text = list.name
        
        headerView.addSubview(lblHeader)
        
        let count = dataArray[(indexPath as NSIndexPath).section].list.count
        if count > 6 {
            
            let rightButton = AllFilterButton(frame: CGRect(x: self.ddWidth - 40 - 10, y: 10, width: 40, height: 30))
            rightButton.indexPath = indexPath
            rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            rightButton.setTitleColor(UIColor.darkText, for: UIControlState())
            rightButton.addTarget(self, action: #selector(XHSideFilterView.showAllSectionData(_:)), for: .touchUpInside)
            headerView.addSubview(rightButton)
            
            var hasShowAll = false
            
            for secionShowAll in sectionsNeedShowAll {
                if (indexPath as NSIndexPath).section == secionShowAll {
                    hasShowAll = true
                }
            }
            
            if hasShowAll == true {
                rightButton.setTitle("收起", for: UIControlState())
                rightButton.isShowAll = true
            }
            else {
                
                rightButton.setTitle("展开", for: UIControlState())
                rightButton.isShowAll = false
            }
        }
        else {
            
        }
        
        return headerView
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FilterCell
        
        cell.subviews.forEach { (view) in
            
            if view.tag == 10 || view.tag == 20 {
                view.removeFromSuperview()
            }
        }
        
        let model = dataArray[indexPath.section].list[indexPath.row]
        
        cell.titleLabel.text = model.name
        let selectImage = UIImage(named: "filterCellSelected")
        let selectImgaeView = UIImageView(frame: CGRect(x: 0, y: 6, width: 14, height: 14))
        selectImgaeView.tag = 10
        selectImgaeView.image = selectImage
        cell.addSubview(selectImgaeView)
        if model.selected == true {
            selectImgaeView.alpha = 1.0
        }
        else {
            selectImgaeView.alpha = 0.0
        }
        
        cell.titleLabel.layer.cornerRadius = 4
        cell.titleLabel.layer.masksToBounds = true
        
        let borderView = UIView(frame: CGRect(x: 0, y: 6, width: cell.ddWidth, height: cell.titleLabel.bounds.size.height))
        borderView.tag = 20
        borderView.layer.cornerRadius = 4
        borderView.layer.masksToBounds = true
        cell.addSubview(borderView)
        cell.insertSubview(borderView, at: 0)
        
        if model.disabled == true {
             borderView.backgroundColor = UIColor.white
             borderView.addDashedBorder(UIColor.init(hexString: "CACEDD"), lineWidth: 2.0)
        }
        else {
             borderView.backgroundColor = UIColor.init(hexString: "F1F2F6")
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO:once selected one .reload all data ,check if multiple select enable
        let model = dataArray[indexPath.section].list[indexPath.row]
        
        if model.disabled == true {
//            let hud = showHudWith(self, animated: true, mode: .Text, text: "条件不存在")
//            hud.hide(true, afterDelay: 1.5)
            return
        }
        else {
            model.selected = !model.selected
            
            updateFilterModels()
        }
        
        
    }
    
}
