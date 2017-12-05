//
//  ParallaxMapTableHeaderView.swift
//  VKApplication
//
//  Created by Natalia Volkova on 05.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class ParallaxMapTableHeaderView: UIView {
    
    // MARK: - Публичные свойства
    
    /// Информация о местоположении пользователя
    var userLocation: CLLocation? {
        willSet {
            guard let userLocation = newValue else { return }
            centerMap(on: userLocation)
        }
    }
    
    
    // MARK: - Приватные свойства
    
    /// Коэффициент, с которым карта смещается
    private let parallaxDeltaFactor: CGFloat = 0.5
    /// Радиус отображаемого региона
    private let regionRadius: CLLocationDistance = 1500
    
    /// View, в котором отображается видимая часть headerView
    private var visibleView: UIView!
    /// Карта
    private var mapView: MKMapView!
    
    
    // MARK: - Инициализация
    
    // Принимает размер headerView
    convenience init(size: CGSize) {
        self.init(frame: CGRect(origin: .zero, size: size))
        
        // Создать UIView, с внешними границами равными внутренним границам headerView
        self.visibleView = UIView(frame: self.bounds)
        // Обрезать содержимое view, выходящее за границы видимой части headerView
        self.visibleView.clipsToBounds = true
        // Добавить в headerView обрезанное view
        self.addSubview(self.visibleView)
        
        // Создать mapView
        self.mapView = MKMapView(frame: CGRect(origin: .zero, size: CGSize(width: self.visibleView.bounds.width, height: UIScreen.main.bounds.height)))
        self.mapView.showsUserLocation = true
        self.mapView.tintColor = .black
        // Запретить взаимодействие с mapView
        self.mapView.isUserInteractionEnabled = false
        // Приравнять центр mapView центру видимой части headerView
        self.mapView.center = self.visibleView.center
        // Добавить в visibleView mapView
        self.visibleView.addSubview(self.mapView)
    }
    
}


// MARK: - Публичные методы

extension ParallaxMapTableHeaderView {
    
    /// Пересчитать расположение содержимого с учетом сдвига
    func layoutForContentOffset(_ contentOffset: CGPoint) {
        // При сдвиге (промотке вниз)
        if contentOffset.y > 0 {
            // Пересчитать смещение
            let offset = contentOffset.y * self.parallaxDeltaFactor
            // Установить значение y для центра mapView c учетом смещения
            self.mapView.center.y = self.visibleView.center.y + offset
        } else {
            let offset = fabs(contentOffset.y)
            // Установить значение y для origin visibleView равным смещению
            self.visibleView.frame.origin.y = 0 - offset
            // Установить значение высоты visibleView с учетом смещения
            self.visibleView.frame.size.height = self.bounds.height + offset
            // Установить значение y для центра mapView c учетом смещения
            self.mapView.center.y = self.visibleView.center.y + offset
        }
    }
    
}


// MARK: - Приватные методы

private extension ParallaxMapTableHeaderView {
    
    /// Центрировать карту
    func centerMap(on location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, self.regionRadius, self.regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
}
