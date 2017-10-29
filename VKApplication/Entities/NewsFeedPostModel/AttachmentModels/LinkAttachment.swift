//
//  LinkAttachment.swift
//  VKApplication
//
//  Created by Natalia Volkova on 27.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

class LinkAttachment: Attachment {
    
    /// URL ссылки
    let url: String
    /// Заголовок ссылки
    let title: String
    /// Описание ссылки
    let description: String
    
    init?(json: JSON) {
        guard let url = json["url"].string else { return nil }
        self.url = url
        guard let title = json["title"].string else { return nil }
        self.title = title
        guard let description = json["description"].string else { return nil }
        self.description = description
    }
    
}
