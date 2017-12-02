//
//  NewsFeedTableViewCellDelegate.swift
//  VKApplication
//
//  Created by Natalia Volkova on 30.11.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation

protocol NewsFeedTableViewCellDelegate: class {
    
    /// Попытка открыть ссылку
    func newsFeedTableViewCell(_ newsFeedTableViewCell: NewsFeedTableViewCell, willOpen url: URL?)
    
}
