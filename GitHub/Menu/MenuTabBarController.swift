//
//  MenuTabBarController.swift
//  GitHub
//
//  Created by Vadim on 11/3/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class MenuTabBarController: UITabBarController {
    
    var user: User?
    var apiManager = APIManager()
    var controllers = [UIViewController]()
    
    let reposViewController = BookmarkViewController()
    let searchViewController = SearchViewController()
    let profileViewController = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reposViewController.title = "Repositories"
        searchViewController.title = "Search"
        profileViewController.title = "Profile"
        
        reposViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        profileViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        controllers = [profileViewController, searchViewController, reposViewController]
        viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }

    func newUser(accessToken: String) {
        if let url = apiManager.userURL {
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                            DispatchQueue.main.async() {
                                self.user = User(accessToken: accessToken)
                                self.parseJSON(json: json)
                            }
                        }
                    } catch {}
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(json: [String: Any]) {
        if let info = json["login"] {
            if let info = info as? String {
                user?.login = info
            }
        }
        if let info = json["avatar_url"] {
            if let info = info as? String {
                user?.avatarUrl = info
            }
        }
        profileViewController.user = user
    }
}
