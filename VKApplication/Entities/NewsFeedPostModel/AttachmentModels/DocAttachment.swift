//
//  DocAttachment.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

class DocAttachment: Attachment {
    
    let id: Int
    let title: String
    let size: Int
    let ext: String
    let url: String
    let date: Int
    
    init?(json: JSON) {
        guard let id = json["id"].int else { return nil }
        self.id = id
        guard let title = json["title"].string else { return nil }
        self.title = title
        guard let size = json["size"].int else { return nil }
        self.size = size
        guard let ext = json["ext"].string else { return nil }
        self.ext = ext
        guard let url = json["url"].string else { return nil }
        self.url = url
        guard let date = json["date"].int else { return nil }
        self.date = date
    }
    
}
