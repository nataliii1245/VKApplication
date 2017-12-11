//
//  SmallNewsfeedModel.swift
//  VKApplicationWidget
//
//  Created by Natalia Volkova on 11.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

final class SmallNewsfeedModel {
    
    /// Идентификатор источника новости (положительный — новость пользователя, отрицательный — новость группы);
    let source_id: Int
    /// Находится в записях со стен и содержит текст записи;
    let text: String
    /// Ссылка на фото, прикрепленное к новости, если есть
    var photoUrl: String? = nil
    
    // MARK: - Инициализация
    
    init?(json: JSON) {
        guard let source_id = json["source_id"].int else { Bug.shared.catch(json); return nil }
        self.source_id = source_id
        
        guard let text = json["text"].string else { Bug.shared.catch(json); return nil }
        self.text = text
        
        if let attachmentsJSONArray = json["attachments"].array, !attachmentsJSONArray.isEmpty {
            for attachmentJSON in attachmentsJSONArray {
                guard let type = attachmentJSON["type"].string else { continue }
                if type == "photo" {
                    guard let photoUrl = attachmentJSON["photo"]["photo_75"].string else { Bug.shared.catch(json); return nil }
                    self.photoUrl = photoUrl
                    break
                }
            }
        }
    }
    
}
