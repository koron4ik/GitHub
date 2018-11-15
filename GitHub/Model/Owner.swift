//
//  Owner.swift
//  GitHub
//
//  Created by Vadim on 11/14/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import Foundation

struct Owner: Decodable {
    var login: String?
    var avatar_url: String?
    var followers: Int?
    var following: Int?
}
