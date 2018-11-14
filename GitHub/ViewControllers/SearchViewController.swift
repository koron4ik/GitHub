//
//  SearchViewController.swift
//  GitHub
//
//  Created by Vadim on 11/3/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class SearchViewController: RepositorieViewController, UISearchBarDelegate {
    
    private var apiManager = APIManager()
    
    private var cellsPerPage = 30
    
    private let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.dimsBackgroundDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.sizeToFit()
        
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        view.addSubview(activityIndicator)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text {
            repositories.removeAll()
            images.removeAll()
            tableView.reloadData()
            
            activityIndicator.start()
            getRepositories(withName: searchText, page: 1)
        }
    }
    
    private func getRepositories(withName name: String, page: Int) {
        let searchUrl = "\(apiManager.githubURL)\(apiManager.search)q=\(name)&sort=stars&page=\(page)"
        guard let url = URL(string: searchUrl) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let repositories = try JSONDecoder().decode(Repositories.self, from: data)
                    DispatchQueue.main.async {
                        if let items = repositories.items {
                            self.repositories.append(contentsOf: items)
                            self.loadProfileImages(repositories: items)
                            self.tableView.reloadData()
                            self.activityIndicator.stop()
                        }
                        if repositories.items?.count == 0 && page == 1 {
                            self.searchController.searchBar.text?.removeAll()
                            self.showAlert()
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    private func loadProfileImages(repositories: [Repository]) {
        for item in repositories {
            if let url = item.owner?.avatar_url {
                let image = UIImage.loadImage(withURL: url, targetSize: CGSize(width: 35, height: 35))
                images.append(image ?? UIImage())
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Repositoires not found", message: nil, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == repositories.count - 1 {
            guard let searchText = searchController.searchBar.text else { return }
            activityIndicator.start()
            getRepositories(withName: searchText, page: repositories.count / cellsPerPage + 1)
        }
    }
}
