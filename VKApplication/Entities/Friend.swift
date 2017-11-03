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
    @objc dynamic var displaySequence = 0
    
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
            return
        }
        
//        guard let photo = json["photo_200_orig"].string else { return nil }
//        self.photo = photo
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
    
}
