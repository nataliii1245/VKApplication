//
//  PollAttachment.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

final class PollAttachment: Attachment {
    
    // MARK: - Публичные свойства
    
    /// Идентификатор опроса для получения информации о нем через метод
    let id: Int
    /// Идентификатор владельца опроса
    let owner_id: Int
    /// Текст вопроса
    let question: String
    /// Количество голосов
    let votes: Int
    /// Масив ответов на опрос
    let pollAnswerAttachments:[PollAnswerModel]
    
    
    // MARK: - Инициализация
    
    init?(json: JSON) {
        guard let id = json["id"].int else { Bug.shared.catch(json); return nil }
        self.id = id
        guard let owner_id = json["owner_id"].int else { Bug.shared.catch(json); return nil }
        self.owner_id = owner_id
        guard let question = json["question"].string else { Bug.shared.catch(json); return nil }
        self.question = question
        guard let votes = json["votes"].int else { Bug.shared.catch(json); return nil }
        self.votes = votes
        guard let pollAnswerAttachmentsArray = json["answers"].array else { Bug.shared.catch(json); return nil }
        var pollAnswerArray: [PollAnswerModel] = []
        for pollAnswer in pollAnswerAttachmentsArray {
            if let answer = PollAnswerModel(json: pollAnswer) {
                pollAnswerArray.append(answer)
            }
        }
        self.pollAnswerAttachments =  pollAnswerArray
    }
    
}
