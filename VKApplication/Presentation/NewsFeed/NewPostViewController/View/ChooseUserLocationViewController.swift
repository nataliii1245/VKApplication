//
//  ChooseUserLocationViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 05.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import CoreLocation

final class ChooseUserLocationViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
        }
    }
    
    
    // MARK: - Приватные свойства
    
    /// Элементы
    private let items = [
        "Lonesome Duck",
        "Mombi",
        "Mr. Muffin",
        "Mrs. Yoop",
        "Munchkins",
        "Nimmie Amee",
        "Nome King",
        "Ojo the Lucky",
        "Patchwork Girl",
        "Phonograph",
        "Polychrome",
        "Pop Over",
        "Prince Karver",
        "Princess Langwidere",
        "Princess Ozma",
        "Prof. Woggle-Bug",
        "Queen Ann Soforth",
        "Sawhorse",
        "Scarecrow"
    ]
    
    /// Шапка таблицы
    private weak var tableHeaderView: ParallaxMapTableHeaderView!
    
    private var locationManager: LocationManager!
    
}


// MARK: - UIViewController

extension ChooseUserLocationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = LocationManager(delegate: self)
        self.locationManager.startUpdateLocation()
        
        // Установить высоту
        let tableHeaderViewHeight: CGFloat = 150
        let tableHeaderView = ParallaxMapTableHeaderView(size: CGSize(width: self.view.frame.width, height: tableHeaderViewHeight))
        self.tableView.tableHeaderView = tableHeaderView
        // Создать ссылку для удобного доступа
        self.tableHeaderView = tableHeaderView
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.locationManager.stopUpdatingLocation()
    }
    
}


// MARK: - Actions

private extension ChooseUserLocationViewController {
    
    /// Нажата кнопка отмены
    @IBAction func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - UIScrollViewDelegate

extension ChooseUserLocationViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(self.tableView.contentOffset)
        self.tableHeaderView.layoutForContentOffset(self.tableView.contentOffset)
    }
    
}


// MARK: - UITableViewDataSource

extension ChooseUserLocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = items[row]
        
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension ChooseUserLocationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: - LocationManagerDelegate

extension ChooseUserLocationViewController: LocationManagerDelegate {
    
    func locationManager(_ locationManager: LocationManager, didUpdate location: CLLocation) {
        self.tableHeaderView.userLocation = location
        locationManager.stopUpdatingLocation()
    }
    
}

