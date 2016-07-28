//
//  AppDelegate.swift
//  XianHui
//
//  Created by Seppuu on 16/7/19.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        IQKeyboardManager.sharedManager().enable = true
        
        LCChatKitExample.invokeThisMethodInDidFinishLaunching()
        
        let loginVC = LoginViewController()
        loginVC.clientIdHandler = {
            (clientId) in
            LCCKUtil.showProgressText("open client ...", duration:10.0)
            
            LCChatKitExample.invokeThisMethodAfterLoginSuccessWithClientId(clientId, success: {
                
                LCCKUtil.hideProgress()
                
                let tabBarControllerConfig = LCCKTabBarControllerConfig()
                
                self.window?.rootViewController = tabBarControllerConfig.tabBarController
                
                }, failed: { (error) in
                    
                    LCCKUtil.hideProgress()
                    
                    print(error.description)
            })
            
            
        }
        
        self.window?.rootViewController = loginVC
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        
        return true

    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        LCChatKitExample.invokeThisMethodInDidRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func applicationWillResignActive(application: UIApplication) {
         LCChatKitExample.invokeThisMethodInApplicationWillResignActive(application)
    }

    func applicationWillTerminate(application: UIApplication) {
       LCChatKitExample.invokeThisMethodInApplicationWillTerminate(application)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        LCChatKitExample.invokeThisMethodInApplication(application, didReceiveRemoteNotification: userInfo)
    }


}

