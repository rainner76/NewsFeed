//
//  RssBaseViewController.swift
//  News
//
//  Created by Jianfang Li on 3/21/19.
//  Copyright © 2019 Jianfang Li. All rights reserved.
//

protocol NewsFeedable {
    
    ///
    /// This will setup the view with news
    ///
    /// - Parameter news: the news to be listed
    ///
    func setupNews(with news: [News]?)
    
    ///
    /// This will load news with API
    ///
    /// - Parameter news: the loaded news
    ///
    func loadNews(with news: News)
}

import UIKit

class RssBaseViewController: UITableViewController {
    
    // MARK: - Public Members -
    
    lazy var indicator : UIActivityIndicatorView = {
        
        let indicator = UIActivityIndicatorView()
        
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        
        indicator.isHidden = false
        indicator.color = UIColor.PrimaryColor()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        indicator.center = self.view.center
        indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    var categoryNews : [String: [News]]?

    // MARK: - LifeTime -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    // MARK: - Overrides -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let categoryNews = categoryNews else {
            return 0
        }
        
        return categoryNews.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let categoryNews = categoryNews else {
            return 0
        }
        
        let keys = Array(categoryNews.keys).sorted()
        
        if let news = categoryNews[keys[section]] {
            return news.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? NewsCell, let news = mappedNews(from: indexPath) else {
            return UITableViewCell()
        }
        
        cell.loadCell(with: news)
        
        if let favorites = CoreDataManager.shared.fetchFavorite(with: news), favorites.count > 0 {
            cell.likeButton?.setImage(UIImage(named: "Favorites"), for: .normal)
        } else {
            cell.likeButton?.setImage(UIImage(named: "Favorites_unmark"), for: .normal)
        }
        
        cell.likeButton?.addTarget(self, action: #selector(updateFavorite), for: .touchUpInside)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let categoryNews = categoryNews else {
            return nil
        }
        
        let view = UIView()
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: self.view.frame.width, height: 30))
        let keys = Array(categoryNews.keys).sorted()
        label.font = UIFont.systemFont(ofSize: 16)
        
        view.backgroundColor = UIColor.PrimaryColor()
        
        if section < keys.count {
            let category = keys[section]
            label.text = category
            view.addSubview(label)
            label.textColor = .white
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - Actions -
    
    ///
    /// This will update news to favorite
    ///
    /// - Parameter sender: the tapped button
    ///
    @objc func updateFavorite(sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: point), let loadedNews = mappedNews(from: indexPath) else {
            return
        }
    
        CoreDataManager.shared.saveFavorites(with: loadedNews, completion: { [weak self] isDeleted in
            
            guard let `self` = self else {return}
            
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        })
    }
    
    
    // MARK: - Public Methods -
    
    ///
    /// This will map a news from indexpath
    ///
    /// - Parameter indexPath: the index path
    ///
    /// - returns: the mapped news
    ///
    func mappedNews(from indexPath: IndexPath) -> News? {
        
        guard let categoryNews = categoryNews else {
            return nil
        }
        
        let keys = Array(categoryNews.keys).sorted()
        
        guard let news = categoryNews[keys[indexPath.section]], indexPath.row < news.count else {
            return  nil
        }
        
        let sorted = news.sorted(by: { $0.pubDate?.compare($1.pubDate ?? .distantPast) == .orderedDescending})
        let loadedNews = sorted[indexPath.row]
        
        return loadedNews
    }
}
