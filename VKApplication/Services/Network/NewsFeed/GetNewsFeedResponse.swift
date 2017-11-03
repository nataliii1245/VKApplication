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
    
    let newsFeedPosts: [NewsFeedPost]
    let groupsSource: [Group]
    let profilesSource: [Friend]
    
    required init?(json: JSON) {
        /*
         заметки на полях
         {
             "response": {
                 "items": // тут массив записей (реализовано)
                 "groups": // тут массив групп, чьи записи выше
                 "profiles": // тут массив друзей, чьи записи выше
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
        print(profilesSource)
    }
    
}
