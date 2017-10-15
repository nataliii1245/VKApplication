//
//  Group.swift
//  VKApplication
//
//  Created by Natalia Volkova on 15.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Group: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photo = ""
    @objc dynamic var type = ""
    
    convenience init?(json: JSON) {
        self.init()
        
        guard let id = json["id"].int,
            let name = json["name"].string,
            let type = json["type"].string,
            let photo = json["photo_200"].string
            else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.photo = photo
        self.type = type
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

