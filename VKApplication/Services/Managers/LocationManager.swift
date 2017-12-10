//
//  LocationManager.swift
//  VKApplication
//
//  Created by Natalia Volkova on 05.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import CoreLocation

final class LocationManager: NSObject {
    
    // MARK: - Приватные свойства
    
    private weak var delegate: LocationManagerDelegate?
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        return locationManager
    }()
    
    
    // MARK: - Инициализация
    
    init(delegate: LocationManagerDelegate) {
        super.init()
        
        self.delegate = delegate
        requestAuthorization()
    }
    
}


// MARK: - Публичные методы

extension LocationManager {

    /// Начать получение местоположения
    func startUpdateLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    /// Завершить получение местоположения
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
}


// MARK: - Приватные методы

private extension LocationManager {
    
    /// Запросить разрешение
    func requestAuthorization() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        guard authorizationStatus != .authorizedAlways && authorizationStatus != .authorizedWhenInUse else { return }
        
        self.locationManager.requestWhenInUseAuthorization()
    }
    
}


// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedAlways || status == .authorizedWhenInUse else { return }
        manager.startUpdatingLocation()
    }
    
    // Вызывается при изменении позиции
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        self.delegate?.locationManager(self, didUpdate: userLocation)
    }
    
}
