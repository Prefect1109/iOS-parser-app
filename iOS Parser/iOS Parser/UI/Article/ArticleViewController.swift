//
//  ArticleViewController.swift
//  iOS Parser
//
//  Created by Prefect on 29.03.2022.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showArticle(with url: URL) {
        let requestObj = URLRequest(url: url)
        webView.load(requestObj)
    }
}
