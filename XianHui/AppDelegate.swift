//
//  AppDelegate.swift
//  XianHui
//
//  Created by Seppuu on 16/7/19.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        ChatKitExample.invokeThisMethodInDidFinishLaunching()
        
        let currentClientId = Defaults.clientId.value!
        if currentClientId != "" {

            User.setAlluserId()
            self.openLeanCloudIMWith(currentClientId)
        }
        else {
            
            showLoginVC()
        }
        
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
            
            }, failed: { (error) in
                
                LCCKUtil.hideProgress()
                
                print(error.description)
        })
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


}

