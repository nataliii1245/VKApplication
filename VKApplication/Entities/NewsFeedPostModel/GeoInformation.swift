//
//  GeoInformation.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//
import SwiftyJSON

class GeoInformation {

    /// Идентификатор места
    let place_id: Int
    /// Название места
    let title: String
    /// Тип места
    let typeOfPlace: String
    /// Идентификатор страны
    let country_id: Int
    /// Идентификатор города
    let city_id: Int
    /// Строка с указанием адреса места в городе
    let address: String
    /// Данный параметр указывается, если местоположение является прикреплённой картой
    let showmap: Bool
    
    init?(json: JSON) {
        guard let place_id = json["place_id"].int else { Bug.shared.catch(json); return nil }
        self.place_id = place_id
        guard let title = json["title"].string else { Bug.shared.catch(json); return nil }
        self.title = title
        guard let typeOfPlace = json["typeOfPlace"].string else { Bug.shared.catch(json); return nil }
        self.typeOfPlace = typeOfPlace
        guard let country_id = json["country_id"].int else { Bug.shared.catch(json); return nil }
        self.country_id = country_id
        guard let city_id = json["city_id"].int else { Bug.shared.catch(json); return nil }
        self.city_id = city_id
        guard let address = json["address"].string else { Bug.shared.catch(json); return nil }
        self.address = address
        guard let showmap = json["showmap"].int else { Bug.shared.catch(json); return nil }
        self.showmap = showmap == 1
    }
    
}

