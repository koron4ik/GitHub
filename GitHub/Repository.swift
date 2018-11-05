//
//  Repository.swift
//  GitHub
//
//  Created by Vadim on 11/3/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    
    let name: String?
    let language: String?
    let url: String?
}
