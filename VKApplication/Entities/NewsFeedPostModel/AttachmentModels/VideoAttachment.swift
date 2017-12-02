//
//  VideoAttachment.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

final class VideoAttachment: Attachment {
    
    // MARK: - Публичные свойства
    
    /// Идентификатор видеозаписи
    let id: Int
    /// Название видео
    let title: String
    /// Ссылка на превью
    let photoUrl: String
    /// Ключ доступа
    let access_key: String
    /// Длительность видео
    let duration: Int
    /// Ширина видео
    let width: Int
    /// Высота видео
    let height: Int
    
    
    // MARK: - Инициализация
    
    init?(json: JSON) {
        guard let id = json["id"].int else { Bug.shared.catch(json); return nil }
        self.id = id
        guard let title = json["title"].string else { Bug.shared.catch(json); return nil }
        self.title = title
        
        if let photo_800 = json["photo_800"].string {
            photoUrl = photo_800
            width = 800
            height = 450
        } else if let photo_640 = json["photo_640"].string {
            photoUrl = photo_640
            width = 640
            height = 480
        } else if let photo_320 = json["photo_320"].string {
            photoUrl = photo_320
            width = 320
            height = 240
        } else if let photo_130 = json["photo_130"].string {
            photoUrl = photo_130
            width = 130
            height = 98
        } else {
            Bug.shared.catch(json); return nil
        }
        
        guard let access_key = json["access_key"].string else { Bug.shared.catch(json); return nil }
        self.access_key = access_key
        guard let duration = json["duration"].int else { Bug.shared.catch(json); return nil }
        self.duration = duration
    }
    
}
