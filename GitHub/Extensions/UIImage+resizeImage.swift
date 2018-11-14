//
//  UIImage+resizeImage.swift
//  GitHub
//
//  Created by Vadim on 11/12/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return newImage ?? self
    }
    
    static func loadImage(withURL urlPath: String, targetSize size: CGSize) -> UIImage? {
        let profileURL = URL(string: urlPath)
        guard let url = profileURL else { return nil }
        
        if let data = try? Data(contentsOf: url) {
            var image = UIImage(data: data)
            image = image?.resizeImage(targetSize: size)
            
            return image
        }
        return nil
    }

}
