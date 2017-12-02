//
//  AttachmentLinkViewDelegate.swift
//  VKApplication
//
//  Created by Natalia Volkova on 30.11.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation

protocol AttachmentLinkViewDelegate: class {
    
    /// Нажатие по ссылке
    func attachmentLinkView(_ attachmentLinkView: AttachmentLinkView, didSelect url: URL?)
    
}
