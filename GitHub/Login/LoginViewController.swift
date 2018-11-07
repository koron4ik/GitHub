//
//  LoginViewController.swift
//  GitHub
//
//  Created by Vadim on 11/4/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var apiManager = APIManager()
    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView?.navigationDelegate = self
        
        if let url = apiManager.authorizeURL {
            let request = URLRequest(url: url)
            webView?.load(request)
        }
        view = webView
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.host == apiManager.host {
            if let code = url.query?.components(separatedBy: "code=").last {
                if let tokenUrl = apiManager.tokenURL {
                    var request = URLRequest(url: tokenUrl)
                    
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                    let params = [ "client_id" : apiManager.clientId,
                                   "client_secret" : apiManager.clientSecret,
                                   "code" : code ]
                    
                    request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data {
                            do {
                                if let content = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                    if let accessToken = content["access_token"] as? String {
                                        DispatchQueue.main.async {
                                            let menuTabBarController = MenuTabBarController()
                                            menuTabBarController.selectedViewController = menuTabBarController.viewControllers?.first
                                            menuTabBarController.newUser(accessToken: accessToken)
                                            self.present(menuTabBarController, animated: true, completion: nil)
                                        }
                                    }
                                }
                            } catch {}
                        }
                    }
                    task.resume()
                }
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}
    
    


