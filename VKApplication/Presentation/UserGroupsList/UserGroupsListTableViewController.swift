//
//  UserGroupsListTableViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import RealmSwift

class UserGroupsListTableViewController: UITableViewController {

    let groupsSearchController = UISearchController(searchResultsController: nil)
    
    var groups: [Group] = []
    
    var filteredGroups = [Group]()
    
    var isFiltering: Bool {
        return groupsSearchController.isActive && !searchBarIsEmpty
    }
    
    var searchBarIsEmpty: Bool {
        return groupsSearchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredGroups = groups.filter({
            ( group : Group) -> Bool in
            return group.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func leaveGroup(group: Group) {
        GroupService.leaveGroup(id: group.id, { isSuccess in
            do {
                let groupName = group.name
                
                let realm = try Realm()
                try realm.write {
                    realm.delete(group)
                }
                
                let alertController = UIAlertController(title: nil, message: "Вы успешно вышли из группы \(groupName)", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
            } catch {
                print(error)
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
}

// MARK: - UIViewController

extension UserGroupsListTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupsSearchController.searchResultsUpdater = self as? UISearchResultsUpdating
        
        groupsSearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = groupsSearchController.searchBar
        
        GroupService.getUsersGroups({ groups in
            self.groups = groups
            
            DatabaseManager.removeGroups()
            DatabaseManager.saveGroups(groups)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        groups = DatabaseManager.loadGroups()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension UserGroupsListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredGroups.count
        }
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserGroupsListTableViewCell", for: indexPath) as! UserGroupsListTableViewCell
        let group: Group
        if isFiltering {
            group = filteredGroups[indexPath.row]
        } else {
            group = groups[indexPath.row]
        }
        // Получаем ячейку из пула
        cell.configure(for: group)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let group: Group
            if isFiltering {
                group = filteredGroups.remove(at: indexPath.row)
                if let index = groups.index(where: { $0.id == group.id }) {
                    groups.remove(at: index)
                }
            } else {
                group = groups.remove(at: indexPath.row)
            }
            leaveGroup(group: group)
            
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


