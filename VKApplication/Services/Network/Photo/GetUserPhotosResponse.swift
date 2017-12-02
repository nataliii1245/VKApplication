//
//  GetUserPhotosResponse.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

/// Модель ответа на запрос о получении фотографий пользователя
final class GetUserPhotosResponse {
    
    // MARK: - Публичные свойства
    
    /// Массив фотографий
    let photos: [Photo]
    
    
    // MARK: - Инициализация
    
    required init?(json: JSON) {
        guard let photosJSONArray = json["response"]["items"].array else { return nil }
        let photos = photosJSONArray.flatMap { Photo(json: $0) }
        self.photos = photos
    }
    
}
