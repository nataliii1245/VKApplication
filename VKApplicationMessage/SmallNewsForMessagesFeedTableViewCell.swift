//
//  SmallNewsfeedForMessagesTableViewCell.swift
//  VKApplicationImessageExtension
//
//  Created by Natalia Volkova on 12.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import SDWebImage

final class SmallNewsfeedForMessagesTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var newsTextLabel: UILabel!
    @IBOutlet private weak var newsImage: UIImageView!
    
    
    // MARK: - Публичные свойства
    
    weak var dataSource: SmallNewsFeedTableViewCellDataSource?
    
}


// MARK: - Публичные методы

extension SmallNewsfeedForMessagesTableViewCell {
    
    func configure(with news: NewsModelWithLink) {
        if news.source_id > 0 {
            self.sourceLabel.text = self.dataSource?.getProfileBy(id: news.source_id)?.name
        } else {
            self.sourceLabel.text = self.dataSource?.getGroupBy(id: abs(news.source_id))?.name
        }
        
        self.newsTextLabel.text = news.text.isEmpty ? "Новая запись" : news.text
        if let photoUrlValue = news.photoUrl, let photoUrl = URL(string: photoUrlValue) {
            self.newsImage.sd_addActivityIndicator()
            self.newsImage.sd_setIndicatorStyle(.gray)
            self.newsImage.sd_setImage(with: photoUrl, placeholderImage: nil)
            self.newsImage.isHidden = false
        } else {
            self.newsImage.image = nil
            self.newsImage.isHidden = true
        }
    }
    
}
