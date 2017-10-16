//
//  JoinGroupResponse.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

/// Модель ответа на запрос о вступлении в группу
final class JoinGroupResponse {
    
    let successful: Bool
    
    required init?(json: JSON) {
        guard let response = json["response"].int else { return nil }
        self.successful = response == 1
    }

}
