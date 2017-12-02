//
//  TabBarController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

import UIKit
import Alamofire

/// Конфигурация
let configuration = URLSessionConfiguration.default
/// Менеджер сессий
let sessionManager = SessionManager(configuration: configuration)

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
    }
    
}
