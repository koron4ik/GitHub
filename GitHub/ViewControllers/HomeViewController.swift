//
//  ViewController.swift
//  GitHub
//
//  Created by Vadim on 11/2/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let githubLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "github_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let githubTextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "github_text_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "login"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:#selector(loginButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(githubLogoImageView)
        view.addSubview(githubTextImageView)
        view.addSubview(signInButton)
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        beginButtonAnimation()
    }
    
    @objc func loginButtonPressed() {        
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    private func setupConstraints() {
        signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width / 15).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.frame.width / 15)).isActive = true
        signInButton.heightAnchor.constraint(equalTo: signInButton.widthAnchor, multiplier: 1.0/6.0).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.bounds.height / 15)).isActive = true
        
        githubLogoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width / 3.5).isActive = true
        githubLogoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.frame.width / 3.5)).isActive = true
        githubLogoImageView.heightAnchor.constraint(equalTo: githubLogoImageView.widthAnchor, multiplier: 1.0).isActive = true
        githubLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 3.6).isActive = true

        githubTextImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width / 20).isActive = true
        githubTextImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.frame.width / 20)).isActive = true
        githubTextImageView.heightAnchor.constraint(equalTo: githubTextImageView.widthAnchor, multiplier: 1.0/3.0).isActive = true
        githubTextImageView.topAnchor.constraint(equalTo: githubLogoImageView.bottomAnchor, constant: 10.0).isActive = true
    }
}

