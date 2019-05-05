//
//  NewsTests.swift
//  NewsTests
//
//  Created by Jianfang Li on 3/21/19.
//  Copyright © 2019 Jianfang Li. All rights reserved.
//

import XCTest
@testable import News

class NewsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRssApiTechnology() {
        
        let expectation = self.expectation(description: #function)
        
        let url = RSSLinks.techology.rawValue
        
        RssService.performRssRequest(withUrl: url, completion: { news in
            
            expectation.fulfill()
            XCTAssertNotNil(news)
            
        }, failure: { error in
            
            XCTFail("failed")
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 99999, handler: { error in
           
            if let error = error {
                XCTFail("\(error)")
            }
        })
    }
}
