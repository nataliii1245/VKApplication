//
//  SmallNewsFeedTableViewCellDataSource.swift
//  VKApplicationWidget
//
//  Created by Natalia Volkova on 12.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

protocol SmallNewsFeedTableViewCellDataSource: class {
    
    /// Получить группу по идентификатору
    func getGroupBy(id: Int) -> Group?
    /// Получить информацию о профиле по идентификатору
    func getProfileBy(id: Int) -> Friend?
    
}
