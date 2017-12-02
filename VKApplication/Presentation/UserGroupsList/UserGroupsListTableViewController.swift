//
//  UserGroupsListTableViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

final class UserGroupsListTableViewController: UITableViewController {
    
    // MARK: - Публичные свойства
    
    let groupsSearchController = UISearchController(searchResultsController: nil)
    /// Группы
    var groups: Results<Group>?
    /// Отфильтрованные группы
    var filteredGroups = [Group]()
    /// Активный запрос на получение групп
    var activeRequest: Request?
    /// Токен Realm
    var token: NotificationToken?
    
    
    // MARK: - Публичные свойства
    
    /// Есть ли текст в поисковой строке
    var isSearchBarEmpty: Bool {
        return groupsSearchController.searchBar.text?.isEmpty ?? true
    }
    /// Отфильтрованы ли данные
    var isFiltering: Bool {
        return groupsSearchController.isActive && !isSearchBarEmpty
    }
    
    
    // MARK: - Публичные методы
    
    /// Синхронизация между базой данных и таблицей
    func pairGroupListTableAndRealm() {
        // Загружаем группы
        groups = DatabaseManager.loadGroups()
        // Добавляем блок уведомлений
        token = groups?.observe { [weak self] changes in
            // Если можем создать экземпляр контроллера
            guard let `self` = self else { return }
            // Получаем ссылку на tableView
            guard let tableView = self.tableView else { return }
            // Смотрим изменения
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                if self.isFiltering {
                    self.filterContentForSearchText(self.groupsSearchController.searchBar.text!)
                    tableView.reloadData()
                } else {
                    tableView.beginUpdates()
                    
                    tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    
                    tableView.endUpdates()
                }
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    /// Фильтрация групп согласно поисковой строке
    func filterContentForSearchText(_ searchText: String) {
        // Defer - выполнится в любом случае
        defer { self.tableView.reloadData() }
        guard let groups = groups else {
            filteredGroups.removeAll()
            return
        }
        // Отфильтрованные группы
        filteredGroups = groups.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    /// Функция выхода из группы
    func leaveGroup(group: Group) {
        GroupService.leaveGroup(id: group.id, { isSuccess in
            let groupName = group.name

            // Удаляем группу из БД
            DatabaseManager.removeGroup(group)
            
            let alertController = UIAlertController(title: nil, message: "Вы успешно вышли из группы \(groupName)", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(alertController, animated: true)
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
    
    /// Настройка groupsSearchController
    func setup() {
        definesPresentationContext = true
        
        tableView.tableHeaderView = groupsSearchController.searchBar
        groupsSearchController.searchResultsUpdater = self
        groupsSearchController.dimsBackgroundDuringPresentation = false
    }
    
}

// MARK: - UIViewController

extension UserGroupsListTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настраиваем groupsSearchController
        setup()
        
        // Обращаемся к функции, связывающей БД и таблицу
        pairGroupListTableAndRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Запрашиваем заново друзей
        self.activeRequest?.cancel()
        self.activeRequest = GroupService.getUsersGroups({ groups in
            
            // Сохраняем в бд
            DatabaseManager.saveGroups(groups)
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
    
}

// MARK: - UITableViewDataSource

extension UserGroupsListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredGroups.count
        }
        return groups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserGroupsListTableViewCell", for: indexPath) as! UserGroupsListTableViewCell
        
        if isFiltering {
            let group = filteredGroups[indexPath.row]
            cell.configure(for: group)
        } else {
            guard let group = groups?[indexPath.row] else {
                cell.clean()
                return cell
            }
            
            cell.configure(for: group)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFiltering {
                let group = filteredGroups.remove(at: indexPath.row)
                
                // Удаляем группу из БД
                DatabaseManager.removeGroup(group)
                
                // Вызываем функцию, осуществляющую выход из группы
                leaveGroup(group: group)
            } else {
                guard let group = groups?[indexPath.row] else { return }
                
                DatabaseManager.removeGroup(group)
                leaveGroup(group: group)
            }
            
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

// MARK: - UISearchResultsUpdating

extension UserGroupsListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(groupsSearchController.searchBar.text!)
    }
    
}
