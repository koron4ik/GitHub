//
//  ViewController.swift
//  GitHub
//
//  Created by Vadim on 11/2/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    lazy var githubLogoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: (self.view.frame.size.width - 130) / 2, y: (self.view.frame.size.height - 300) / 2, width: 130, height: 130))
        
        imageView.image = UIImage(named: "github_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var githubTextImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: (self.view.frame.size.width - 300) / 2, y: (self.view.frame.size.height) / 2, width: 300, height: 100))
        
        imageView.image = UIImage(named: "github_text_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: (self.view.frame.size.width - 300) / 2, y: self.view.frame.size.height - 100, width: 300, height: 50)
        button.setImage(UIImage(named: "login"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:#selector(loginButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        self.view.addSubview(signInButton)
        self.view.addSubview(githubTextImageView)
        self.view.addSubview(githubLogoImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        beginButtonAnimation()
    }

    @objc func loginButtonPressed() {
        animationButtonPressed()
        
        let loginViewController = LoginViewController()
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = loginViewController
        
        
    }
}

