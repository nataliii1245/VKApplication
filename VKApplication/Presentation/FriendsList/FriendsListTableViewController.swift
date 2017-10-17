//
//  FriendsListTableViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

class FriendsListTableViewController: UITableViewController {

    /// Друзья
    private var friends: [Friend] = []
    
}

// MARK: - UIViewController

extension FriendsListTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Загружаем список друзей из БД
        friends = DatabaseManager.loadFriends()
        
        // Запрашиваем заново друзей
        FriendsService.getUserFriends({ friends in
            self.friends = friends
            
            // Сохраняем в бд
            DatabaseManager.removeFriends()
            DatabaseManager.saveFriends(friends)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { error in
            let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            DispatchQueue.main.async {
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
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListTableViewCell", for: indexPath) as! FriendListTableViewCell
        cell.configure(for: friend)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension FriendsListTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let friend = friends[indexPath.row]
        
        // Переход на экран коллекции фотографий пользователя
        performSegue(withIdentifier: SegueIdentifier.showFriendPhotos, sender: friend)
    }
    
    // Удаление друга из списка
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Если была нажата кнопка удалить
        if editingStyle == .delete {
            friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

