//
//  Repository.swift
//  GitHub
//
//  Created by Vadim on 11/3/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import Foundation

struct Repositories: Decodable {
    
    var items: [Repository]?
}

struct Repository: Decodable {
    var name: String?
    var full_name: String?
    var description: String?
    var html_url: String?
    var language: String?
    //var stargazers_count: String?
    
    var owner: Owner?
}

struct Owner: Decodable {
    var login: String?
    var avatar_url: String?
}
