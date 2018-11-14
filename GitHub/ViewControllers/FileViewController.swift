//
//  FileViewController.swift
//  GitHub
//
//  Created by Vadim on 11/9/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class FileViewController: UIViewController {
    
    private var url = String()
    
    private var scrollView = UIScrollView()
    private var textView = UITextView()
    private var activityIndicatior = ActivityIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(activityIndicatior)
        
        activityIndicatior.start()
    }

    convenience init(url: String, fileName: String) {
        self.init()
        
        self.url = url
        self.title = fileName
        
        getContent()
    }
    
    private func getContent() {
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            request.addValue("application/vnd.github.VERSION.raw", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        if let code = String(data: data, encoding: .utf8) {
                            self.setupTextView(withSize: code.sizeOfString(usingFont: UIFont.systemFont(ofSize: 16)), text: code)
                            self.activityIndicatior.stop()
                        }
                    }
                }
            }.resume()
        }
    }
    
    private func setupTextView(withSize size: CGSize, text: String) {
        scrollView = UIScrollView(frame: UIScreen.main.bounds)
        scrollView.contentSize = size
        
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.backgroundColor = .white
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: 16)
        
        view.addSubview(scrollView)
        scrollView.addSubview(textView)
    }
}
