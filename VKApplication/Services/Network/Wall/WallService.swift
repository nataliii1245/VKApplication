//
//  WallService.swift
//  VKApplication
//
//  Created by Natalia Volkova on 02.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import CoreLocation

final class WallService {
    
    // MARK: - Публичные методы
    
    /// Запрос на добавление новой записи на стену
    class func post(message: String, coordinate: CLLocation? = nil, place: Place? = nil, _ completion: @escaping (Int) -> Void, _ failure: @escaping (Error) -> Void) {
        var parameters: Parameters = [
            "access_token" : "\(KeychainWrapper.standard.string(forKey: KeychainKey.token)!)",
            "v" : "5.68",
            "message": message
        ]
        
        if let coordinate = coordinate {
            parameters["lat"] = coordinate.coordinate.latitude
            parameters["long"] = coordinate.coordinate.longitude
        }
        
        if let place = place {
            parameters["place_id"] = place.id
        }
    
        sessionManager.request("https://api.vk.com/method/wall.post", parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
            switch response.result {
            case .success(let value):
                guard let newPostResponse = NewPostResponse(json: JSON(value)) else { return }
                
                DispatchQueue.main.async {
                    completion(newPostResponse.postId)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }
    
}
