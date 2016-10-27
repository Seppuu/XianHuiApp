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
        webView.uiDelegate = self
        
        if let url = URL(string: helperCenterUrl) {
            let request = NSMutableURLRequest(url: url)
            
            webView.load(request as URLRequest)
        }
        
        setNavBar()
    }
    
    func setNavBar() {
        
        let rightItem = UIBarButtonItem(title: "返回", style: .done, target: self, action: #selector(HelpCenterViewController.close))
        self.navigationItem.rightBarButtonItem = rightItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        title = webView.title
    }
    

}
