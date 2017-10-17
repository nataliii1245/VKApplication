//
//  SearchGroupsListTableViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class SearchGroupsListTableViewController: UITableViewController {

    var activeRequest: Request?
    
    let groupsSearchController = UISearchController(searchResultsController: nil)
    
    var groups: [Group] = []

    func filterContentForSearchText(_ searchText: String) {
        activeRequest?.cancel()
        
        activeRequest = GroupService.searchGroups(keyWords: searchText, { groups in
            self.activeRequest = nil
            
            self.groups = groups
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { error in
            guard error._code != NSURLErrorCancelled else { return }
            
            self.activeRequest = nil
            
            let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(alertController, animated: true)
            }
        }
    }
    
    func joinGroup(_ group: Group) {
        GroupService.joinGroup(id: group.id, { isSuccess in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(group)
                }
                
                let alertController = UIAlertController(title: nil, message: "Группа \(group.name) успешно добавлена!", preferredStyle: .alert)
                
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

extension SearchGroupsListTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupsSearchController.searchResultsUpdater = self as? UISearchResultsUpdating
        
        groupsSearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = groupsSearchController.searchBar
    }
}

// MARK: - UITableViewDataSource

extension SearchGroupsListTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groups[indexPath.row]
        
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGroupsListTableViewCell", for: indexPath) as! SearchGroupsListTableViewCell
        cell.configure(for: group)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SearchGroupsListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let group = groups[indexPath.row]
        joinGroup(group)
    }
    
}

// MARK: - UISearchResultsUpdating

extension SearchGroupsListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(groupsSearchController.searchBar.text!)
    }

}

