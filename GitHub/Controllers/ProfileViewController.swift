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
    var nicknameTextField: UITextField?
    
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
        
        
        setupProfileImage()
        setupUserNickName()
        
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
    
    func setupUserNickName() {
        nicknameTextField = UITextField(frame: CGRect(x: (view.frame.width - 300) / 2,
                                                      y: 350,
                                                      width: 300,
                                                      height: 40))
        nicknameTextField?.text = "koron4ik"
        nicknameTextField?.font = UIFont.systemFont(ofSize: 25)
        nicknameTextField?.textAlignment = .center
        nicknameTextField?.isUserInteractionEnabled = false
        view.addSubview(nicknameTextField!)
    }
    
    func setupProfileImage() {
        let url = URL(string: "https://avatars1.githubusercontent.com/u/42875321?v=4")
        if let url = url {
            let data = try? Data(contentsOf: url)
            if let data = data {
                if let profileImage = UIImage(data: data) {
                    self.profileImage = profileImage
                    let newSize = CGSize(width: view.frame.width / 3, height: view.frame.height / 3)
                    self.profileImage = resizeImage(image: profileImage, targetSize: newSize)
                    setupProfileImageView()
                }
                
            }
        }
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
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
