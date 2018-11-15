//
//  UIVIewController+setupViewController.swift
//  GitHub
//
//  Created by Vadim on 11/12/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupViewController(title: String, tabBarImageName: String, tag: Int) {
        let tabBarImage = UIImage(named: tabBarImageName)?.resizeImage(targetSize: CGSize(width: 30, height: 30))
        
        self.title = title
        self.tabBarItem = UITabBarItem(title: title, image: tabBarImage, tag: tag)
    }
}
