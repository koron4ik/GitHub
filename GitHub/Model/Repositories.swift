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
