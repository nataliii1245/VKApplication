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

final class WallService {
    
    // MARK: - Публичные методы
    
    /// Запрос на добавление новой записи на стену
    class func postNewPost(message: String, _ completion: @escaping (Int) -> Void, _ failure: @escaping (Error) -> Void) {
        let parameters: Parameters = [
            "access_token" : "\(KeychainWrapper.standard.string(forKey: KeychainKey.token)!)",
            "v" : "5.68",
            "message": message
        ]
        
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