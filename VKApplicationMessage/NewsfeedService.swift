//
//  NewsfeedService.swift
//  VKApplicationImessageExtension
//
//  Created by Natalia Volkova on 12.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import WebKit
import Alamofire
import SwiftyJSON

// Создание запроса на получение новостей
final class NewsfeedService {
    
    // MARK: - Публичные методы
    
    /// Получить новости пользователя
    class func getNewsFeed(token: String, _ completion: @escaping ([NewsModelWithLink], [Group], [Friend]) -> Void, _ failure: @escaping (Error) -> Void) -> Request {
        let parameters: Parameters = [
            "filters" : "post",
            "count" : "20",
            "access_token" : token,
            "v" : 5.68
        ]
        
        let request = sessionManager.request("https://api.vk.com/method/newsfeed.get", parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let neewsfeedResponse = GetNewsfeedResponse(json: json) else { return }
                let news = neewsfeedResponse.neewsfeedPosts
                let groups = neewsfeedResponse.groupsSource
                let profiles = neewsfeedResponse.profilesSource
                
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
