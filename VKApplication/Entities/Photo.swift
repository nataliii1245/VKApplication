//
//  Photo.swift
//  VKApplication
//
//  Created by Natalia Volkova on 15.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Photo: Object {
    
    // MARK: - Публичные свойства
    
    /// Идентификатор фотографии
    @objc dynamic var id = 0
    /// Идентификатор пользователя, чья фотография
    @objc dynamic var ownerId = 0
    /// Ссылка на фотографию
    @objc dynamic var url = ""
    
    
    // MARK: - Инициализация
    
    convenience init?(json: JSON) {
        self.init()
        
        guard let id = json["id"].int,
            let ownerId = json["owner_id"].int,
            let url = json["photo_1280"].string
        else { Bug.shared.catch(json); return nil }
        
        self.id = id
        self.ownerId = ownerId
        self.url = url
    }
    
    
    // MARK: - Object
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
