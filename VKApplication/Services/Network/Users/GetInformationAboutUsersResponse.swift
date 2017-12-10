//
//  GetInformationAboutUsersResponse.swift
//  VKApplication
//
//  Created by Natalia Volkova on 10.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

/// Модель ответа на запрос на получение информации об отправителях заявок в друзья
final class GetInformationAboutUsersResponse {
    
    // MARK: - Публичные свойства
    
    /// Массив пользователей
    let users: [FriendRequestUser]
    
    
    // MARK: - Инициализация
    
    required init?(json: JSON) {
        guard let usersJSONArray = json["response"].array else { Bug.shared.catch(json); return nil }
        
        var users: [FriendRequestUser] = []
        
        var index = 0
        for usersJson in usersJSONArray {
            guard let user = FriendRequestUser(json: usersJson) else { Bug.shared.catch(usersJson); continue }
            
            user.displaySequence = index
            index += 1
            
            users.append(user)
        }
        
        self.users = users
    }
    
}
