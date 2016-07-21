//
//  PhotoManager.swift
//  DingDong
//
//  Created by Seppuu on 16/5/18.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PhotoManager: NSObject {
    
    static var sharedManager = PhotoManager()
    
    //解析PHAsset到UIImage.
    func getAssetThumbnail(asset: PHAsset,completion:(image:UIImage)->()){
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        option.resizeMode  = .Fast
        
        manager.requestImageForAsset(asset, targetSize: CGSizeMake(1920,1080), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            
            let jepgData2 = UIImageJPEGRepresentation(result!, 0.1)
            
            let image = UIImage(data: jepgData2!)!
            
//            print("jepgData:\(jepgData?.length) ;jepgData2:\(jepgData2?.length) ; pngData:\(pngData?.length)")
            
            thumbnail = image
            
            completion(image: thumbnail)
        })
    }

    
}