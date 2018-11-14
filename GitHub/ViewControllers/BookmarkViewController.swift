//
//  ReposViewController.swift
//  GitHub
//
//  Created by Vadim on 11/3/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class BookmarkViewController: RepositorieViewController {
    
    private let bookmarkId = "bookmark"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRepositories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }
    
    public func addNewRepository(withUrl urlString: String) {
        var repositoriesUrl = UserDefaults.standard.stringArray(forKey: bookmarkId)
        
        if repositoriesUrl == nil {
            UserDefaults.standard.set([urlString], forKey: bookmarkId)
        } else {
            repositoriesUrl?.append(urlString)
            UserDefaults.standard.set(repositoriesUrl, forKey: bookmarkId)
        }
        getRepository(withUrl: urlString)
    }
    
    public func removeRepositoryFromBookmark(urlString: String) {
        var repositoriesUrl = UserDefaults.standard.stringArray(forKey: "bookmark")
        repositoriesUrl?.removeAll(where: { (url) -> Bool in
            url == urlString
        })
        
        UserDefaults.standard.removeObject(forKey: "bookmark")
        UserDefaults.standard.set(repositoriesUrl, forKey: "bookmark")
        
        loadRepositories()
    }
    
    private func loadRepositories() {
        images.removeAll()
        repositories.removeAll()
        
        let repositoriesUrl = UserDefaults.standard.stringArray(forKey: bookmarkId)
        if let repositoriesUrl = repositoriesUrl {
            for url in repositoriesUrl {
                getRepository(withUrl: url)
            }
        }
    }
    
    private func getRepository(withUrl urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let repository = try JSONDecoder().decode(Repository.self, from: data)
                    DispatchQueue.main.async {
                        self.loadProfileImage(repository: repository)
                        self.repositories.append(repository)
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    private func loadProfileImage(repository: Repository) {
        if let url = repository.owner?.avatar_url {
            let image = UIImage.loadImage(withURL: url, targetSize: CGSize(width: 35, height: 35))
            images.append(image ?? UIImage())
        }
    }
}
