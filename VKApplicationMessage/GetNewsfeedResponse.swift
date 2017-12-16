//
//  GetNewsfeedResponse.swift
//  VKApplicationImessageExtension
//
//  Created by Natalia Volkova on 12.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

/// Модель ответа на запрос на получение новостей пользователя
final class GetNewsfeedResponse {
    
    // MARK: - Публичные свойства
    
    /// Массив новостей
    let neewsfeedPosts: [NewsModelWithLink]
    /// Массив групп - источников новостей
    let groupsSource: [Group]
    /// Массив пользователей - источников новостей
    let profilesSource: [Friend]
    
    
    // MARK: - Инициализация
    
    required init?(json: JSON) {
        guard let newsFeedPostsJSONArray = json["response"]["items"].array else { return nil }
        let neewsfeedPosts = newsFeedPostsJSONArray.flatMap { NewsModelWithLink(json: $0) }
        self.neewsfeedPosts = neewsfeedPosts
        
        guard let groupsSourceJSONArray = json["response"]["groups"].array else { return nil }
        let groupsSource = groupsSourceJSONArray.flatMap { Group(json: $0) }
        self.groupsSource = groupsSource
        
        guard let profilesSourceJSONArray = json["response"]["profiles"].array else { return nil }
        let profilesSource = profilesSourceJSONArray.flatMap { Friend(json: $0) }
        self.profilesSource = profilesSource
    }
    
}
