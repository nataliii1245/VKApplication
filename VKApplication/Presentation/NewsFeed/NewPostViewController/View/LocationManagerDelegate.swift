//
//  LocationManagerDelegate.swift
//  VKApplication
//
//  Created by Natalia Volkova on 05.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import CoreLocation

protocol LocationManagerDelegate: class {
    
    /// Получена точка локации пользователя
    func locationManager(_ locationManager: LocationManager, didUpdate location: CLLocation)
    
}
