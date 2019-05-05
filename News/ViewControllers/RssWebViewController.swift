//
//  RssWebViewController.swift
//  News
//
//  Created by Jianfang Li on 3/21/19.
//  Copyright © 2019 Jianfang Li. All rights reserved.
//

import UIKit
import WebKit

class RssWebViewController: UIViewController {

    // MARK: - Outlets -
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: - Private Members -
    
    private lazy var webView: WKWebView = {
        
        let web = WKWebView()
        
        self.view.addSubview(web)
        web.backgroundColor = .white
        
        web.translatesAutoresizingMaskIntoConstraints = false
        web.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        web.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        web.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        web.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.sendSubviewToBack(web)
        
        return web
    }()
    
    private var news: News?

    // MARK: - LifeTime -
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: "RssWebViewController", bundle: nil)
    }
    
    convenience init(withNews news: News?) {
        
        self.init()
        self.news = news
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        indicator.isHidden = false
        indicator.color = UIColor.PrimaryColor()
        indicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        indicator.hidesWhenStopped = true
        
        if let newsLink = self.news?.link,  let url = URL(string: newsLink) {

            self.indicator.startAnimating()
            
            let urlRequest = URLRequest(url: url)
            webView.navigationDelegate = self
            webView.load(urlRequest)
        }
    }
}

// MARK: - Extenstion: WKNavigationDelegate -

extension RssWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.indicator.stopAnimating()
    }
}
