//
//  SegueIdentifier.swift
//  VKApplication
//
//  Created by Natalia Volkova on 15.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

/// Структура хранит все доступные имена Segue приложения
enum SegueIdentifier: String {
    
    /// Отобразить таббар для уже авторизованного пользователя
    case showTabBarControllerFromStart = "ShowTabBarControllerFromStartSegue"
    /// Отобразить экран авторизации
    case showAuthorization = "ShowAuthorizationSegue"
    /// Отобразить таббар после успешной авторизации
    case showTabBarControllerFromAuthorization = "ShowTabBarControllerFromAuthorizationSegue"
    /// Отобразить фотографии друзей
    case showFriendPhotos = "ShowFriendPhotosSegue"
    /// Отобразить окно создания новой записи на стене
    case showNewPost = "ShowNewPostSegue"
}


// MARK: - UIViewController

extension UIViewController {
    
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
}
