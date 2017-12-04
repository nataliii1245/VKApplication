//
//  NewPostResponse.swift
//  VKApplication
//
//  Created by Natalia Volkova on 02.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

final class NewPostResponse {
    
    // MARK: - Публичные свойства
    
    /// Флаг успешного вступления в группу
    let postId: Int
    
    
    // MARK: - Инициализация
    
    required init?(json: JSON) {
        guard let postId = json["response"]["post_id"].int else { Bug.shared.catch(json); return nil }
        self.postId = postId
    }

}
