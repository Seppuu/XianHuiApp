//
//  AppDelegate.swift
//  XianHui
//
//  Created by Seppuu on 16/7/19.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import MBProgressHUD
import EBForeNotification
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var remotenoti:[NSObject: AnyObject]?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        ChatKitExample.invokeThisMethodInDidFinishLaunching()
        
        remotenoti = launchOptions
        
        let currentClientId = Defaults.clientId.value!
        if currentClientId != "" {

            User.setAlluserId()
            self.openLeanCloudIMWith(currentClientId)
        }
        else {
            
            showLoginVC()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.eBBannerViewDidTap(_:)), name: EBBannerViewDidClick, object: nil)
        
        
        return true

    }
    
    func showLoginVC() {
        
        let loginVC = LoginViewController()
        loginVC.clientIdHandler = {
            (clientId) in
            self.openLeanCloudIMWith(clientId)
        }
        
        self.window?.rootViewController = loginVC
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
    }
    
    func openLeanCloudIMWith(clientId:String) {
        
        LCCKUtil.showProgressText("open client ...", duration:10.0)
        
        ChatKitExample.invokeThisMethodAfterLoginSuccessWithClientId(clientId, success: {
            
            LCCKUtil.hideProgress()
            
            let tabBarControllerConfig = LCCKTabBarControllerConfig()
            
            self.window?.rootViewController = tabBarControllerConfig.tabBarController

            
            self.checkIfNeedPushVC()
            
            //self.getDailyMaxValue()
            
            }, failed: { (error) in
                
                LCCKUtil.hideProgress()
                
                print(error.description)
        })
    }
    
    func getDailyMaxValue() {
        
        NetworkManager.sharedManager.getDailyReportMaxVaule { (success, json, error) in
            if success == true {
                
            }
        }
    }
    
    func checkIfNeedPushVC() {
        
        if remotenoti != nil {
            
            // Extract the notification data
            if let notificationPayload = remotenoti![UIApplicationLaunchOptionsRemoteNotificationKey] {
                
                // Create a pointer to the Photo object
                if let type = notificationPayload["notice_type"] as? String {
                    
                    if type == "daily_report" {
                        
                    }
                    else if type == "project_plan" {
                        
                        let viewController = window?.visibleViewController!
                        let vc = MyWorkVC()
                        vc.title = "我的工作"
                        viewController!.navigationController?.pushViewController(vc, animated: true)
                    }
                    else if type == "common_notice" {
                        
                        
                    }
                    else {
                        
                    }
                    
                }
            }
        }
        
        remotenoti = nil
        
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        ChatKitExample.invokeThisMethodInDidRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func applicationWillResignActive(application: UIApplication) {
         ChatKitExample.invokeThisMethodInApplicationWillResignActive(application)
    }

    func applicationWillTerminate(application: UIApplication) {
       ChatKitExample.invokeThisMethodInApplicationWillTerminate(application)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        ChatKitExample.invokeThisMethodInApplication(application, didReceiveRemoteNotification: userInfo)
    }

    
    var appComeFromBack = false
    
    //这个方法只会在app,从后台进入前台是触发,第一次启动不会触发.
    func applicationWillEnterForeground(application: UIApplication) {
        
        appComeFromBack = true
    }
    
    
    //通知到达的时候,应用已经打开.
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        if appComeFromBack == true {
            
            pushToViewControllerWith(userInfo)
            
            appComeFromBack = false
        }
        else {
            //app 一直在前台
            EBForeNotification.handleRemoteNotification(userInfo, soundID: 1312)
            
        }

    }
    
    //本地模拟系统推送弹窗点击事件处理
    func eBBannerViewDidTap(noti:NSNotification) {
        if let data  = noti.object as? [NSObject : AnyObject] {
            
            pushToViewControllerWith(data)
        }
        else {
            
        }
    }
    
    func pushToViewControllerWith(data:[NSObject : AnyObject]) {
        
        
        if let userInfo = data as? [String : AnyObject] {
            
            if let type =  userInfo["notice_type"] as? String {
                if type == "daily_report" {
                    
                    
                }
                else if type == "project_plan" {
                    
                    let viewController = window?.visibleViewController!
                    let vc = MyWorkVC()
                    vc.title = "我的工作"
                    viewController!.navigationController?.pushViewController(vc, animated: true)
                }
                else if type == "common_notice" {
                    
                    
                }
                else {
                    
                }
                
            }
            
            
        }
        else {
            
        }

    }

}


public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

