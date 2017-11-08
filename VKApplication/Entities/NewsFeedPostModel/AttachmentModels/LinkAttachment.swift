//
//  LinkAttachment.swift
//  VKApplication
//
//  Created by Natalia Volkova on 27.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

class LinkAttachment: Attachment {
    
    /// URL ссылки
    let url: String
    /// Заголовок ссылки
    var title: String? = nil
    /// Подпись ссылки (если имеется).
    var caption: String? = nil
    /// Ссылка на фото
    var photoUrl: String? = nil
    /// Ширина фото
    var width: Int? = nil
    /// Высота фото
    var height: Int? = nil
    
    
    init?(json: JSON) {
        guard let url = json["url"].string else { Bug.shared.catch(json); return nil }
        self.url = url
        self.title = json["title"].string
        self.caption = json["caption"].string
        
        if let photo_2560 = json["photo"]["photo_2560"].string {
            photoUrl = photo_2560
        } else if let photo_1280 = json["photo"]["photo_1280"].string {
            photoUrl = photo_1280
        } else if let photo_807 = json["photo"]["photo_807"].string {
            photoUrl = photo_807
        } else if let photo_604 = json["photo"]["photo_604"].string {
            photoUrl = photo_604
        } else if let photo_130 = json["photo"]["photo_130"].string {
            photoUrl = photo_130
        } else if let photo_75 = json["photo"]["photo_75"].string {
            photoUrl = photo_75
        }
        
        self.width = json["photo"]["width"].int
        self.height = json["photo"]["height"].int
    }
    
}


