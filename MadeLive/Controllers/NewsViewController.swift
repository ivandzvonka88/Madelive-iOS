//
//  NewsViewController.swift
//  MadeLive
//
//  Created by Mobile Dev on 30/01/20.
//  Copyright © 2020 Mobile Dev. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class NewsViewController: UIViewController, WKNavigationDelegate, NVActivityIndicatorViewable {

    //Local Declarations & Vars
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Load Url
        let url = URL(string: "https://made.live/news/")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    //Setup WebKit
    override func loadView() {
        self.startAnimating()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    //MARK: Webview Delegate methods
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.stopAnimating()
    }
}
