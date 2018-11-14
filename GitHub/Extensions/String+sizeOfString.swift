//
//  String+sizeOfString.swift
//  GitHub
//
//  Created by Vadim on 11/12/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

extension String {
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
