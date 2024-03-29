//
//  AttachmentModel.swift
//  VKApplication
//
//  Created by Natalia Volkova on 26.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//
import SwiftyJSON

final class AttachmentModel {
    
    // MARK: - Публичные свойства
    
    let entity: Attachment?
    
    
    // MARK: - Инициализация
    
    init?(json: JSON) {
        guard let type = json["type"].string else { Bug.shared.catch(json); return nil }
        guard let attachmentType = AttachmentType(rawValue: type) else { Bug.shared.catch(json); return nil }
        
        switch attachmentType {
        case .photo:
            let photoJSON = json["photo"]
            entity = PhotoAttachment(json: photoJSON)
        case .video:
            let videoJSON = json["video"]
            entity = VideoAttachment(json: videoJSON)
        case .audio:
            let audioJSON = json["audio"]
            entity = AudioAttachment(json: audioJSON)
        case .doc:
            let docJSON = json["doc"]
            entity = DocAttachment(json: docJSON)
        case .poll:
            let pollJSON = json["poll"]
            entity = PollAttachment(json: pollJSON)
        case .link:
            let linkJSON = json["link"]
            entity = LinkAttachment(json: linkJSON)
        }
    }
    
}

/// Список доступных типов вложений
enum AttachmentType: String {
    
    case photo
    case video
    case audio
    case doc
    case poll
    case link
    
}
