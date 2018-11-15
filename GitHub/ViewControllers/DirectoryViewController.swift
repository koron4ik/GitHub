//
//  RepositoryViewController.swift
//  GitHub
//
//  Created by Vadim on 11/6/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class DirectoryViewController: UITableViewController {

    private var apiManager = APIManager()
    private var content: [Content]?
    
    private var url: String?
    private var mainDirectoryUrl: String?
    private var isMainDirectory = false
    private var bookmarkButtonIsSelected = false
    
    private var activityIndicatior = ActivityIndicator()
    
    private let cellId = "cell"
    
    convenience init(url: String, isMainDirectory: Bool, directoryName: String) {
        self.init()
        self.title = directoryName
        
        self.isMainDirectory = isMainDirectory
        
        if isMainDirectory {
            setupBookmarkButton()
            if repositoryIsAlreadyBookmark(urlString: url) {
                bookmarkButtonIsSelected = true
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blue
            }
            self.mainDirectoryUrl = url
            self.url = "\(url)/contents"
        } else {
            self.url = url
        }
        getContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        view.backgroundColor = UIColor.init(red: 133/255, green: 149/255, blue: 240/255, alpha: 1)
        view.addSubview(activityIndicatior)
        
        activityIndicatior.start()
    }
    
    public func repositoryIsAlreadyBookmark(urlString: String) -> Bool {
        if let repositoriesUrl = UserDefaults.standard.stringArray(forKey: "bookmark") {
            for url in repositoriesUrl {
                if url == urlString {
                    return true
                }
            }
        }
        return false
    }
    
    private func setupBookmarkButton() {
        let bookmarkImage = UIImage(named: "bookmark")?.resizeImage(targetSize: CGSize(width: 40, height: 40))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: bookmarkImage, style: .done, target: self, action: #selector(bookmarkButtonTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
    }
    
    @objc func bookmarkButtonTapped() {
        bookmarkButtonIsSelected = !bookmarkButtonIsSelected
        
        let navController = self.tabBarController?.viewControllers![2] as! UINavigationController
        let bookmarkViewController = navController.viewControllers.first as! BookmarkViewController
        
        if bookmarkButtonIsSelected {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blue
            bookmarkViewController.addNewRepository(withUrl: mainDirectoryUrl!)
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
            bookmarkViewController.removeRepositoryFromBookmark(urlString: mainDirectoryUrl!)
        }
    }
    
    func getContent() {
        guard let contentUrl = url else { return }
        if let url = URL(string: contentUrl) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        self.content = try JSONDecoder().decode([Content].self, from: data)
                        DispatchQueue.main.async {
                            self.sortData()
                            self.tableView.reloadData()
                            self.activityIndicatior.stop()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func sortData() {
        if let content = content {
            self.content = content.sorted(by: { (item1, item2) -> Bool in
                let type1 = item1.type ?? ""
                let type2 = item2.type ?? ""
                let name1 = item1.name ?? ""
                let name2 = item2.name ?? ""
                
                return type1 == type2 ? name1 < name2 : type1 < type2
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let content = content else {
            return
        }
        
        var controller = UIViewController()
        if content[indexPath.row].type == "dir" {
            if let newURL = content[indexPath.row].url {
                controller = DirectoryViewController.init(url: newURL, isMainDirectory: false, directoryName: content[indexPath.row].name ?? "")
                
            }
        } else {
            if let fileURL = content[indexPath.row].url {
                controller = FileViewController.init(url: fileURL, fileName: content[indexPath.row].name ?? "")
            }
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let content = content {
            return content.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        guard let content = content else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = UIColor.init(red: 117/255, green: 211/255, blue: 106/255, alpha: 0.3)
        cell.textLabel?.text = content[indexPath.row].name
        
        if content[indexPath.row].type == "dir" {
            cell.imageView?.image = UIImage(named: "dir")?.resizeImage(targetSize: CGSize(width: 30.0, height: 30.0))
        } else {
            cell.imageView?.image = UIImage(named: "file")?.resizeImage(targetSize: CGSize(width: 30.0, height: 30.0))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
