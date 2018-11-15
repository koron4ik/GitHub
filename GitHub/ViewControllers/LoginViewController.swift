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

    private var apiManager = APIManager()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false

        return webView
    }()
    
    private let activityIndicator = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        
        loadWebSite()
        activityIndicator.center = view.center
        activityIndicator.start()
        
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        setupConstraints()
    }
    
    private func loadWebSite() {
        if let url = apiManager.authorizeURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func setupConstraints() {
        
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicator.start()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stop()
    }
    
    func presentTabBarController(accessToken: String) {
        self.navigationController?.isNavigationBarHidden = true
        let menuTabBarController = MenuTabBarController()
        self.navigationController?.pushViewController(menuTabBarController, animated: true)
        self.navigationController?.viewControllers.remove(at: 1)
        menuTabBarController.profileViewController.newUser(accessToken: accessToken)
        menuTabBarController.userRepositoriesViewController.getRepositories(accessToken: accessToken)
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
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data {
                            do {
                                if let content = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                    if let accessToken = content["access_token"] as? String {
                                        DispatchQueue.main.async {
                                            self.presentTabBarController(accessToken: accessToken)
                                        }
                                    }
                                }
                            } catch {}
                        }
                    }.resume()
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
    
    


