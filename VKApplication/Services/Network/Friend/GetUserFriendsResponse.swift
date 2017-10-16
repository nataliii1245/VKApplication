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
    
    let friends: [Friend]
    
    required init?(json: JSON) {
        guard let friendsJSONArray = json["response"]["items"].array else { return nil }
        let friends = friendsJSONArray.flatMap { Friend(json: $0) }
        self.friends = friends
        
    }
}
