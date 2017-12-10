//
//  GetRequestsResponse.swift
//  VKApplication
//
//  Created by Natalia Volkova on 10.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

/// Модель ответа на запрос на получение заявок в друзья
final class GetRequestsResponse {
    
    // MARK: - Публичные свойства
    
    /// Массив друзей
    let friendRequests: [Int]
    
    
    // MARK: - Инициализация
    
    required init?(json: JSON) {
        guard let friendRequestsJSONArray = json["response"]["items"].array else { Bug.shared.catch(json); return nil }
        
        var friendRequests: [Int] = []
        for friendRequest in friendRequestsJSONArray {
            if let id = friendRequest.int {
                friendRequests.append(id)
            }
        }
        
        self.friendRequests = friendRequests
    }
    
}
