//
//  AppDelegate.swift
//  VKApplication
//
//  Created by Natalia Volkova on 14.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
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


// MARK: - UIApplicationDelegate

extension AppDelegate {
    
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
        getUserFriendRequests() {
            BackgroundManager.instance.timer = nil
            BackgroundManager.instance.lastUpdate = Date()
            completionHandler(.newData)
        }
    }
    
}


// MARK: - Приватные методы

private extension AppDelegate {
    
    /// Получить список идентификаторов пользователей, которые отправили заявку на добавление в друзья
    func getUserFriendRequests(completionHandler completion: @escaping () -> Void) {
        FriendsService.getRequests({ userIds in
            
            // Запрашиваем информацию о списке пользователей, которые отправили заявку на добавление в друзья
            self.getInformationAboutUsers(with: userIds, completion: completion)
        }) { error in
            print(error)
        }
    }
    
    /// Получить информацию о списке пользователей, которые отправили заявку на добавление в друзья
    func getInformationAboutUsers(with userIds: [Int], completion: @escaping () -> Void) {
        UsersService.getInformationAboutUsers(withIds: userIds, { friendRequests in
            
            // Меняем бейдж
            UIApplication.shared.applicationIconBadgeNumber = friendRequests.count
            
            // Сохраняем в бд
            DatabaseManager.saveFriendRequestUsers(friendRequests)
            // Уведомляем об окончании загрузки
            completion()
        }) { error in
            print(error)
        }
    }
    
}
