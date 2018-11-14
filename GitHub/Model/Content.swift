//
//  Content.swift
//  GitHub
//
//  Created by Vadim on 11/14/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import Foundation

struct Content: Decodable {
    var name: String?
    var path: String?
    var sha: String?
    var url: String?
    var html_url: String?
    var type: String?
    var download_url: String?
}
