//
//  AppDelegate.swift
//  XianHui
//
//  Created by Seppuu on 16/7/19.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import MBProgressHUD

import SwiftyJSON
import ChatKit

import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var app:UIApplication?
    
    var remoteNotiData:[AnyHashable: Any]?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        LCChatKit.sharedInstance().useDevPushCerticate = false
        ChatKitExample.invokeThisMethodInDidFinishLaunching()
        //ios 10 兼容
        replyPushNotificationAuthorization(application)
        
        if launchOptions != nil {
            if let notificationPayload = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.eBBannerViewDidTap(_:)), name: NSNotification.Name(rawValue: EBBannerViewDidClick), object: nil)
        
        
        return true

    }
    
    //ios 10 推送注册
    func replyPushNotificationAuthorization(_ application:UIApplication) {
        
        if #available(iOS 10.0, *) {
            let uncenter = UNUserNotificationCenter.current()
            
            uncenter.delegate = self
            
            uncenter.requestAuthorization(options: [.alert, .sound , .badge], completionHandler: { (granted, error) in
                
                
            })
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func showLoginVC(_ vc:UIViewController) {
        
        
        
        let loginVC = LoginViewController()
        //let nav = UINavigationController(rootViewController: loginVC)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.ownSystemLoginSuccess(_:)), name: OwnSystemLoginSuccessNoti, object: nil)
        vc.navigationController?.isNavigationBarHidden = false
        vc.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func showGuide() {
        
        self.window = UIWindow()
        self.window!.frame = UIScreen.main.bounds
        self.window?.makeKeyAndVisible()
        
        let vc = UIViewController()
        
        self.window?.rootViewController = vc
        // data source
        let backgroundImageNames = ["guide01","guide02", "guide03","guide04"]

        // Added Introduction View Controller
        let introductionVC = self.customButtonIntroductionView(backgroundImageNames)
        let nav = UINavigationController(rootViewController: introductionVC)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        
        introductionVC.didSelectedEnter = {
            //introductionVC.view.removeFromSuperview()
            
            self.showLoginVC(introductionVC)

        }
        
    }
    
    func customButtonIntroductionView(_ backImageNames:[String]) -> ZWIntroductionViewController {
        
        
        let vc = ZWIntroductionViewController(coverImageNames: backImageNames, backgroundImageNames: backImageNames, button: nil)
        
        return vc!
    }
    
    func ownSystemLoginSuccess(_ noti:Notification) {
        
        if let clientId = noti.object as? String {
            
            self.openLeanCloudIMWith(clientId,autoLogin:false)
        }
        
    }
    
    func openLeanCloudIMWith(_ clientId:String,autoLogin:Bool) {
        
        if let currentVC = self.window?.visibleViewController{
            let _ = showHudWith(currentVC.view, animated: true, mode: .indeterminate, text: "")
        }
        
        ChatKitExample.invokeThisMethodAfterLoginSuccess(withClientId: clientId, success: {
            
            if let currentVC = self.window?.visibleViewController{
                hideHudFrom(currentVC.view)
            }
                        
            let tabBarControllerConfig = LCCKTabBarControllerConfig()
            
            self.window?.rootViewController = tabBarControllerConfig.tabBarController
            
            self.appHasLoginSuccess = true
            
            if self.remoteNotiData != nil {
                self.application(self.app!, didReceiveRemoteNotification: self.remoteNotiData!, fetchCompletionHandler: { (result) in
                    
                })
                
            }
            
            //first launch
            let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
            if launchedBefore  {
                print("Not first launch.")
            }
            else {
                print("First launch, setting NSUserDefault.")
                self.setDailyReportMax()
                UserDefaults.standard.set(true, forKey: "launchedBefore")
            }
            
            }, failed: { (error) in
                
                print(error.debugDescription)
        })
    }
    
    func setDailyReportMax() {
        
        
        func makeMaxValueListWith(_ json:JSON) {
            var list = [MaxValue]()
            
            var maxValKey = ["cash_amount","project_amount","product_amount","room_turnover","employee_hours"]
            
            for i in 0..<maxValKey.count {
                
                let maxModel = MaxValue()
                let jsonName = maxValKey[i]
                
                let data = json[jsonName]
                
                if let value = data["value"].float {
                    maxModel.value = value
                }
                
                list.append(maxModel)
            }
            
            
            let cashMax = list[0].value
            let projectmax = list[1].value
            let prodMax = list[2].value
            let customerMax = list[3].value
            let employeemax = list[4].value
            
            Defaults.cashMaxValue.value = cashMax * 1000
            Defaults.projectMaxValue.value = projectmax * 1000
            Defaults.productMaxValue.value = prodMax * 1000
            Defaults.roomTurnoverMaxValue.value = customerMax
            Defaults.employeeHoursMaxValue.value = employeemax
            
        }

        
        NetworkManager.sharedManager.getDailyReportMaxVaule { (success, json, error) in
            if success == true {
                makeMaxValueListWith(json!)
                
            }
        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        ChatKitExample.invokeThisMethodInDidRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
         ChatKitExample.invokeThisMethod(inApplicationWillResignActive: application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
       ChatKitExample.invokeThisMethod(inApplicationWillTerminate: application)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        ChatKitExample.invokeThisMethod(in: application, didReceiveRemoteNotification: userInfo)
    }

    
    var appComeFromBack = false
    
    //这个方法只会在app,从后台进入前台是触发,第一次启动不会触发.
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        appComeFromBack = true
    }
    
    var appHasLoginSuccess = false
    
    //通知到达的时候,应用已经打开.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //如果此时app没有完全登陆成功.return.
        guard appHasLoginSuccess == true else {return}
        
        //NotificationCenter.default.post(name: Notification.Name(rawValue: NoticeComingNoti), object: userInfo)
        
        if appComeFromBack == true {
            
            pushToViewControllerWith(userInfo)
            
            appComeFromBack = false
        }
        else {
            //app 一直在前台
            EBForeNotification.handleRemoteNotification(userInfo, soundID: 1312, isIos10: false)
            
        }

    }
    
    //本地模拟系统推送弹窗点击事件处理
    func eBBannerViewDidTap(_ noti:Notification) {
        if let data  = noti.object as? [AnyHashable: Any] {
            pushToViewControllerWith(data)
        }
        else {
            
        }
    }
    
    func pushToViewControllerWith(_ data:[AnyHashable: Any]) {
        
        
        if let userInfo = data as? [String : AnyObject] {
            
            if let type =  userInfo["notice_type"] as? String {
                if type == "daily_report" {
                    
                    if let time = userInfo["notice_time"] as? String {
                        
                        Defaults.MessageListHelperLastTime.value = time
                    }
                    
                    let viewController = window?.visibleViewController!
                    let vc = DailyFormVC()
                    
                    if let noticeId = userInfo["notice_id"] as? String {
                        
                        vc.noticeId = noticeId.toInt()!
                        vc.title = "日报表"
                        viewController!.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    
                }
                else if type == "project_plan" {
                    
                    if let time = userInfo["notice_time"] as? String {
                        
                        Defaults.MessageListHelperLastTime.value = time
                    }
                    
                    let viewController = window?.visibleViewController!
                    let vc = MyWorkVC()
                    vc.title = "我的工作"
                    viewController!.navigationController?.pushViewController(vc, animated: true)
                }
                else if type == "common_notice" {
                    
                    if let time = userInfo["notice_time"] as? String {
                        
                        Defaults.MessageListRemiandLastTime.value = time
                    }
                    
                }
                else {
                    
                }
                
            }
            
            
        }
        else {
            
        }

    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /**
     * Required for iOS 10+
     * 在前台收到推送内容, 执行的方法
     */
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        EBForeNotification.handleRemoteNotification(userInfo, soundID: 1312, isIos10: true)
        
       // NotificationCenter.default.post(name: Notification.Name(rawValue: NoticeComingNoti), object: userInfo)
    }
    
    /**
     * Required for iOS 10+
     * 在后台和启动之前收到推送内容, 执行的方法
     */
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        LCChatKit.sharedInstance().didReceiveRemoteNotification(userInfo)
        
        pushToViewControllerWith(userInfo)
        
       // NotificationCenter.default.post(name: Notification.Name(rawValue: NoticeComingNoti), object: userInfo)
    }
    
}


public extension UIWindow {
    //当前可见的ViewController
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
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

