//
//  BaseWebViewController.swift
//  DingDong
//
//  Created by Seppuu on 16/7/1.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController ,WKNavigationDelegate {
    
    var webView:WKWebView!
    var webTitle:String!
    var urlString:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: theConfiguration)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        title = webTitle
        
        let url = NSURL(string: self.urlString)!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    //MARK:WKWebView Method
    
}
