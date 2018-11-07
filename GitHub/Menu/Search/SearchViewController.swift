//
//  SearchViewController.swift
//  GitHub
//
//  Created by Vadim on 11/3/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchResultsUpdating {
    
    var repositories: Repositories?
    var apiManager = APIManager()
    
    var cellsPerPage = 15
    var numberOfCells: Int?
    
    let cellId = "id"
    
    let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.dimsBackgroundDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.sizeToFit()
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        //searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        tableView.tableFooterView = UIView(frame: .zero)
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            getRepositories(parameter: searchText)
        }
    }
    
    func getRepositories(parameter: String) {
        let searchUrl = "\(apiManager.githubURL)\(apiManager.search)q=\(parameter)&sort=stars"
        if let url = URL(string: searchUrl) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        self.repositories = try JSONDecoder().decode(Repositories.self, from: data)
                        DispatchQueue.main.async {
                            self.numberOfCells = self.cellsPerPage
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositoryViewController = RepositoryViewController()
        navigationController?.pushViewController(repositoryViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfCells = numberOfCells {
            return numberOfCells
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let numberOfCells = numberOfCells,
            let repositories = repositories,
            let items = repositories.items else {
                return
        }
        
        if indexPath.row == numberOfCells - 1 {
            if items.count > numberOfCells {
                let numberOfNewCells = items.count - numberOfCells
                self.numberOfCells = (numberOfNewCells > cellsPerPage) ? numberOfCells + cellsPerPage : numberOfCells + numberOfNewCells
                self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
            }
        }
    }
    
    @objc func loadTable() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var newCell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if newCell == nil {
            newCell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        guard let cell = newCell,
            let repositories = repositories,
            let items = repositories.items else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = items[indexPath.row].full_name
        cell.detailTextLabel?.text = items[indexPath.row].description
        
        if let avatarUrl = items[indexPath.row].owner?.avatar_url {
            let url = URL(string: avatarUrl)
            if let url = url {
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    cell.imageView?.image = image?.resizeImage(targetSize: CGSize(width: 40, height: 40))
                    cell.imageView?.layer.cornerRadius = 20
                    cell.imageView?.clipsToBounds = true
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
