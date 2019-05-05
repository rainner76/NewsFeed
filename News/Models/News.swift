//
//  News.swift
//  News
//
//  Created by Jianfang Li on 3/21/19.
//  Copyright © 2019 Jianfang Li. All rights reserved.
//

import UIKit

struct News {
    
    var title: String?
    var link: String?
    var description: String?
    var encoded: Bool = true
    var pubDate: Date?
    var guid: String?
    var category: String?
    var articleType: String?
    
    ///
    /// This will initiate a news struct
    ///
    /// - Parameters:
    ///     - title: the title of news
    ///     - link: the url of news
    ///     - description: the description of news
    ///     - endcoded: the boolean value of encoded content
    ///     - pubDate: the published date
    ///     - guid:
    ///     - category: the category of news
    ///     - articleType: the type of article
    ///
    init(title: String? = nil, link: String? = nil, description: String? =  nil, encoded: String? = nil, pubDate: String? = nil, guid: String? = nil, category: String? = nil, articleType: String? = nil) {
        self.title = title
        self.link = link
        self.description = description

        self.guid = guid
        self.category = category
        self.articleType = articleType
                        
        if let dateString = pubDate {
            
            let dates = dateString.split(separator: ",")
            
            if dates.count == 2 {
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.current
                dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss -zzzz"
                
                self.pubDate = dateFormatter.date(from: String(dates[1]))
            }
        }
    }
}
