//
//  PhotoAttachment.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

class PhotoAttachment: Attachment {
    
    /// Идентификатор фотографии
    let id: Int
    /// Ссылка на фото
    let photoUrl: String
    /// Ширина оригинала фотографии в пикселах
    let width: Int?
    /// Высота оригинала фотографии в пикселах
    let height: Int?
    
    init?(json: JSON) {
        guard let id = json["id"].int else { return nil }
        self.id = id
        
        if let photo_2560 = json["photo_2560"].string {
            photoUrl = photo_2560
        } else if let photo_1280 = json["photo_1280"].string {
            photoUrl = photo_1280
        } else if let photo_807 = json["photo_807"].string {
            photoUrl = photo_807
        } else if let photo_604 = json["photo_604"].string {
            photoUrl = photo_604
        } else if let photo_130 = json["photo_130"].string {
            photoUrl = photo_130
        } else if let photo_75 = json["photo_75"].string {
            photoUrl = photo_75
        } else {
            photoUrl = ""
        }
        
        width = json["width"].int
        height = json["height"].int
    }
    
}
