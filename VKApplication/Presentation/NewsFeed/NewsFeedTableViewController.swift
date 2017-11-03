//
//  NewsFeedTableViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import Alamofire

class NewsFeedTableViewController: UITableViewController  {
    
    // MARK: - Приватные свойства
    
    /// Активный запрос на получение новостей
    private var activeRequest: Request?
    
    private var news: [NewsFeedPost] = []
    private var groupsSource: [Group] = []
    private var profilesSource: [Friend] = []
    
}


// MARK: - UIViewController
    
extension NewsFeedTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        // Запрашиваем заново новости
        self.activeRequest?.cancel()
        self.activeRequest =  NewsFeedService.getNewsFeed({ news, groups, profiles in
            self.news = news
            self.groupsSource = groups
            self.profilesSource = profiles
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { error in
            guard error._code != NSURLErrorCancelled else { return }
            
            let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(alertController, animated: true)
            }
        }
        
    }
    
}

// MARK: - UITableViewDataSource

extension NewsFeedTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsItem = news[indexPath.row]
        
        // Получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableViewCell", for: indexPath) as! NewsFeedTableViewCell
        cell.dataSource = self
        cell.configure(for: newsItem)
        
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension NewsFeedTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: - NewsFeedTableViewCellDataSource

extension NewsFeedTableViewController: NewsFeedTableViewCellDataSource {
    
    func getGroupBy(id: Int) -> Group? {
        for group in groupsSource {
            if group.id == id {
                return group
            }
        }
        
        return nil
    }
    
    func getProfileBy(id: Int) -> Friend? {
        for profile in profilesSource {
            if profile.id == id {
                return profile
            }
        }
        
        return nil
    }
    
}
