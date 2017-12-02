//
//  NewsFeedTableViewCellDataSource.swift
//  
//
//  Created by Natalia Volkova on 02.11.2017.
//

protocol NewsFeedTableViewCellDataSource: class {

    /// Получить группу по идентификатору
    func getGroupBy(id: Int) -> Group?
    /// Получить информацию о профиле по идентификатору
    func getProfileBy(id: Int) -> Friend?
    
}
