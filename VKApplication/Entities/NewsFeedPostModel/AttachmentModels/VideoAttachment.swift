//
//  VideoAttachment.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

class VideoAttachment: Attachment {
    
    let id: Int
    let title: String
    let photoUrl: String
    let access_key: String
    let duration: Int
    let width: Int
    let height: Int
    
    init?(json: JSON) {
        guard let id = json["id"].int else { return nil }
        self.id = id
        guard let title = json["title"].string else { return nil }
        self.title = title
        
        if let photo_800 = json["photo_800"].string {
            photoUrl = photo_800
            width = 800
            height = 450
        } else if let photo_640 = json["photo_640"].string {
            photoUrl = photo_640
            width = 640
            height = 480
        } else if let photo_320 = json["photo_320"].string {
            photoUrl = photo_320
            width = 320
            height = 240
        } else if let photo_130 = json["photo_130"].string {
            photoUrl = photo_130
            width = 130
            height = 98
        } else {
            return nil
        }
        
        guard let access_key = json["access_key"].string else { return nil }
        self.access_key = access_key
        guard let duration = json["duration"].int else { return nil }
        self.duration = duration
    }
}
