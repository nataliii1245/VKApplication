//
//  SmallNewsfeedService.swift
//  VKApplicationWidget
//
//  Created by Natalia Volkova on 11.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import WebKit
import Alamofire
import SwiftyJSON

// Создание запроса на получение новостей
final class SmallNewsfeedService {
    
    // MARK: - Публичные методы
    
    /// Получить новости пользователя
    class func getNewsFeed(token: String, _ completion: @escaping ([SmallNewsfeedModel], [Group], [Friend]) -> Void, _ failure: @escaping (Error) -> Void) -> Request {
        let parameters: Parameters = [
            "filters" : "post",
            "count" : "5",
            "access_token" : token,
            "v" : 5.68
        ]
        
        let request = sessionManager.request("https://api.vk.com/method/newsfeed.get", parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let smallNewsfeedResponse = GetSmallNewsfeedResponse(json: json) else { return }
                let news = smallNewsfeedResponse.smallNewsfeedPosts
                let groups = smallNewsfeedResponse.groupsSource
                let profiles = smallNewsfeedResponse.profilesSource
                
                DispatchQueue.main.async {
                    completion(news, groups, profiles)
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
