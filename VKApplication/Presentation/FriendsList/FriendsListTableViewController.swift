//
//  FriendsListTableViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

final class FriendsListTableViewController: UITableViewController {

    // MARK: - Приватные свойства
    
    /// Друзья
    private var friends: Results<Friend>?
    
    
    // MARK: - Публичные свойства
    
    /// Активный запрос на получение друзей
    var activeRequest: Request?
    /// Токен Realm
    var token: NotificationToken?
    
    
    // MARK: - Публичные методы
    
    func pairFriendListTableAndRealm() {
        friends = DatabaseManager.loadFriends()
        token = friends?.observe { [weak self] changes in
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
    
}


// MARK: - UIViewController

extension FriendsListTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairFriendListTableAndRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Запрашиваем заново друзей
        self.activeRequest?.cancel()
        self.activeRequest = FriendsService.getUserFriends({ friends in
            
            // Сохраняем в бд
            DatabaseManager.saveFriends(friends)
        }) { error in
            guard error._code != NSURLErrorCancelled else { return }
            
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true)
            }
        }
    }
    
    // Передача объекта типа Friend на экран коллекции фотографий пользователя
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! PhotoCollectionViewController
        let friend = sender as! Friend
        
        viewController.friend = friend
    }
    
}

// MARK: - UITableViewDataSource

extension FriendsListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListTableViewCell", for: indexPath) as! FriendListTableViewCell
        
        guard let friend = friends?[indexPath.row] else {
            cell.clean()
            return cell
        }
        cell.configure(for: friend)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension FriendsListTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let friend = friends?[indexPath.row] else { return }
        
        // Переход на экран коллекции фотографий пользователя
        performSegue(withIdentifier: SegueIdentifier.showFriendPhotos, sender: friend)
    }
    
    // Удаление друга из списка
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let friend = friends?[indexPath.row] else { return }
        
        if editingStyle == .delete {
            // TODO: - Отправлять запрос
            DatabaseManager.removeFriend(friend)
        }
    }
    
}
