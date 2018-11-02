//
//  ViewController.swift
//  GitHub
//
//  Created by Vadim on 11/2/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class EnterViewController: UIViewController {

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
        button.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
        
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

    @objc func buttonClicked() {
        print("Clicked")
        animationButtonPressed()
    }
        
    func startRepeatingButtonAnimation() {
        signInButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 1.0,
            delay: 0.0,
            options: [.repeat, .autoreverse, .allowUserInteraction],
            animations: {
                self.signInButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        )
    }
    
    func beginButtonAnimation() {
        signInButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 2.0,
            delay: 0.2,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: {
                self.signInButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.startRepeatingButtonAnimation()
            }
        )
    }
    
    func animationButtonPressed() {
        signInButton.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.2,
            delay: 0.1,
            usingSpringWithDamping: 1.5,
            initialSpringVelocity: 0.0,
            animations: {
                self.signInButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.2)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.signInButton.transform = CGAffineTransform.identity
                }
            }
        )
    }
}

