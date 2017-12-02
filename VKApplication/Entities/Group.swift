//
//  Group.swift
//  VKApplication
//
//  Created by Natalia Volkova on 15.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import RealmSwift
import SwiftyJSON

final class Group: Object {
    
    // MARK: - Публичные свойства
    
    /// Идентификатор группы
    @objc dynamic var id = 0
    /// Название группы
    @objc dynamic var name = ""
    /// Ссылка на аватар группы
    @objc dynamic var photo = ""
    /// Тип группы
    @objc dynamic var type = ""
    
    
    // MARK: - Инициализация
    
    convenience init?(json: JSON) {
        self.init()
        
        guard let id = json["id"].int,
            let name = json["name"].string,
            let type = json["type"].string,
            let photo = json["photo_200"].string
        else { Bug.shared.catch(json); return nil }
        
        self.id = id
        self.name = name
        self.photo = photo
        self.type = type
    }
    
    
    // MARK: - Object
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
