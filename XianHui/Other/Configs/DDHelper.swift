//
//  DDHelper.swift
//  DingDong
//
//  Created by Seppuu on 16/4/15.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import Foundation
import RealmSwift
import MBProgressHUD

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func cleanRealmAndCaches() {
    
    // clean Realm
    
    guard let realm = try? Realm() else {
        return
    }
    
    let _ = try? realm.write {
        realm.deleteAll()
    }
    
    realm.refresh()
    
}


func isAppAlreadyLaunchedOnce()->Bool{
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    if let isAppAlreadyLaunchedOnce = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
        print("App already launched : \(isAppAlreadyLaunchedOnce)")
        return true
    }else{
        defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
        print("App launched first time")
        return false
    }
}


func cleanDiskCacheFolder() {
    
    let folderPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
    let fileMgr = NSFileManager.defaultManager()
    
    guard let fileArray = try? fileMgr.contentsOfDirectoryAtPath(folderPath) else {
        return
    }
    
    for filename in fileArray  {
        do {
            try fileMgr.removeItemAtPath(folderPath.stringByAppendingPathComponent(filename))
        } catch {
            print(" clean error ")
        }
        
    }
}



//HUD
func showHudWith(view:UIView,animated:Bool,mode:MBProgressHUDMode,text:String) {
    let hud = MBProgressHUD.showHUDAddedTo(view, animated: animated)
    hud.mode = mode
    hud.labelText = text
}


func hideHudFrom(view:UIView) {
    MBProgressHUD.hideHUDForView(view, animated: true)
}


