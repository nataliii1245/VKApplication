//
//  PollAnswerModel.swift
//  VKApplication
//
//  Created by Natalia Volkova on 02.11.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

class PollAnswerModel {
    
    /// Идентификатор ответа
    let id: Int
    /// Текст ответа
    let text: String
    /// Число проголосовавших за этот ответ
    let votes: String
    /// Рейтинг ответа
    let rate: Int
    
    init?(json: JSON) {
        guard let id = json["id"].int else { return nil }
        self.id = id
        guard let text = json["text"].string else { return nil }
        self.text = text
        guard let votes = json["votes"].string else { return nil }
        self.votes = votes
        guard let rate = json["rate"].int else { return nil }
        self.rate = rate
    }
}
