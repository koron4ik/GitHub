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
    
    var profileImage: UIImage?
    var profileImageView: UIImageView?
    var nicknameLabel: UILabel?
    
    var user: User? {
        didSet {
            if let avatarUrl = user?.avatarUrl {
                setupProfileImage(avatarUrl: avatarUrl)
            }
            
            if let login = user?.login {
                setupUserNickName(with: login)
            }
        }
    }
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: (self.view.frame.size.width - 300) / 2, y: self.view.frame.size.height - 150, width: 300, height: 50)
        button.setImage(UIImage(named: "logout"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:#selector(logoutButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(logoutButton)
    }
    
    @objc func logoutButtonPressed() {
        cleanUserInfo()
        setHomePage()
    }
    
    func cleanUserInfo() {
        let data = WKWebsiteDataStore.default()
        data.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            data.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records.filter { $0.displayName.contains("github")}, completionHandler: { })
        }
    }
    
    func setHomePage() {
        let homeViewController = HomeViewController()
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = homeViewController
    }
    
    func setupUserNickName(with login: String) {
        nicknameLabel = UILabel(frame: CGRect(x: (view.frame.width - 300) / 2,
                                                      y: 350,
                                                      width: 300,
                                                      height: 40))
        nicknameLabel?.text = login
        nicknameLabel?.font = UIFont.systemFont(ofSize: 25)
        nicknameLabel?.textAlignment = .center
        nicknameLabel?.isUserInteractionEnabled = false
        if let nicknameLabel = nicknameLabel {
            view.addSubview(nicknameLabel)
        }
    }
    
    func setupProfileImage(avatarUrl: String) {
        let profileUrl = URL(string: avatarUrl)
        guard let url = profileUrl else { return }
        
        if let data = try? Data(contentsOf: url) {
            self.profileImage = UIImage(data: data)
            
            let size = CGSize(width: view.frame.width / 3, height: view.frame.height / 3)
            self.profileImage = self.profileImage?.resizeImage(targetSize: size)
            
            self.setupProfileImageView()
        }
    }
    
    func setupProfileImageView() {
        if let profileImage = profileImage {
            let imageWidth = view.frame.width / 3
            let imageHeight = view.frame.height / 3
            let imageView = UIImageView(frame: CGRect(x: (view.frame.width - imageWidth) / 2,
                                                      y: (view.frame.height - imageHeight) / 3,
                                                      width: profileImage.size.width,
                                                      height: profileImage.size.height))
            imageView.image = profileImage
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 30
            imageView.clipsToBounds = true
            imageView.layer.borderWidth = 2
            
            view.addSubview(imageView)
        }
    }
}

extension UIImage {
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}
