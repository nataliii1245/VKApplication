//
//  SearchGroupsResponse.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

/// Модель ответа на запрос о поиске группы
final class SearchGroupsResponse {
    
    // MARK: - Публичные свойства
    
    /// Список групп
    let groups: [Group]
    
    
    // MARK: - Инициализация
    
    required init?(json: JSON) {
        guard let groupsJSONArray = json["response"]["items"].array else { return nil }
        let groups = groupsJSONArray.flatMap { Group(json: $0) }
        self.groups = groups
    }

}
