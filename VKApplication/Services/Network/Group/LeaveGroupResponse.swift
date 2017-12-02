//
//  LeaveGroupResponse.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

/// Модель ответа на запрос о выходе из группы
final class LeaveGroupResponse {
    
    // MARK: - Публичные свойства
    
    /// Флаг успешного выхода из группы
    let successful: Bool
    
    
    // MARK: - Инициализация
    
    required init?(json: JSON) {
        guard let response = json["response"].int else { return nil }
        self.successful = response == 1
    }
    
}
