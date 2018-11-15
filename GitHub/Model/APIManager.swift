//
//  APIManager.swift
//  GitHub
//
//  Created by Vadim on 11/3/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import Foundation

struct APIManager {
    
    let userURL = URL(string: "https://api.github.com/user")
    let tokenURL = URL(string: "https://github.com/login/oauth/access_token")
    lazy var authorizeURL = URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientId)")
    
    let githubURL = "https://api.github.com"
    let reposURL = "https://api.github.com/repos"
    let search = "/search/repositories?"
    let userReposUrl = "https://api.github.com/user/repos"
    
    let host = "www.google.com"
    let clientId = "e474de4ebc134d61208b"
    let clientSecret = "4bcb70520856e6b809185d163b3bb5372df05cda"
    
}
