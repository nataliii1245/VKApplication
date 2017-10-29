//
//  PollAttachment.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

class PollAttachment: Attachment {
    
    /// Идентификатор опроса для получения информации о нем через метод
    let id: Int
    /// Идентификатор владельца опроса
    let owner_id: Int
    /// Текст вопроса
    let question: String
    /// Количество голосов
    let votes: Int
    
    // TODO: Сделать модель ответов на опрос https://vk.com/dev/objects/poll
    
    init?(json: JSON) {
        guard let id = json["id"].int else { return nil }
        self.id = id
        guard let owner_id = json["owner_id"].int else { return nil }
        self.owner_id = owner_id
        guard let question = json["question"].string else { return nil }
        self.question = question
        guard let votes = json["votes"].int else { return nil }
        self.votes = votes
    }
    
}


