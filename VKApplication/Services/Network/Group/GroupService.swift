//
//  GroupService.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class GroupService {
    
    /// Запрос на получение груп пользователя
    class func getUsersGroups(_ completion: @escaping ([Group]) -> Void, _ failure: @escaping (Error) -> Void) -> Request {
        let parameters: Parameters = [
            "v" : "5.68",
            "access_token" : "\(KeychainWrapper.standard.string(forKey: "token")!)",
            "extended" : "1"
        ]
        
        let request = sessionManager.request("https://api.vk.com/method/groups.get", parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
            switch response.result {
            case .success(let value):
                let groupsResponse = GetUserGroupsResponse(json: JSON(value))
                let groups = groupsResponse?.groups
                
                DispatchQueue.main.async {
                    completion(groups ?? [])
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
        
        return request
    }
    
    /// Запрос на поиск группы по ключевому слову
    class func searchGroups(keyWords: String, _ completion: @escaping ([Group]) -> Void, _ failure: @escaping (Error) -> Void) -> Request? {
        
        if !keyWords.isEmpty {
            let parameters: Parameters = [
                "q" : "\(keyWords)",
                "v" : "5.68",
                "access_token" : "\(KeychainWrapper.standard.string(forKey: "token")!)"
            ]
            
            let request = sessionManager.request("https://api.vk.com/method/groups.search", parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
                switch response.result {
                case .success(let value):
                    let groupsResponse = SearchGroupsResponse(json: JSON(value))
                    let groups = groupsResponse?.groups
                    
                    DispatchQueue.main.async {
                        completion(groups ?? [])
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
            }
            return request
        } else {
            return(nil)
        }
    }
    
    /// Запрос на вступление в группу
    class func joinGroup(id: Int, _ completion: @escaping (Bool) -> Void, _ failure: @escaping (Error) -> Void) {
        
        let parameters: Parameters = [
            "group_id" : "\(id)",
            "v" : "5.68",
            "access_token" : "\(KeychainWrapper.standard.string(forKey: "token")!)"
        ]
        
        sessionManager.request("https://api.vk.com/method/groups.join", parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
            switch response.result {
            case .success(let value):
                let joinGroupsResponse = JoinGroupResponse(json: JSON(value))
                
                DispatchQueue.main.async {
                    completion((joinGroupsResponse != nil))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }
    
    /// Запрос на выход из группы
    class func leaveGroup(id: Int, _ completion: @escaping (Bool) -> Void, _ failure: @escaping (Error) -> Void) {
        
        let parameters: Parameters = [
            "group_id" : "\(id)",
            "v" : "5.68",
            "access_token" : "\(KeychainWrapper.standard.string(forKey: "token")!)"
        ]
        
        sessionManager.request("https://api.vk.com/method/groups.leave", parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
            switch response.result {
            case .success(let value):
                let leaveGroupsResponse = LeaveGroupResponse(json: JSON(value))
                
                DispatchQueue.main.async {
                    completion((leaveGroupsResponse != nil))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }
    
}

