//
//  AppDelegate.swift
//  VKApplication
//
//  Created by Natalia Volkova on 14.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
}

class Bug {
    
    static var shared = Bug()
    
    private init() { }
    
    func `catch`(_ json: JSON) {
        print("bug")
        print(json)
    }
    
}
