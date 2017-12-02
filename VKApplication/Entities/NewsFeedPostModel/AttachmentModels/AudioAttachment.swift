//
//  AudioAttachment.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

final class AudioAttachment: Attachment {
    
    // MARK: - Публичные свойства
    
    /// Идентификатор аудиозаписи
    let id: Int
    /// Имя артиста
    let artist: String
    /// Название аудиозаписи
    let title: String
    /// Длительность аудиозаписи
    let duration: Int
    
    
    // MARK: - Инициализация
    
    init?(json: JSON) {
        guard let id = json["id"].int else { Bug.shared.catch(json); return nil }
        self.id = id
        guard let artist = json["artist"].string else { Bug.shared.catch(json); return nil }
        self.artist = artist
        guard let title = json["title"].string else { Bug.shared.catch(json); return nil }
        self.title = title
        guard let duration = json["duration"].int else { Bug.shared.catch(json); return nil }
        self.duration = duration
    }
    
}
