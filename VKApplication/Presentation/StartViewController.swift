//
//  StartViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 14.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserDefaults.standard.bool(forKey: "isUserAuthorized") {
            performSegue(withIdentifier: "ShowAuthorizationSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "ShowTabBarControllerSegue", sender: nil)
        }
    }
}
