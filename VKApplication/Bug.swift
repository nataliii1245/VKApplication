//
//  Bug.swift
//  VKApplication
//
//  Created by Natalia Volkova on 10.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import SwiftyJSON

final class Bug {
    
    // MARK: - Публичные свойства
    
    private(set) static var shared = Bug()
    
    
    // MARK: - Инициализация
    
    private init() { }
    
}


// MARK: - Публичные методы

extension Bug {
    
    func `catch`(_ json: JSON) {
        print("bug")
        print(json)
    }
}
