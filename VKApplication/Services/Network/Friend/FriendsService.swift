//
//  FriendService.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

final class FriendsService {
    
    // MARK: - Публичные методы
    
    /// Запрос на получение друзей пользователя
    class func getUserFriends(_ completion: @escaping ([Friend]) -> Void, _ failure: @escaping (Error) -> Void) -> Request {
        let parameters: Parameters = [
            "access_token" : "\(KeychainWrapper.standard.string(forKey: KeychainKey.token)!)",
            "v" : "5.68",
            "fields": "nickname,photo_200_orig",
            "order": "hints"
        ]
        
        let request = sessionManager.request("https://api.vk.com/method/friends.get", parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
            switch response.result {
            case .success(let value):
                let friendsResponse = GetUserFriendsResponse(json: JSON(value))
                let friends = friendsResponse?.friends
                
                DispatchQueue.main.async {
                    completion(friends ?? [])
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        return request
    }

    /// Запрос на получение заявок в друзья
    @discardableResult
    class func getRequests(_ completion: @escaping ([Int]) -> Void, _ failure: @escaping (Error) -> Void) -> Request{
        let parameters: Parameters = [
            "access_token" : "\(KeychainWrapper.standard.string(forKey: KeychainKey.token)!)",
            "sort" : "0",
            "v" : "5.68"
        ]
        
        let request = sessionManager.request("https://api.vk.com/method/friends.getRequests", parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
            switch response.result {
            case .success(let value):
                let userFriendRequestsArray = GetRequestsResponse(json: JSON(value))

                DispatchQueue.main.async {
                    completion(userFriendRequestsArray?.friendRequests ?? [])
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
