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
import ZWIntroductionViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var app:UIApplication?
    
    var remoteNotiData:[NSObject: AnyObject]?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        ChatKitExample.invokeThisMethodInDidFinishLaunching()
        
        if launchOptions != nil {
            if let notificationPayload = launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject: AnyObject] {
                app = application
                remoteNotiData = notificationPayload
            }
            
        }
        else {
            
        }
        
        let currentClientId = Defaults.clientId.value!
        if currentClientId != "" {
            
            User.setAlluserId()
            self.openLeanCloudIMWith(currentClientId,autoLogin:true)
        }
        else {
            
            showGuide()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.eBBannerViewDidTap(_:)), name: EBBannerViewDidClick, object: nil)
        
        
        return true

    }
    
    func showLoginVC() {
        
        let loginVC = LoginViewController()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.ownSystemLoginSuccess(_:)), name: OwnSystemLoginSuccessNoti, object: nil)
        
        self.window?.rootViewController = loginVC
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
    }
    
    func showGuide() {
        
        self.window = UIWindow()
        self.window!.frame = UIScreen.mainScreen().bounds
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = UIViewController()
        // data source
        let backgroundImageNames = ["guide01","guide02", "guide03","guide04"]

        // Added Introduction View Controller
        let introductionView = self.customButtonIntroductionView(backgroundImageNames)
        
        self.window?.addSubview(introductionView.view)
        
        introductionView.didSelectedEnter = {
            introductionView.view.removeFromSuperview()
            
            self.showLoginVC()
        }
        
    }
    
    func customButtonIntroductionView(backImageNames:[String]) -> ZWIntroductionViewController {
        let enterButton = UIButton()
        enterButton.setTitleColor(UIColor.init(hexString:"1480E2"), forState: .Normal)
        enterButton.setTitle("开始", forState: .Normal)
        let vc = ZWIntroductionViewController(coverImageNames: backImageNames, backgroundImageNames: backImageNames, button: enterButton)
        return vc
    }
    
    func ownSystemLoginSuccess(noti:NSNotification) {
        
        if let clientId = noti.object as? String {
            
            self.openLeanCloudIMWith(clientId,autoLogin:false)
        }
        
    }
    
    func openLeanCloudIMWith(clientId:String,autoLogin:Bool) {
        
        
        ChatKitExample.invokeThisMethodAfterLoginSuccessWithClientId(clientId, success: {
                        
            let tabBarControllerConfig = LCCKTabBarControllerConfig()
            
            self.window?.rootViewController = tabBarControllerConfig.tabBarController
            
            self.appHasLoginSuccess = true
            
            if self.remoteNotiData != nil {
                self.application(self.app!, didReceiveRemoteNotification: self.remoteNotiData!, fetchCompletionHandler: { (result) in
                    
                })
                
            }
            
            //first launch
            let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
            if launchedBefore  {
                print("Not first launch.")
            }
            else {
                print("First launch, setting NSUserDefault.")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
            }
            
            }, failed: { (error) in
                
                print(error.description)
        })
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
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
    
    var appHasLoginSuccess = false
    
    //通知到达的时候,应用已经打开.
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        //如果此时app没有完全登陆成功.return.
        guard appHasLoginSuccess == true else {return}
        
        NSNotificationCenter.defaultCenter().postNotificationName(NoticeComingNoti, object: userInfo)
        
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
                    
                    let viewController = window?.visibleViewController!
                    let vc = DailyFormVC()
                    
                    if let noticeId = userInfo["notice_id"] as? String {
                        
                        vc.noticeId = noticeId.toInt()!
                        vc.title = "日报表"
                        viewController!.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    
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
    //当前可见的ViewController
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

