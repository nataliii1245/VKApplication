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
    
    case showTabBarControllerFromStart = "ShowTabBarControllerFromStartSegue"
    case showAuthorization = "ShowAuthorizationSegue"
    case showTabBarControllerFromAuthorization = "ShowTabBarControllerFromAuthorizationSegue"
    case showFriendPhotos = "ShowFriendPhotosSegue"
}


// MARK: - UIViewController

extension UIViewController {
    
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
}
