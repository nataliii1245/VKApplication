//
//  NewsFeedPost.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

class NewsFeedPost {
    
    /// Тип списка новости, соответствующий одному из значений параметра filters;
    let type: String?
    /// Идентификатор источника новости (положительный — новость пользователя, отрицательный — новость группы);
    var source_id: Int = 0
    /// Время публикации новости в формате unixtime;
    let date: Int
    /// Находится в записях со стен, содержит тип новости (post или copy);
    let post_type: String?
    /// Находится в записях со стен и содержит текст записи;
    let text: String
    /// Находится в записях со стен и содержит информацию о комментариях к записи, содержит количество комментариев
    let commentsCount: Int?
    /// Находится в записях со стен и содержит информацию о числе людей, которым понравилась данная запись, содержит число пользователей, которым понравилась запись
    let likesCount: Int?
    /// Находится в записях со стен и содержит информацию о числе людей, которые скопировали данную запись на свою страницу, содержит число пользователей, сделавших репост
    let repostsCount: Int?
    /// Находится в записях со стен и содержит массив объектов, которые прикреплены к текущей новости (фотография, ссылка и т.п.).
    var attachments: [Attachment]
    /// Находится в записях со стен, в которых имеется информация о местоположении
    let geo: Place?
    /// Находится в записях со стен и содержит идентификатор записи на стене владельца
    let post_id: Int?
    /// Количество просмотров записи
    let views: Int?
    /// ID источника репоста
    var owner_id: Int = 0
    /// Идентификатор автора поста
    var signer_id: Int?
    /// Является ли репостом
    let isRepost: Bool = false
    /// Массив репостов
    var repostPosts: [NewsFeedPost] = []
    
    
    // MARK: - Инициализация
    
    init?(json: JSON, isRepost: Bool) {
        
        self.type = json["type"].string
        
        if !isRepost {
            guard let source_id = json["source_id"].int else { Bug.shared.catch(json); return nil }
            self.source_id = source_id
        } else {
            guard let owner_id = json["owner_id"].int else { Bug.shared.catch(json); return nil }
            self.owner_id = owner_id
        }
        
        guard let date = json["date"].int else { Bug.shared.catch(json); return nil }
        self.date = date
        
        self.post_type = json["post_type"].string
        self.post_id = json["post_id"].int
        
        guard let text = json["text"].string else { Bug.shared.catch(json); return nil }
        self.text = text
        
        self.commentsCount = json["comments"]["count"].int
        self.likesCount = json["likes"]["count"].int
        self.repostsCount = json["reposts"]["count"].int
        self.views = json["views"]["count"].int
        self.signer_id = json["signer_id"].int
        
        var repostPostsArray: [NewsFeedPost] = []
        if let repostJSONArray = json["copy_history"].array, !repostJSONArray.isEmpty {
            for repostJSON in repostJSONArray {
                guard let repostNewsFeedPost = NewsFeedPost(json: repostJSON, isRepost: true ) else { continue }
                repostPostsArray.append(repostNewsFeedPost)
            }
            self.repostPosts = repostPostsArray
        }
        
        var attachments: [Attachment] = []
        if let attachmentsJSONArray = json["attachments"].array, !attachmentsJSONArray.isEmpty {
            for attachmentJSON in attachmentsJSONArray {
                guard let attachmentModel = AttachmentModel(json: attachmentJSON), let attachment = attachmentModel.entity else { continue }
                attachments.append(attachment)
            }
        }
        self.attachments = attachments
        
//        let geo = GeoInformation(json: json["geo"])
//        self.geo = geo
        self.geo = nil
    }
    
}
