//
//  RepositoriesTableView.swift
//  GitHub
//
//  Created by Vadim on 11/13/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class RepositoriesViewController: UITableViewController {

    public var repositories = [Repository]()
    public var images = [UIImage]()
    public let apiManager = APIManager()
    
    public let cellId = "cell"
    
    public let activityIndicator = ActivityIndicator()
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView(frame: .zero)
        view.backgroundColor = UIColor.init(red: 119/255, green: 141/255, blue: 196/255, alpha: 1)
        
        view.addSubview(activityIndicator)
    }
    
    public func loadProfileImages(repositories: [Repository]) {
        for item in repositories {
            if let url = item.owner?.avatar_url {
                let image = UIImage.loadImage(withURL: url, targetSize: CGSize(width: 35, height: 35))
                images.append(image ?? UIImage())
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = repositories[indexPath.row].url {
            let repositoryViewController = DirectoryViewController.init(url: url, isMainDirectory: true, directoryName: repositories[indexPath.row].name ?? "")
            navigationController?.pushViewController(repositoryViewController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.backgroundColor = UIColor.init(red: 133/255, green: 149/255, blue: 240/255, alpha: 1)
        
        cell.textLabel?.text = repositories[indexPath.row].full_name
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.detailTextLabel?.text = repositories[indexPath.row].description
        
        cell.imageView?.image = images[indexPath.row]
        cell.imageView?.layer.cornerRadius = 17
        cell.imageView?.clipsToBounds = true
        
        return cell
    }
}
