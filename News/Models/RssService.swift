//
//  RssService.swift
//  News
//
//  Created by Jianfang Li on 3/21/19.
//  Copyright © 2019 Jianfang Li. All rights reserved.
//

import UIKit

class RssService: NSObject {

    ///
    /// This will initiate a news API XMLParser object with data
    ///
    /// - Parameters:
    ///     - requestUrl: the url of API
    //      - params: the parameters of API
    ///     - completion: called when data was recevied successfully
    ///     - failure: called when data was recevied unsuccessfully
    ///
    class func performRssRequest(withUrl requestUrl: String, withParams params: [String: String]? = nil, completion: @escaping ClosureWithNewsResponse, failure: @escaping ClosureWithError) {
        
        var urlComponent = URLComponents(string: requestUrl)
        
        if let params = params {
            
            let queryParams = params.map({
                return URLQueryItem(name: $0.key, value: $0.value)
            })
            
            urlComponent?.queryItems = queryParams
        }
        
        guard let url = urlComponent?.url else {
            
            failure(NewsError.invalidUrl)
            return
        }
        
        var request =  URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.timeoutInterval = 15
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard let data: Data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                
                failure(error)
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                
                failure(NewsError.invalidReponse)
                return
            }
            
            let _ = RssXMLParser(data: data, completed: completion, failure: failure)
        }
        
        task.resume()
    }
}
