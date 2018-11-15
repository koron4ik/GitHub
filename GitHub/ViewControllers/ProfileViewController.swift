//
//  ProfileViewController.swift
//  GitHub
//
//  Created by Vadim on 11/3/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit
import WebKit

class ProfileViewController: UIViewController {
    
    private var apiManager = APIManager()
    private var user: Owner?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    private let userView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 223/255, green: 60/255, blue: 22/255, alpha: 0.85)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let followersLabel = FollowingLabel(text: "Followers\n")
    private let followingLabel = FollowingLabel(text: "Following\n")
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.init(red: 117/255, green: 211/255, blue: 106/255, alpha: 0.7)
        button.layer.borderWidth = 1
        button.addTarget(self, action:#selector(logoutButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private let activityIndicator = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(red: 119/255, green: 141/255, blue: 196/255, alpha: 1)
        
        activityIndicator.center = view.center
        activityIndicator.start()
        
        userView.addSubview(nicknameLabel)
        userView.addSubview(profileImageView)
        view.addSubview(userView)
        view.addSubview(followersLabel)
        view.addSubview(followingLabel)
        view.addSubview(activityIndicator)
        view.addSubview(logoutButton)
    }
    
    public func newUser(accessToken: String) {
        if let url = apiManager.userURL {
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                        self.user = try? JSONDecoder().decode(Owner.self, from: data)
                        DispatchQueue.main.async {
                            self.loadUserView()
                    }
                }
            }.resume()
        }
    }
    
    private func loadUserView() {
        setupConstraints()
        
        setupProfileImageView()
        setupUserNickName()
        setupFollowersLabel()
        setupFollowingLabel()
        
        activityIndicator.stop()
    }
    
    private func setupConstraints() {
        userView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        userView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        userView.topAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!).isActive = true
        userView.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
        
        profileImageView.centerXAnchor.constraint(equalTo: userView.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: userView.topAnchor, constant: 20).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 1).isActive = true
        
        nicknameLabel.leadingAnchor.constraint(equalTo: userView.leadingAnchor).isActive = true
        nicknameLabel.trailingAnchor.constraint(equalTo: userView.trailingAnchor).isActive = true
        nicknameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nicknameLabel.bottomAnchor.constraint(equalTo: userView.bottomAnchor, constant: -20).isActive = true
        nicknameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20.0).isActive = true
        
        followersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        followersLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        followersLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        followersLabel.topAnchor.constraint(equalTo: userView.bottomAnchor).isActive = true
        
        followingLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        followingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        followingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        followingLabel.topAnchor.constraint(equalTo: userView.bottomAnchor).isActive = true
        
        logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height / 10)).isActive = true
    }
    
    @objc func logoutButtonPressed() {
        cleanUserInfo()
        setHomePage()
    }
    
    private func cleanUserInfo() {
        let data = WKWebsiteDataStore.default()
        data.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            data.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records.filter { $0.displayName.contains("github")}, completionHandler: { })
        }
    }
    
    private func setHomePage() {
        self.tabBarController?.navigationController?.popViewController(animated: true)
    }
    
    private func setupFollowersLabel() {
        if let followers = user?.followers {
            followersLabel.text? += String(followers)
        }
    }
    
    private func setupFollowingLabel() {
        if let following = user?.following {
            followingLabel.text? += String(following)
        }
    }
    
    private func setupUserNickName() {
        if let login = user?.login {
            nicknameLabel.text = login
        }
    }
    
    private func setupProfileImageView() {
        if let avatarUrl = user?.avatar_url {
            let size = profileImageView.frame.size
            guard let image = UIImage.loadImage(withURL: avatarUrl, targetSize: size) else { return }
            profileImageView.image = image
        }
    }
}
