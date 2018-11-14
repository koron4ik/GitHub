//
//  ActivityIndicator.swift
//  GitHub
//
//  Created by Vadim on 11/14/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class ActivityIndicator: UIActivityIndicatorView {
    convenience init() {
        self.init(style: .gray)
        
        self.hidesWhenStopped = true
        self.isHidden = true
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.2)
    }
    
    public func start() {
        self.isHidden = false
        self.startAnimating()
    }
    
    public func stop() {
        self.stopAnimating()
    }
}
