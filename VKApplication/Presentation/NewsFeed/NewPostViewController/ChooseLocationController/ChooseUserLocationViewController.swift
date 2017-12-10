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
    
    // MARK: - Публичные свойства
    
    /// Массив мест поблизости
    var placesNear: [Place] = []
    weak var delegate: ChooseUserLocationTableViewControllerDelegate?
    
    
    // MARK: - Outlet
    
    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
        }
    }
    
    
    // MARK: - Приватные свойства
    
    /// Шапка таблицы
    private weak var tableHeaderView: MapTableHeaderView!
    
    private var locationManager: LocationManager!
    
    private var currentLocation: CLLocation?
    
}


// MARK: - UIViewController

extension ChooseUserLocationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = LocationManager(delegate: self)
        self.locationManager.startUpdateLocation()
        
        // Установить высоту
        let tableHeaderViewHeight: CGFloat = 150
        let tableHeaderView = MapTableHeaderView(size: CGSize(width: self.view.frame.width, height: tableHeaderViewHeight))
        self.tableView.tableHeaderView = tableHeaderView
        // Создать ссылку для удобного доступа
        self.tableHeaderView = tableHeaderView
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.locationManager.stopUpdatingLocation()
    }
    
}


// MARK: - Приватные методы

private extension ChooseUserLocationViewController {
    
    func getPlacesNearCoordinate() {
        PlacesService.getPlacesNear(coordinate: (tableHeaderView?.userLocation)!, radius: 4, { [weak self] places in
            guard let `self` = self else { return }
            
            self.placesNear = places
            
            self.tableView.reloadData()
        }) { [ weak self] error in
            guard let `self` = self else { return }
            
            let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            self.tableView.reloadData()
            self.present(alertController, animated: true)
        }
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
        self.tableHeaderView.layoutForContentOffset(self.tableView.contentOffset)
    }
    
}


// MARK: - UITableViewDataSource

extension ChooseUserLocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesNear.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentLocationCell", for: indexPath) as UITableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearestPlaceCell", for: indexPath) as! ChooseUserLocationTableViewCell
            cell.configure(for: placesNear[indexPath.row - 1 ])
            
            return cell
        }
    }
    
}


// MARK: - UITableViewDelegate

extension ChooseUserLocationViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            guard let currentLocation = self.currentLocation else {
                let alertController = UIAlertController(title: "Ошибка", message: "Не удалось определить текущее местоположение", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                present(alertController, animated: true, completion: nil)
                return
            }
            
            delegate?.chooseUserLocationTableViewController(self, location: currentLocation)
        } else {
            delegate?.chooseUserLocationTableViewController(self, place: placesNear[indexPath.row - 1])
        }
    }

}


// MARK: - LocationManagerDelegate

extension ChooseUserLocationViewController: LocationManagerDelegate {
    
    func locationManager(_ locationManager: LocationManager, didUpdate location: CLLocation) {
        locationManager.stopUpdatingLocation()
        
        self.tableHeaderView.userLocation = location
        self.currentLocation = location
        
        getPlacesNearCoordinate()
    }
    
}
