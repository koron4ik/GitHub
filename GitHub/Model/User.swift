//
//  User.swift
//  GitHub
//
//  Created by Vadim on 11/5/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import Foundation

class User {
    
    var accessToken: String
    
    var login: String?
    var avatarUrl: String?
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
}
