//
//  AudioAttachment.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

class AudioAttachment: Attachment {
    
    let id: Int
    let artist: String
    let title: String
    let duration: Int
    
    init?(json: JSON) {
        guard let id = json["id"].int else { Bug.shared.catch(json); return nil }
        self.id = id
        guard let artist = json["artist"].string else { Bug.shared.catch(json); return nil }
        self.artist = artist
        guard let title = json["title"].string else { Bug.shared.catch(json); return nil }
        self.title = title
        guard let duration = json["duration"].int else { Bug.shared.catch(json); return nil }
        self.duration = duration
    }
    
}
