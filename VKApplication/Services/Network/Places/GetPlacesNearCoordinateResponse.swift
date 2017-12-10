//
//  GetPlacesNearCoordinateResponse.swift
//  VKApplication
//
//  Created by Natalia Volkova on 06.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

/// Модель ответа на запрос на получение ближайших мест к определенной координате
final class GetPlacesNearCoordinateResponse {
    
    // MARK: - Публичные свойства
    
    /// Массив мест
    let places: [Place]
    
    
    // MARK: - Инициализация
    
    required init?(json: JSON) {
        if let count = json["response"]["count"].int, count > 0
        {
            guard let placesJSONArray = json["response"]["items"].array else { return nil }
            var places: [Place] = []
            
            for placeJson in placesJSONArray {
                guard let place = Place(json: placeJson) else { continue }
                places.append(place)
            }
            self.places = places
        } else {
            self.places = []
        }
    }
    
    
}

