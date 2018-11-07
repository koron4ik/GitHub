//
//  EnterViewController+Animations.swift
//  GitHub
//
//  Created by Vadim on 11/3/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

extension HomeViewController {
    
    func startRepeatingButtonAnimation() {
        signInButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 1.0,
            delay: 0.0,
            options: [.repeat, .autoreverse, .allowUserInteraction],
            animations: {
                self.signInButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        )
    }
    
    func beginButtonAnimation() {
        signInButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 2.0,
            delay: 0.2,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: {
                self.signInButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.startRepeatingButtonAnimation()
            }
        )
    }
    
    func animationButtonPressed() {
        signInButton.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.2,
            delay: 0.1,
            usingSpringWithDamping: 1.5,
            initialSpringVelocity: 0.0,
            animations: {
                self.signInButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.2)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.signInButton.transform = CGAffineTransform.identity
                }
            }
        )
    }
}
