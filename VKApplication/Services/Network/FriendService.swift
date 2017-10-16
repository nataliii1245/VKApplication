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

class FriendService {
    class func getFriends(_ completion: @escaping ([Friend]) -> Void, _ failure: @escaping (Error) -> Void) {
        let parameters: Parameters = [
            "access_token" : "\(KeychainWrapper.standard.string(forKey: KeychainKey.token)!)",
            "v" : "5.68",
            "fields": "nickname,photo_200_orig",
            "order": "hints"
        ]
        
        sessionManager.request("https://api.vk.com/method/friends.get", parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                var friends: [Friend] = []
                if let items = json["response"]["items"].array {
                    //friends = items.flatMap { Friend(json: $0) }
                    for item in items {
                        if let friend = Friend(json: item) {
                            friends.append(friend)
                        }
                    }
                }
                completion(friends)
            case .failure(let error):
                failure(error)
            }
        }
    }

}

