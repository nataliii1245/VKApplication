//
//  GetSmallNewsfeedResponse.swift
//  VKApplicationWidget
//
//  Created by Natalia Volkova on 11.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

/// Модель ответа на запрос на получение новостей пользователя
final class GetSmallNewsfeedResponse {
    
    // MARK: - Публичные свойства
    
    /// Массив новостей
    let smallNewsfeedPosts: [SmallNewsfeedModel]
    /// Массив групп - источников новостей
    let groupsSource: [Group]
    /// Массив пользователей - источников новостей
    let profilesSource: [Friend]
    
    
    // MARK: - Инициализация
    
    required init?(json: JSON) {
        guard let newsFeedPostsJSONArray = json["response"]["items"].array else { Bug.shared.catch(json); return nil }
        let smallNewsfeedPosts = newsFeedPostsJSONArray.flatMap { SmallNewsfeedModel(json: $0) }
        self.smallNewsfeedPosts = smallNewsfeedPosts
        
        guard let groupsSourceJSONArray = json["response"]["groups"].array else { Bug.shared.catch(json); return nil }
        let groupsSource = groupsSourceJSONArray.flatMap { Group(json: $0) }
        self.groupsSource = groupsSource
        
        guard let profilesSourceJSONArray = json["response"]["profiles"].array else { Bug.shared.catch(json); return nil }
        let profilesSource = profilesSourceJSONArray.flatMap { Friend(json: $0) }
        self.profilesSource = profilesSource
    }
        
}
