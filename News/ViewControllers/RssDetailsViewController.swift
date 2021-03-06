//
//  RssDetailsViewController.swift
//  News
//
//  Created by Jianfang Li on 3/21/19.
//  Copyright © 2019 Jianfang Li. All rights reserved.
//


import UIKit

class RssDetailsViewController: RssBaseViewController {
    
    // MARK: - Lifetime -
    
    convenience init(with News: [News]? = nil) {
        
        self.init(nibName: nil, bundle: nil)
        self.setupNews(with: News)
    }
    
    // MARK: - Overrides -
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let loadedNews = super.mappedNews(from: indexPath) else {
            return
        }
        
        self.loadNews(with: loadedNews)
    }
}

// Mark: - Extension: NewsFeedable -

extension RssDetailsViewController: NewsFeedable {
    
    func setupNews(with news: [News]?) {
        
        guard let news = news else {
            return
        }
        
        categoryNews = Dictionary(grouping: news, by: {$0.articleType ?? ""})
        
        self.tableView.reloadData()
    }
    
    func loadNews(with news: News) {
        
        let webViewController = RssWebViewController.init(withNews: news)
        
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
}

