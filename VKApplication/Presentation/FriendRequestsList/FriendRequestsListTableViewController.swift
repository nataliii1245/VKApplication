//
//  FriendRequestsListTableViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 10.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class FriendRequestsListTableViewController: UITableViewController {

    // MARK: - Приватные свойства
    
    /// Заявки
    private var friendRequests: Results<FriendRequestUser>?
    
    
    // MARK: - Публичные свойства
    
    /// Активный запрос на получение заявок
    var activeRequest: Request?
    /// Токен Realm
    var token: NotificationToken?
    
}


// MARK: - UIViewController

extension FriendRequestsListTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairFriendRequestsListTableAndRealm()
        getUserFriendRequests()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.token?.invalidate()
        self.activeRequest?.cancel()
    }
    
}


// MARK: - Приватные методы

private extension FriendRequestsListTableViewController {
    
    /// Связать таблицу и БД
    func pairFriendRequestsListTableAndRealm() {
        friendRequests = DatabaseManager.loadFriendRequestUsers()
        token = friendRequests?.observe { [weak self] changes in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                
                tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    /// Обработать ошибки
    func errorProcessing(_ error: Error) {
        guard error._code != NSURLErrorCancelled else { return }
        
        let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    /// Получить список идентификаторов пользователей, которые отправили заявку на добавление в друзья
    func getUserFriendRequests() {
        self.activeRequest = FriendsService.getRequests({ [weak self] userIds in
            
            // Запрашиваем информацию о списке пользователей, которые отправили заявку на добавление в друзья
            self?.getInformationAboutUsers(with: userIds)
        }) { [weak self] error in
            self?.errorProcessing(error)
        }
    }
    
    /// Получить информацию о списке пользователей, которые отправили заявку на добавление в друзья
    func getInformationAboutUsers(with userIds: [Int]) {
        self.activeRequest = UsersService.getInformationAboutUsers(withIds: userIds, { friendRequests in
            
            // Меняем бейдж
            UIApplication.shared.applicationIconBadgeNumber = friendRequests.count
            
            // Сохраняем в бд
            DatabaseManager.saveFriendRequestUsers(friendRequests)
        }) { [weak self] error in
            self?.errorProcessing(error)
        }
    }
    
}


// MARK: - UITableViewDataSource

extension FriendRequestsListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequests?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestsListTableViewCell", for: indexPath) as! FriendRequestsListTableViewCell
        
        if let friendRequest = friendRequests?[indexPath.row] {
            cell.configure(for: friendRequest)
        } else {
            cell.clean()
        }
        
        return cell
    }
    
}
