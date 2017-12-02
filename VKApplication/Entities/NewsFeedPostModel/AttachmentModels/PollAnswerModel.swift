//
//  PollAnswerModel.swift
//  VKApplication
//
//  Created by Natalia Volkova on 02.11.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

final class PollAnswerModel {
    
    // MARK: - Публичные свойства
    
    /// Идентификатор ответа
    let id: Int
    /// Текст ответа
    let text: String
    /// Число проголосовавших за этот ответ
    let votes: Int
    /// Рейтинг ответа
    let rate: Double
    
    
    // MARK: - Инициализация
    
    init?(json: JSON) {
        guard let id = json["id"].int else { Bug.shared.catch(json); return nil }
        self.id = id
        guard let text = json["text"].string else { Bug.shared.catch(json); return nil }
        self.text = text
        guard let votes = json["votes"].int else { Bug.shared.catch(json); return nil }
        self.votes = votes
        guard let rate = json["rate"].double else { Bug.shared.catch(json); return nil }
        self.rate = rate
    }
    
}
