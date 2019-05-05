//
//  RssXMLParser.swift
//  News
//
//  Created by Jianfang Li on 3/21/19.
//  Copyright © 2019 Jianfang Li. All rights reserved.
//

import UIKit

class RssXMLParser: XMLParser {
    
    var elementName: String?
    var articleType: String = ""
    var link: String = ""
    var pubDate: String = ""
    var title: String = ""
    var items = [News]()
    var completed: ClosureWithNewsResponse?
    var failure: ClosureWithError?
    
    // MARK: - LifeTime -
    
    override init(data: Data) {
        super.init(data: data)
    }
    
    ///
    /// This will initiate XMLParser object with data
    ///
    /// - Parameters:
    ///     - data: the parsed data
    ///     - completed: called when data was parsed
    ///
    convenience init(data: Data, completed: ClosureWithNewsResponse? = nil, failure: ClosureWithError? = nil) {
        
        self.init(data: data)
        self.delegate = self
        self.completed = completed
        self.failure = failure
        self.parse()
    }
}

// MARK: - Extenstion: XMLParserDelegate -

extension RssXMLParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == Keys.item.rawValue {
            
            title = ""
            link = ""
            articleType = ""
            pubDate = ""
        }
        
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == Keys.item.rawValue {
            
            let item = News(title: title, link: link, pubDate: pubDate, articleType: articleType)
            
            items.append(item)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if !data.isEmpty {
            
            switch elementName {
            case Keys.link.rawValue:
                self.link += data
            case Keys.titile.rawValue:
                self.title += data
            case Keys.articleType.rawValue:
                self.articleType += data
            case Keys.pubDate.rawValue:
                self.pubDate += data
            default:
                break
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        guard let completed = completed else {
            return
        }
        
        items.count > 0 ? completed(items) : failure?(NewsError.noNews)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        failure?(parseError)
    }
}
