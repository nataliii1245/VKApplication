//
//  DatabaseManager.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import RealmSwift

final class DatabaseManager {
 
    // MARK: - Friends
    
    /// Сохранение списка друзей в бд
    class func saveFriends(_ friends: [Friend]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(friends)
            }
        } catch {
            print(error)
        }
    }
    
    /// Удаление списка друзей из бд
    class func removeFriends() {
        do {
            let friends = loadFriends()
            
            let realm = try Realm()
            try realm.write {
                realm.delete(friends)
            }
        } catch {
            print(error)
        }
    }
    
    /// Загрузка списка друзей из БД
    class func loadFriends() -> [Friend] {
        do {
            let realm = try Realm()
            let friends = realm.objects(Friend.self)
            
            return Array(friends)
        } catch {
            print(error)
            return []
        }
    }
    
    // MARK: - Groups
    
    /// Сохранение списка групп в бд
    class func saveGroups(_ groups: [Group]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(groups)
            }
        } catch {
            print(error)
        }
    }
    
    /// Удаление списка групп из бд
    class func removeGroups() {
        do {
            let groups = loadGroups()
            
            let realm = try Realm()
            try realm.write {
                realm.delete(groups)
            }
        } catch {
            print(error)
        }
    }
    
    /// Загрузка списка групп из бд
    class func loadGroups() -> [Group] {
        do {
            let realm = try Realm()
            let groups = realm.objects(Group.self)
            
            return Array(groups)
        } catch {
            print(error)
            return []
        }
    }
    
    // MARK: - Photos
    
    /// Сохранение списка фотографий в бд
    class func savePhotos(_ photos: [Photo]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(photos)
            }
        } catch {
            print(error)
        }
    }
    
    /// Удаление списка фотографий из бд
    class func removePhotos(){
        do {
            let photos = loadPhotos()
            
            let realm = try Realm()
            try realm.write {
                realm.delete(photos)
            }
        } catch {
            print(error)
        }
    }
    /// Загрузка списка фотографий из бд
    class func loadPhotos() -> [Photo] {
        do {
            let realm = try Realm()
            let photos = realm.objects(Photo.self)
            
            return Array(photos)
        } catch {
            print(error)
            return []
        }
    }
    
}
