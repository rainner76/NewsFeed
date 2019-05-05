//
//  NewsCell.swift
//  News
//
//  Created by Jianfang Li on 3/21/19.
//  Copyright © 2019 Jianfang Li. All rights reserved.
//


import UIKit

class NewsCell: UITableViewCell {

    // MARK: - IBOutlets -
    
    @IBOutlet weak var pubDateLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var likeButton: UIButton?
    
    // MARK: - Overrides -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.titleLabel?.text = ""
        self.pubDateLabel?.text = ""
    }
    
    deinit {
        debugPrint("Cell released")
    }
    
    // MARK: - Private Methods -
    
    ///
    /// This will display the date string of a News
    ///
    /// - Parameter news: the date of a news
    ///
    /// - returns: the string from a date
    ///
    private func displayNewsDate(from date: Date?) -> String {
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale.current
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        guard let date = date else {
            return ""
        }
        
        if Calendar.current.isDateInToday(date) {
            
            formatter.dateFormat = "hh:mm a"
            pubDateLabel?.textColor = .red
            
        } else {
            
            formatter.timeStyle = .short
            formatter.dateStyle = .medium
            pubDateLabel?.textColor = .gray
        }
        
        return formatter.string(from: date)
    }
    
    // MARK: - Public Methods -
    
    ///
    /// This will load news to a cell
    ///
    /// - Parameter news: the loaded news
    ///
    func loadCell(with news: News?) {
        
        titleLabel?.text = news?.title ?? ""
        titleLabel?.textColor = .black
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        pubDateLabel?.font = UIFont.systemFont(ofSize: 10)
        
        guard let date = news?.pubDate else {
            
            pubDateLabel?.text = ""
            return
        }
        
        pubDateLabel?.text = "\(displayNewsDate(from: date))"
    }
}
