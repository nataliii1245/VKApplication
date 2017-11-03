//
//  NewsFeedTableViewCellDataSource.swift
//  
//
//  Created by Natalia Volkova on 02.11.2017.
//

protocol NewsFeedTableViewCellDataSource: class {
    
    ///
    func getGroupBy(id: Int) -> Group?
    ///
    func getProfileBy(id: Int) -> Friend?
    
}
