//
//  RepositoryViewController.swift
//  GitHub
//
//  Created by Vadim on 11/6/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class RepositoryViewController: UITableViewController {

    var apiManager = APIManager()
    var content: [Content]?
    
    var url: String?
    let cellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Repository"
        view.backgroundColor = .white
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(url: String) {
        self.init()
        self.url = url
        
        getContent()
    }
    
    func getContent() {
        guard let contentURL = url else {
            return
        }
        
        if let url = URL(string: contentURL) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        self.content = try JSONDecoder().decode([Content].self, from: data)
                        DispatchQueue.main.async {
                            self.sortData()
                            self.tableView.reloadData()
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let content = content else {
            return
        }
        
        var controller = UIViewController()
        if content[indexPath.row].type == "dir" {
            if let newURL = content[indexPath.row].url {
                controller = RepositoryViewController.init(url: newURL)
                
            }
        } else {
            if let fileURL = content[indexPath.row].url {
                print(fileURL)
                controller = FileViewController.init(url: fileURL)
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
        var newCell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if newCell == nil {
            newCell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        guard let cell = newCell,
            let content = content else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = content[indexPath.row].name
        
        if content[indexPath.row].type == "dir" {
            cell.imageView?.image = UIImage(named: "dir")
        } else {
            cell.imageView?.image = UIImage(named: "file")
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
