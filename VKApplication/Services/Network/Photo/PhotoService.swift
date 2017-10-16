//
//  PhotoService.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class PhotoService {
    class func getUserPhotos(ownerID: Int, _ completion: @escaping ([Photo]) -> Void, _ failure: @escaping (Error) -> Void) {
        let parameters: Parameters = [
            "owner_id": ownerID,
            "extended" : "0",
            "count" : "200",
            "no_service_albums" : "1",
            "access_token" : "\(KeychainWrapper.standard.string(forKey: KeychainKey.token)!)",
            "v" : "5.68"
        ]
        
        sessionManager.request("https://api.vk.com/method/photos.getAll", parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let photosResponse = GetUserPhotosResponse(json: JSON(value))
                let photos = photosResponse?.photos
                completion(photos!)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
}

