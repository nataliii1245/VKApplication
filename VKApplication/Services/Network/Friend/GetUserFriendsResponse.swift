//
//  GetUserFriendsResponse.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

/// Модель ответа на запрос на получение друзей пользователя
final class GetUserFriendsResponse {
    
    // MARK: - Публичные свойства
    
    /// Массив друзей
    let friends: [Friend]
    
    
    // MARK: - Инициализация
    
    required init?(json: JSON) {
        guard let friendsJSONArray = json["response"]["items"].array else { return nil }
        
        var friends: [Friend] = []
        
        var index = 0
        for friendJson in friendsJSONArray {
            guard let friend = Friend(json: friendJson) else { continue }
            
            friend.displaySequence = index
            index += 1
            
            friends.append(friend)
        }
        
        self.friends = friends
    }
    
}
