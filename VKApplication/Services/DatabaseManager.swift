//
//  DatabaseManager.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import RealmSwift

/// Менеджер работы с базой данных Realm
final class DatabaseManager {
 
    // MARK: - Публичные методы
    
    /// Загрузка списка друзей из БД
    class func loadFriends() -> Results<Friend>? {
        do {
            let realm = try Realm()
            let friends = realm.objects(Friend.self).sorted(byKeyPath: "displaySequence", ascending: true)
            
            return friends
        } catch {
            print(error)
            return nil
        }
    }
    
    /// Сохранение списка друзей в бд
    class func saveFriends(_ friends: [Friend]) {
        do {
            let realm = try Realm()
            
            // Получили друзей в бд
            let existingFriends = realm.objects(Friend.self)
            
            // Получаем id загруженных друзей
            let loadedFriendsIds = friends.map { $0.id }
            
            // Получаем друзей, которых нет среди загруженных
            let deletionsFriends = existingFriends.filter { !loadedFriendsIds.contains($0.id) }
            
            // Записываем новые данные
            try realm.write {
                realm.delete(deletionsFriends)
                realm.add(friends, update: true)
            }
        } catch {
            print(error)
        }
    }
    
    /// Удалить друга
    class func removeFriend(_ friend: Friend) {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.delete(friend)
            }
        } catch {
            print(error)
        }
    }
    
    /// Загрузка списка групп из бд
    class func loadGroups() -> Results<Group>? {
        do {
            let realm = try Realm()
            let groups = realm.objects(Group.self)
            
            return groups
        } catch {
            print(error)
            return nil
        }
    }
    
    /// Сохранение списка групп в бд
    class func saveGroups(_ groups: [Group]) {
        do {
            let realm = try Realm()
            
            // Получили группы в бд
            let existingGroups = realm.objects(Group.self)
            
            // Получаем id загруженных групп
            let loadedGroupsIds = groups.map { $0.id }
            
            // Получаем группы, которых нет среди загруженных
            let deletionsGroups = existingGroups.filter { !loadedGroupsIds.contains($0.id) }
            
            // Записываем новые данные
            try realm.write {
                realm.delete(deletionsGroups)
                realm.add(groups, update: true)
            }
        } catch {
            print(error)
        }
    }
    
    /// Удалить группу
    class func removeGroup(_ group: Group) {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.delete(group)
            }
        } catch {
            print(error)
        }
    }
    
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
    class func removePhotos() {
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
