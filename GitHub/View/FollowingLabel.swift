//
//  FollowingLabel.swift
//  GitHub
//
//  Created by Vadim on 11/15/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class FollowingLabel: UILabel {
    
    convenience init(text: String) {
        self.init()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.text = text
        self.font = UIFont.systemFont(ofSize: 14)
        self.layer.borderWidth = 1
        self.draw(self.frame)
        self.backgroundColor = UIColor.init(red: 117/255, green: 211/255, blue: 106/255, alpha: 0.7)
    }
    
    override func draw(_ rect: CGRect) {
        let inset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        super.drawText(in: rect.inset(by: inset))
    }
}
