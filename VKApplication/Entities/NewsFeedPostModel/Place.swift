//
//  Place.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

class Place {

    // MARK: - Публичные свойства
    
    /// Идентификатор места
    let id: Int
    /// Название места
    let title: String
    /// Географическая широта, заданная в градусах (от -90 до 90)
    let latitude: Float
    /// Географическая долгота, заданная в градусах (от -180 до 180)
    let longitude: Float
    /// Дата добавления места
    let created: Int
    /// URL ссылки на иконку
    let icon: String
    /// Количество чекинов
    let checkins: Int
    /// Идентификатор типа места
    let type: Int
    /// Адрес
    let address: String
    /// Расстояние от исходной точки
    let distance: Int
    
    
    // MARK: - Инициализация
    
    init?(json: JSON) {
        guard let id = json["id"].int else { Bug.shared.catch(json); return nil }
        self.id = id
        guard let title = json["title"].string else { Bug.shared.catch(json); return nil }
        self.title = title
        guard let latitude = json["latitude"].float else { Bug.shared.catch(json); return nil }
        self.latitude = latitude
        guard let longitude = json["longitude"].float else { Bug.shared.catch(json); return nil }
        self.longitude = longitude
        guard let created = json["created"].int else { Bug.shared.catch(json); return nil }
        self.created = created
        guard let icon = json["icon"].string else { Bug.shared.catch(json); return nil }
        self.icon = icon
        guard let checkins = json["checkins"].int else { Bug.shared.catch(json); return nil }
        self.checkins = checkins
        guard let type = json["type"].int else { Bug.shared.catch(json); return nil }
        self.type = type
        guard let address = json["address"].string else { Bug.shared.catch(json); return nil }
        self.address = address
        guard let distance = json["distance"].int else { Bug.shared.catch(json); return nil }
        self.distance = distance
    }
    
}
