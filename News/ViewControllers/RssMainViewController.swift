//
//  RssMainViewController.swift
//  News
//
//  Created by Jianfang Li on 3/21/19.
//  Copyright © 2019 Jianfang Li. All rights reserved.
//


import UIKit

class RssMainViewController: RssBaseViewController {

    // MARK: - LifeTime -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupNews()
        
        self.title = "News"
    }
    
    // MARK: - Overrides -
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let categoryNews = categoryNews else {
            return
        }
        
        let keys = Array(categoryNews.keys).sorted()
        
        if let news = categoryNews[keys[indexPath.section]], indexPath.row < news.count {
            
            let loadedNews = news[indexPath.row]
            
            self.loadNews(with: loadedNews)
        }
    }
}

// Mark: - NewsFeedable -

extension RssMainViewController: NewsFeedable {
    
   func setupNews(with news: [News]? = nil) {
        
        let categories: [News] = RSSLinks.allCases.compactMap({ object -> News in
            return News(title: object.toTitle(), link: object.rawValue)
        })
        
        self.categoryNews = ["Main": categories]
        
        self.tableView.reloadData()
    }
    
    func loadNews(with news: News) {
        
        guard let url = news.link else {return}
        
        self.indicator.startAnimating()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            _ = RssService.performRssRequest(withUrl: url, completion: { allNews in
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let `self` = self else {return}
                    
                    self.indicator.stopAnimating()
                    
                    let viewController = RssDetailsViewController.init(with: allNews)
                    viewController.title = news.title ?? ""
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                
            }, failure: { [weak self] _ in
                
                DispatchQueue.main.async {
                    
                    guard let `self` = self else {return}
                    
                    self.indicator.stopAnimating()
                }
            })
        }
    }
    
    
}


