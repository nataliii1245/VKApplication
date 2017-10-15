//
//  StartViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 14.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

final class StartViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.isUserAuthorized) {
            performSegue(withIdentifier: .showTabBarControllerFromStart, sender: nil)
        } else {
            performSegue(withIdentifier: .showAuthorization, sender: nil)
        }
    }
    
}
