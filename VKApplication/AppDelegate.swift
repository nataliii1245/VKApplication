//
//  AppDelegate.swift
//  VKApplication
//
//  Created by Natalia Volkova on 14.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import SwiftyJSON
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        if #available(iOS 10.0, *) {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.requestAuthorization(options: [.badge]) { _, _ in }
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.badge], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
        
        return true
    }
    
}

final class Bug {

// MARK: - UIApplicationDelegate

extension AppDelegate {
    
    static var shared = Bug()
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let lastUpdate = BackgroundManager.instance.lastUpdate, abs(lastUpdate.timeIntervalSinceNow) < 30 {
            completionHandler(.noData)
            return
        }
        
        BackgroundManager.instance.timer = DispatchSource.makeTimerSource(queue: .main)
        BackgroundManager.instance.timer?.schedule(deadline: .now(), repeating: .seconds(29), leeway: .seconds(1))
        BackgroundManager.instance.timer?.setEventHandler {
            completionHandler(.failed)
            return
        }
        
        BackgroundManager.instance.timer?.resume()
        getUserFriendRequests()
        
        BackgroundManager.instance.fetchFriendRequestsGroup.notify(queue: .main) {
            BackgroundManager.instance.timer = nil
            BackgroundManager.instance.lastUpdate = Date()
            completionHandler(.newData)
        }
    }
    
    private init() { }
}


// MARK: - Приватные методы

private extension AppDelegate {
    
    func `catch`(_ json: JSON) {
        print("bug")
        print(json)
    /// Получить список идентификаторов пользователей, которые отправили заявку на добавление в друзья
    func getUserFriendRequests() {
        FriendsService.getRequests({ userIds in
            
            // Запрашиваем информацию о списке пользователей, которые отправили заявку на добавление в друзья
            self.getInformationAboutUsers(with: userIds)
        }) { error in
            print(error)
        }
    }
    
    /// Получить информацию о списке пользователей, которые отправили заявку на добавление в друзья
    func getInformationAboutUsers(with userIds: [Int]) {
        UsersService.getInformationAboutUsers(withIds: userIds, { friendRequests in
            
            // Меняем бейдж
            UIApplication.shared.applicationIconBadgeNumber = friendRequests.count
            
            // Сохраняем в бд
            DatabaseManager.saveFriendRequestUsers(friendRequests)
        }) { error in
            print(error)
        }
    }
    
}
