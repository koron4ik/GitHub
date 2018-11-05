//
//  MenuTabBarController.swift
//  GitHub
//
//  Created by Vadim on 11/3/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class MenuTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let reposViewController = ReposViewController()
        reposViewController.title = "Repositories"
        
        let searchViewController = SearchViewController()
        searchViewController.title = "Search"
        
        let profileViewController = ProfileViewController()
        profileViewController.title = "Profile"
        
        reposViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        profileViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        let controllers = [profileViewController, searchViewController, reposViewController]
        viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }
    

}
