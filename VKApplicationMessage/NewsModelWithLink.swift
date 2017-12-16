//
//  NewsModelWithLink.swift
//  VKApplicationImessageExtension
//
//  Created by Natalia Volkova on 12.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import SwiftyJSON

final class NewsModelWithLink {
    
    /// Идентификатор источника новости (положительный — новость пользователя, отрицательный — новость группы);
    var source_id: Int = 0
    /// Находится в записях со стен и содержит идентификатор записи на стене владельца
    let post_id: Int
    /// Содержит текст записи;
    let text: String
    /// Ссылка на фото, прикрепленное к новости, если есть
    var photoUrl: String? = nil
    /// Ссылка на запись на стене
    let postUrl: String
    
    // MARK: - Инициализация
    
    init?(json: JSON) {
        
        self.post_id = json["post_id"].int!
        
        guard let source_id = json["source_id"].int else { return nil }
        self.source_id = source_id
        if source_id >= 0 {
            let address = String(source_id) + "_" + String(self.post_id)
            let postUrl = "https://vk.com/wall" + address
            self.postUrl = postUrl
        } else {
            let address = String(abs(source_id)) + "_" + String(self.post_id)
            let postUrl = "https://vk.com/wall-" + address
            self.postUrl = postUrl
        }
        
        guard let text = json["text"].string else { return nil }
        self.text = text
        
        if let attachmentsJSONArray = json["attachments"].array, !attachmentsJSONArray.isEmpty {
            for attachmentJSON in attachmentsJSONArray {
                guard let type = attachmentJSON["type"].string else { continue }
                if type == "photo" {
                    guard let photoUrl = attachmentJSON["photo"]["photo_75"].string else { return nil }
                    self.photoUrl = photoUrl
                    break
                }
            }
        }
    }
    
}
