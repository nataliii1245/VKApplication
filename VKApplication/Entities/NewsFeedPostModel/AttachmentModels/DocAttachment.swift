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
        guard let id = json["id"].int else { Bug.shared.catch(json); return nil }
        self.id = id
        guard let title = json["title"].string else { Bug.shared.catch(json); return nil }
        self.title = title
        guard let size = json["size"].int else { Bug.shared.catch(json); return nil }
        self.size = size
        guard let ext = json["ext"].string else { Bug.shared.catch(json); return nil }
        self.ext = ext
        guard let url = json["url"].string else { Bug.shared.catch(json); return nil }
        self.url = url
        guard let date = json["date"].int else { Bug.shared.catch(json); return nil }
        self.date = date
    }
    
}
