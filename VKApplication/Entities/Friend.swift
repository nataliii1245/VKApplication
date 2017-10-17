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

class Friend: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photo = ""
    
    convenience init?(json: JSON) {
        self.init()
        
        guard let id = json["id"].int else { return nil }
        self.id = id
        guard let firstName = json["first_name"].string,
            let lastName = json["last_name"].string else { return nil }
        self.name = firstName + " " + lastName
        guard let photo = json["photo_200_orig"].string else { return nil }
        self.photo = photo
    
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
    
}
