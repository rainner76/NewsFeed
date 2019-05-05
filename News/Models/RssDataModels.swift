//
//  RssDataModels.swift
//  News
//
//  Created by Jianfang Li on 3/21/19.
//  Copyright © 2019 Jianfang Li. All rights reserved.
//

import Foundation

typealias ClosureWithError = (_ error: Error?) -> Void
typealias ClosureWithNewsResponse = (_ news: [News]?) -> Void
typealias ClosureWithBool = (_ success: Bool) -> Void

// MARK: Keys

enum Keys: String {
    case articleType = "wsj:articletype"
    case item = "item"
    case link = "link"
    case titile = "title"
    case pubDate = "pubDate"
}

// MARK: RSSLinks

enum RSSLinks: String, CaseIterable  {
    
    case opinion = "https://feeds.a.dj.com/rss/RSSOpinion.xml"
    case world = "https://feeds.a.dj.com/rss/RSSWorldNews.xml"
    case usa = "https://feeds.a.dj.com/rss/WSJcomUSBusiness.xml"
    case markets = "https://feeds.a.dj.com/rss/RSSMarketsMain.xml"
    case techology = "https://feeds.a.dj.com/rss/RSSWSJD.xml"
    case life = "https://feeds.a.dj.com/rss/RSSLifestyle.xml"
    
    ///
    /// This will return a title of category
    ///
    /// returns: the title
    ///
    func toTitle() -> String? {
        
        switch self {
        case .life:
            return "LifeStyle"
        case .markets:
            return "Markets News"
        case .opinion:
            return "Opinion"
        case .techology:
            return "Technology: What's New"
        case .world:
            return "World News"
        case .usa:
            return "US. Business News"
        }
    }
}

// MARK: NewsError

enum NewsError: String, Error {
    
    case invalidUrl = "Invalid Url"
    case invalidReponse = "Invalid Response"
    case noNews = "No News"
}

