//
//  OpenURLFromQRCViewController.swift
//  MadeLive
//
//  Created by Mobile Dev on 05/02/20.
//  Copyright © 2020 Mobile Dev. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class OpenURLFromQRCViewController: UIViewController, WKNavigationDelegate, NVActivityIndicatorViewable {

    //Local Declarations & Vars
    var webView: WKWebView!
    var QRCUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = QRCUrl
        
        //Load Url
        let url = URL(string: QRCUrl)!
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
