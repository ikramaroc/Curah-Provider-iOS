//
//  WebViewVC.swift
//  Curah Provider
//
//  Created by Netset on 25/10/18.
//  Copyright © 2018 Netset. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: BaseClass,WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var  url = String()
    var navTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarWithBackBtnAndTitle(title: navTitle)
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        self.webView.navigationDelegate = self
        
        let urlLink = URL (string: url)
        let request = URLRequest(url: urlLink!)
        self.webView.load(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        APIManager().showHud()

        print("Start to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
          APIManager().hideHud()
        print("finish to load")
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        APIManager().showHud()
        print("WEB VIEW Start Loading...")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
         APIManager().hideHud()
  }

}
