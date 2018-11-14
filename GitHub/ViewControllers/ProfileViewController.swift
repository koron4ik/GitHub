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
    
    private var profileImageView: UIImageView?
    private var nicknameLabel: UILabel?
    
    private var user: Owner?
    private var accessToken: String?
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logout"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:#selector(logoutButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private let activityIndicator = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        activityIndicator.center = view.center
        activityIndicator.start()
        
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
                    if let user = try? JSONDecoder().decode(Owner.self, from: data) {
                        DispatchQueue.main.async {
                            self.accessToken = accessToken
                            self.user = user
                            self.loadUserView()
                        }
                    }
                }
            }.resume()
        }
    }
    
    private func loadUserView() {
        if let avatarUrl = user?.avatar_url {
            setupProfileImageView(withImageURL: avatarUrl)
        }
        
        if let login = user?.login {
            setupUserNickName(withText: login)
        }
        self.activityIndicator.stop()
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width / 10).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.frame.width / 10)).isActive = true
        logoutButton.heightAnchor.constraint(equalTo: logoutButton.widthAnchor, multiplier: 1.0/6.0).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.bounds.height / 8)).isActive = true
        
        profileImageView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView?.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 6).isActive = true

        nicknameLabel?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nicknameLabel?.topAnchor.constraint(equalTo: profileImageView?.bottomAnchor ?? view.topAnchor, constant: 20.0).isActive = true
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
    
    private func setupUserNickName(withText login: String) {
        let textSize = login.sizeOfString(usingFont: UIFont.boldSystemFont(ofSize: 30))
        nicknameLabel = UILabel()
        nicknameLabel?.frame.size = CGSize(width: textSize.width, height: textSize.height)
        nicknameLabel?.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel?.text = login
        nicknameLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        nicknameLabel?.textAlignment = .center
        nicknameLabel?.isUserInteractionEnabled = false
        
        if let nicknameLabel = nicknameLabel {
            view.addSubview(nicknameLabel)
        }
    }
    
    private func setupProfileImageView(withImageURL urlPath: String) {
        let size = CGSize(width: view.frame.width / 3, height: view.frame.height / 3)
        
        guard let image = UIImage.loadImage(withURL: urlPath, targetSize: size) else { return }
        
        profileImageView = UIImageView()
        profileImageView?.frame.size = CGSize(width: size.width, height: size.height)
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        profileImageView?.image = image
        profileImageView?.contentMode = .scaleAspectFit
        profileImageView?.layer.cornerRadius = 20
        profileImageView?.clipsToBounds = true
        profileImageView?.layer.borderWidth = 1
        
        if let profileImageView = profileImageView {
            view.addSubview(profileImageView)
        }
    }
}
