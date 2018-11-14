//
//  MenuTabBarController.swift
//  GitHub
//
//  Created by Vadim on 11/3/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class MenuTabBarController: UITabBarController {
        
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
}
