//
//  HelpCenterViewController.swift
//  XianHui
//
//  Created by jidanyu on 2016/10/10.
//  Copyright © 2016年 mybook. All rights reserved.
//

import UIKit
import WebKit

class HelpCenterViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {

    var webView:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.UIDelegate = self
        
        if let url = NSURL(string: helperCenterUrl) {
            let request = NSMutableURLRequest(URL: url)
            
            webView.loadRequest(request)
        }
        
        setNavBar()
    }
    
    func setNavBar() {
        
        let rightItem = UIBarButtonItem(title: "返回", style: .Done, target: self, action: #selector(HelpCenterViewController.close))
        self.navigationItem.rightBarButtonItem = rightItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        title = webView.title
    }
    

}
