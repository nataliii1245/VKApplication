//
//  ParallaxMapTableHeaderViewDelegate.swift
//  VKApplication
//
//  Created by Natalia Volkova on 05.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import CoreLocation

protocol ChooseUserLocationViewDelegate: class {
    func parallaxMapTableHeaderView(_ ParallaxMapTableHeaderView: ParallaxMapTableHeaderView, withLocation coordinate: CLLocationCoordinate2D)
}
