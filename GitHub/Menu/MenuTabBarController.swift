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
    
    var profileViewController = ProfileViewController()
    var searchViewController = SearchViewController()
    var bookmarksViewController = BookmarkViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileViewController.setupViewController(title: "Profile", tabBarImageName: "profile", tag: 0)
        searchViewController.setupViewController(title: "Search", tabBarImageName: "search", tag: 1)
        bookmarksViewController.setupViewController(title: "Bookmarks", tabBarImageName: "bookmark", tag: 2)
        
        viewControllers = [profileViewController, searchViewController, bookmarksViewController].map {
            UINavigationController(rootViewController: $0)
        }
    }

    func newUser(accessToken: String) {
        if let url = apiManager.userURL {
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response, error in
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
            }.resume()
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

extension UIViewController {
    
    func setupViewController(title: String, tabBarImageName: String, tag: Int) {
        let tabBarImage = UIImage(named: tabBarImageName)?.resizeImage(targetSize: CGSize(width: 30, height: 30))
        
        self.title = title
        self.tabBarItem = UITabBarItem(title: title, image: tabBarImage, tag: tag)
    }
}
