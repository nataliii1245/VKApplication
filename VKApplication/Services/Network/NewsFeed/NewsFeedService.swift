//
//  NewsFeedService.swift
//  VKApplication
//
//  Created by Natalia Volkova on 24.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import WebKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper


class NewsFeedService {
    
    // Создание запроса на получение новостей
    
    class func getNewsFeed(_ completion: @escaping ([NewsFeedPost], [Group], [Friend], String?) -> Void, _ failure: @escaping (Error) -> Void) -> Request {
        let parameters: Parameters = [
            "filters" : "post",
            "count" : "100",
            "access_token" : "\(KeychainWrapper.standard.string(forKey: KeychainKey.token)!)",
            "v" : 5.68
        ]
        
//        print(KeychainWrapper.standard.string(forKey: KeychainKey.token)!)
        let request = sessionManager.request("https://api.vk.com/method/newsfeed.get", parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let newsFeedResponse = GetNewsFeedResponse(json: json) else { return }
                let news = newsFeedResponse.newsFeedPosts
                let groups = newsFeedResponse.groupsSource
                let profiles = newsFeedResponse.profilesSource
                let nextFrom = newsFeedResponse.nextFrom
                
                DispatchQueue.main.async {
                    completion(news, groups, profiles, nextFrom)
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
