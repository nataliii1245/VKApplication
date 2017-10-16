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

let configuration = URLSessionConfiguration.default
let sessionManager = SessionManager(configuration: configuration)

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
    }
    
}
