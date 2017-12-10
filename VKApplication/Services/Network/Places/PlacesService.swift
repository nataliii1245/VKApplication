//
//  PlacesService.swift
//  VKApplication
//
//  Created by Natalia Volkova on 06.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import CoreLocation

final class PlacesService {
    
    // MARK: - Публичные методы
    
    /// Запрос на поиск мест рядом с заданной координатой
    class func getPlacesNear(coordinate: CLLocation, radius: Int, q: String? = nil, _ completion: @escaping ([Place]) -> Void, _ failure: @escaping (Error) -> Void) {
        var parameters: Parameters = [
            "access_token" : "\(KeychainWrapper.standard.string(forKey: KeychainKey.token)!)",
            "v" : "5.69",
            "latitude": coordinate.coordinate.latitude,
            "longitude": coordinate.coordinate.longitude,
            "radius": radius
        ]
        
        if let q = q {
            parameters["q"] = q
        } 
        
        sessionManager.request("https://api.vk.com/method/places.search", parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
            switch response.result {
            case .success(let value):
                
                let getPlacesNearCoordinateResponse = GetPlacesNearCoordinateResponse(json: JSON(value))
                let getPlacesNearCoordinate = getPlacesNearCoordinateResponse?.places
                
                DispatchQueue.main.async {
                    completion(getPlacesNearCoordinate ?? [])
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }

}

