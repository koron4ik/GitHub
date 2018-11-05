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

    var user: User?
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
        //print("url - ", navigationAction.request.url ?? "nil")
        //print("host - ", navigationAction.request.url?.host ?? "nil")
        
        if let url = navigationAction.request.url, url.host == apiManager.host {
            //print("URL - ", url)
            if let code = url.query?.components(separatedBy: "code=").last {
                if let tokenUrl = apiManager.tokenURL {
                    var request = URLRequest(url: tokenUrl)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    let params = [
                        "client_id" : apiManager.clientId,
                        "client_secret" : apiManager.clientSecret,
                        "code" : code
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data {
                            do {
                                if let content = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                    if let accessToken = content["access_token"] as? String {
                                        //print("TOKEN - ", accessToken)
                                        self.getUser(accessToken: accessToken)
                                        
                                        let menuTabBarController = MenuTabBarController()
                                        menuTabBarController.selectedViewController = menuTabBarController.viewControllers?.first
                                        self.present(menuTabBarController, animated: true, completion: nil)
                                    }
                                }
                            } catch {}
                        }
                    }
                    task.resume()
                }
                decisionHandler(WKNavigationActionPolicy.cancel)
            } else {
                decisionHandler(WKNavigationActionPolicy.allow)
            }
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
    
    func getUser(accessToken: String) {
        if let url = apiManager.userURL {
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    print(String(data: data, encoding: String.Encoding.utf8) ?? "nil")
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                            if let login = json["login"] {
                                //DispatchQueue.main.async() {
                                if let login = login as? String {
                                    self.user = User(login: login, accessToken: accessToken)
                                    print("access_token received", self.user?.accessToken, "for user", self.user?.login)
                                }
                                //}
                            }
                        }
                    } catch {}
                }
            }
            task.resume()
        }
    }
    
}
    
    


