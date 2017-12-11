////
////  SmallNewsFeedTableViewCell.swift
////  VKApplicationWidget
////
////  Created by Natalia Volkova on 11.12.2017.
////  Copyright © 2017 Nataliia Volkova. All rights reserved.
////
//
//import UIKit
//import SDWebImage
//
//class SmallNewsFeedTableViewCell: UITableViewCell {
//    
//    @IBOutlet weak var sourceLabel: UILabel!
//    @IBOutlet weak var newsTextLabel: UILabel!
//    @IBOutlet weak var newsImage: UIImageView!
//    
//    func configure(with news: SmallNewsfeedModel, profileSources: [Friend], groupSources: [Group]) {
//        
//        if news.source_id > 0 {
//            for profile in profileSources {
//                if news.source_id == profile.id {
//                    sourceLabel.text = profile.name
//                }
//            }
//        } else {
//            for group in groupSources {
//                if news.source_id == group.id {
//                    sourceLabel.text = group.name
//                }
//            }
//        }
//        
//        newsTextLabel.text = news.text
//        
//        if let photoUrl = news.photoUrl {
//            let imageUrl = URL(string: photoUrl)
//            newsImage.sd_setImage(with: imageUrl, placeholderImage: nil)
//        }
//    }
//    
//}

