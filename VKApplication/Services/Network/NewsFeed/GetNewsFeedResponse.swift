//
//  GetNewsFeedResponse.swift
//  VKApplication
//
//  Created by Natalia Volkova on 24.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

/// Модель ответа на запрос на получение новостей пользователя
final class GetNewsFeedResponse {
    
    // MARK: - Публичные свойства
    
    /// Массив новостей
    let newsFeedPosts: [NewsFeedPost]
    /// Массив групп - источников новостей
    let groupsSource: [Group]
    /// Массив пользователей - источников новостей
    let profilesSource: [Friend]
    /// Идентификатор для загрузки следующего блока новостей
    let nextFrom: String?
    
    
    // MARK: - Инициализация
    
    required init?(json: JSON) {
        /*
         заметки на полях
         {
             "response": {
                 "items": // тут массив записей (реализовано)
                 "groups": // тут массив групп, чьи записи выше(реализовано)
                 "profiles": // тут массив друзей, чьи записи выше(реализовано)
                 "next_from": // данные для получения следующей порции постов ленты
             }
         }
         */
        
        guard let newsFeedPostsJSONArray = json["response"]["items"].array else { return nil }
        let newsFeedPosts = newsFeedPostsJSONArray.flatMap { NewsFeedPost(json: $0, isRepost: false) }
        self.newsFeedPosts = newsFeedPosts
        
        guard let groupsSourceJSONArray = json["response"]["groups"].array else { return nil }
        let groupsSource = groupsSourceJSONArray.flatMap { Group(json: $0) }
        self.groupsSource = groupsSource
        
        guard let profilesSourceJSONArray = json["response"]["profiles"].array else { return nil }
        let profilesSource = profilesSourceJSONArray.flatMap { Friend(json: $0) }
        self.profilesSource = profilesSource
        
        guard let nextFrom = json["response"]["next_from"].string else { return nil }
        self.nextFrom = nextFrom
    }
    
}
