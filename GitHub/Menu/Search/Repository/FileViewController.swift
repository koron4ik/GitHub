//
//  FileViewController.swift
//  GitHub
//
//  Created by Vadim on 11/9/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class FileViewController: UIViewController {
    
    var url: String?
    
    let scrollView: UIScrollView = {
        var scroll = UIScrollView(frame: UIScreen.main.bounds)
        scroll.contentSize = CGSize(width: 1000, height: 1000)
        return scroll
    }()
    
    let contentView: UITextView = {
        var label = UITextView(frame: CGRect(x: 0, y: 0, width: 700, height: 700))
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = true
        label.isEditable = false
        label.backgroundColor = .white
        return label
    }()

    override func viewDidLoad() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(url: String) {
        self.init()
        self.url = url
        
        getContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getContent() {
        guard let url = url else {
            return
        }

        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            request.addValue("application/vnd.github.VERSION.raw", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        let code = String(data: data, encoding: .utf8)
                        self.contentView.text = code
                    }
                }
            }.resume()
        }
    }
}
