//
//  UserRepositoriesViewControllerTableViewController.swift
//  GitHub
//
//  Created by Vadim on 11/15/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class UserRepositoriesViewController: RepositoriesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func getRepositories(accessToken: String) {
        if let url = URL(string: apiManager.userReposUrl) {
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        self.repositories = try JSONDecoder().decode([Repository].self, from: data)
                        DispatchQueue.main.async {
                            self.activityIndicator.start()
                            self.loadProfileImages(repositories: self.repositories)
                            self.tableView.reloadData()
                            self.activityIndicator.stop()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }

}
