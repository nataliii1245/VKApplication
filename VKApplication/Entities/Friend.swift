//
//  Friend.swift
//  VKApplication
//
//  Created by Natalia Volkova on 15.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

final class Friend: Object {
    
    // MARK: - Публичные свойства
    
    /// id пользователя
    @objc dynamic var id = 0
    /// Имя пользователя
    @objc dynamic var name = ""
    /// Ссылка на аватар пользователя
    @objc dynamic var photo = ""
    /// Номер в порядке отображения
    @objc dynamic var displaySequence = 0
    
    
    // MARK: - Инициализация
    
    convenience init?(json: JSON) {
        self.init()
        
        guard let id = json["id"].int else { return nil }
        self.id = id
        guard let firstName = json["first_name"].string,
            let lastName = json["last_name"].string else { return nil }
        self.name = firstName + " " + lastName
        
        if let photo_200_orig = json["photo_200_orig"].string {
            self.photo = photo_200_orig
        } else if let photo_100 = json["photo_100"].string {
            self.photo = photo_100
        } else if let photo_50 = json["photo_50"].string {
            self.photo = photo_50
        }  else {
             return nil
        }
    }
    
    
    // MARK: - Object
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
