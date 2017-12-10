//
//  BackgroundManager.swift
//  VKApplication
//
//  Created by Natalia Volkova on 10.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation

final class BackgroundManager {
    
    // MARK: - Публичные свойства
    
    private(set) static var instance = BackgroundManager()
    
    /// Тайм-аут таймер
    var timer: DispatchSourceTimer?
    
    
    // MARK: - Инициализация
    
    private init() { }
    
}


// MARK: - Публичные свойства

extension BackgroundManager {
    
    /// Дата последнего обновления
    var lastUpdate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "LastUpdate") as? Date
        }
        set {
            UserDefaults.standard.setValue(Date(), forKey: "LastUpdate")
        }
    }
    
}
