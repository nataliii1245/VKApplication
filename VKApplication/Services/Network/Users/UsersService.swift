//
//  UsersService.swift
//  VKApplication
//
//  Created by Natalia Volkova on 10.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

final class UsersService {
    
    // MARK: - Публичные методы
    
    /// Запрос на информации о пользователях
    @discardableResult
    class func getInformationAboutUsers(withIds userIds: [Int], _ completion: @escaping ([FriendRequestUser]) -> Void, _ failure: @escaping (Error) -> Void) -> Request {
        let parameters: Parameters = [
            "access_token" : "\(KeychainWrapper.standard.string(forKey: KeychainKey.token)!)",
            "user_ids" : userIds,
            "fields": "photo_200_orig",
            "v" : "5.68"
        ]
        
        let request = sessionManager.request("https://api.vk.com/method/users.get", parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
            switch response.result {
            case .success(let value):
                let informationAboutUsersWithIdsArrayResponse = GetInformationAboutUsersResponse(json: JSON(value))
                
                DispatchQueue.main.async {
                    completion(informationAboutUsersWithIdsArrayResponse?.users ?? [])
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        return request
    }
    
}
