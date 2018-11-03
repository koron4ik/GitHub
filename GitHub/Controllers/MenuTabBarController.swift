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
        reposViewController.view.backgroundColor = .orange
        
        let searchViewController = SearchViewController()
        searchViewController.title = "Search"
        searchViewController.view.backgroundColor = .white
        
        let profileViewController = ProfileViewController()
        profileViewController.title = "Profile"
        profileViewController.view.backgroundColor = .red
        
        reposViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        profileViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        let controllers = [profileViewController, searchViewController, reposViewController]
        viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }
    

}
