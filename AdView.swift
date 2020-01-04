//
//  AdView.swift
//  MyPastPapers
//
//  Created by Hassan Abbasi on 20/12/2019.
//  Copyright © 2019 Rove. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class AdView:UIView {
    
    
     lazy var webView:WKWebView = {
        let source: String = "var meta = document.createElement('meta');" +
                   "meta.name = 'viewport';" +
                   "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
                   "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";

               let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
               let userContentController: WKUserContentController = WKUserContentController()
               let conf = WKWebViewConfiguration()
               conf.userContentController = userContentController
               userContentController.addUserScript(script)
        let view = WKWebView(frame: CGRect.zero, configuration: conf)
        
        
       
        
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.scalesPageToFit = false
        view.isMultipleTouchEnabled = false
        view.scrollView.isScrollEnabled = false
        view.allowsLinkPreview = false
        view.navigationDelegate = self
        view.scrollView.delegate = self
        return view
    }()
    
    
    func loadAd(url:URL){
         let request = URLRequest(url: url)
         webView.load(request)
     }
     
     func loadAd(data:Data){
         webView.loadHTMLString(String(decoding: data, as: UTF8.self), baseURL: nil)
     }
     
    
    
        override init(frame: CGRect) {
            super.init(frame:frame)
            setupViews()
        }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
        
    
    func setupViews(){}
    
}
extension AdView:WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                let _ = url.host,
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                //print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                //  print("Open it locally")
                decisionHandler(.cancel)
            }
        } else {
            //print("not a user click")
            decisionHandler(.allow)
        }
    }
    
}

extension AdView:UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
