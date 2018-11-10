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
    var url: String?
    var language: String?
    
    var owner: Owner?
}

struct Owner: Decodable {
    var login: String?
    var avatar_url: String?
}

struct Content: Decodable {
    var name: String?
    var path: String?
    var sha: String?
    var url: String?
    var html_url: String?
    var type: String?
    var download_url: String?
}
