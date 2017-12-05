//
//  ParallaxMapTableHeaderView.swift
//  VKApplication
//
//  Created by Natalia Volkova on 05.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import MapKit

final class ParallaxMapTableHeaderView: UIView {
    
    // MARK: - Приватные свойства
    
    /// Коэффициент, с которым карта смещается
    private let parallaxDeltaFactor: CGFloat = 0.5
    /// View, в котором отображается видимая часть headerView
    private var visibleView: UIView!
    /// ScrollView для headerView
    private var scrollView: UIScrollView!
    /// View карты
    private var mapView: MKMapView!
    
    
    // MARK: - Инициализация
    
    // Принимает размер headerView
    convenience init(size: CGSize) {
        
        // Обращаемся к стандартному конструктору, размер равен размеру headerView
        self.init(frame: CGRect(origin: .zero, size: size))
        
        // Приравнять внешние и внутренние границы
        self.visibleView = UIView(frame: self.bounds)
        // Обрезать view, содержащее видимую часть headerView
        self.visibleView.clipsToBounds = true
        // Добавить в headerView обрезанное view
        self.addSubview(self.visibleView)
        
        // В scrollView записать scrollView, с шириной видимой части headerView и высотой равной высоте экрана
        self.scrollView = UIScrollView(frame: CGRect(origin: .zero, size: CGSize(width: self.visibleView.bounds.width, height: UIScreen.main.bounds.height)))
        // Приравнять центр scrollView центру видимой части headerView
        self.scrollView.center = self.visibleView.center
        // Добавить в visibleView scrollView
        self.visibleView.addSubview(self.scrollView)
        
        // Создать mapView с размерами внутренней части scrollView
        self.mapView = MKMapView(frame: self.scrollView.bounds)
        // Запретить взаимодействие с mapView
        self.mapView.isUserInteractionEnabled = false
        // Добавить в scrollView mapView
        self.scrollView.addSubview(self.mapView)
    }
    
    
    // MARK: - Публичные методы
    
    /// Пересчитать расположение сожержимого с учетом сдвига
    func layoutForContentOffset(_ contentOffset: CGPoint) {
        // При сдвиге (промотке вниз)
        if contentOffset.y > 0 {
            // Пересчитать смещение
            let offset = contentOffset.y * self.parallaxDeltaFactor
            // Установить значение y для центра scrollView c учетом смещения
            self.scrollView.center.y = self.visibleView.center.y + offset
        } else {
            // Установить значение y для origin visibleView равным смещению
            self.visibleView.frame.origin.y = contentOffset.y
            // Установить значение высоты visibleView с учетом смещения
            self.visibleView.frame.size.height = self.bounds.height - contentOffset.y
            // Установить значение y для центра scrollView c учетом смещения
            self.scrollView.center.y = self.visibleView.center.y - contentOffset.y
        }
    }
    
}
