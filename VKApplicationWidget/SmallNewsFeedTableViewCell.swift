//
//  SmallNewsFeedTableViewCell.swift
//  VKApplicationWidget
//
//  Created by Natalia Volkova on 11.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import SDWebImage

final class SmallNewsFeedTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var newsTextLabel: UILabel!
    @IBOutlet private weak var newsImage: UIImageView!
    
    
    // MARK: - Публичные свойства
    
    weak var dataSource: SmallNewsFeedTableViewCellDataSource?
    
}


// MARK: - Публичные методы

extension SmallNewsFeedTableViewCell {
    
    func configure(with news: SmallNewsfeedModel) {
        if news.source_id > 0 {
            self.sourceLabel.text = self.dataSource?.getProfileBy(id: news.source_id)?.name
        } else {
            self.sourceLabel.text = self.dataSource?.getGroupBy(id: abs(news.source_id))?.name
        }
        
        self.newsTextLabel.text = news.text.isEmpty ? "Новая запись" : news.text
        if let photoUrlValue = news.photoUrl, let photoUrl = URL(string: photoUrlValue) {
            self.newsImage.sd_setImage(with: photoUrl, placeholderImage: nil)
        }
    }
    
}

