//
//  ChooseUserLocationTableViewCellDelegate.swift
//  VKApplication
//
//  Created by Natalia Volkova on 06.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import CoreLocation

protocol ChooseUserLocationTableViewControllerDelegate: class {
    
    /// Вернуть выбранное место
    func chooseUserLocationTableViewController(_ chooseUserLocationTableViewController: ChooseUserLocationViewController, place: Place)
    /// Вернуть выбранную геопозицию типа CLLocation
    func chooseUserLocationTableViewController(_ chooseUserLocationTableViewController: ChooseUserLocationViewController, location: CLLocation)
    
}
