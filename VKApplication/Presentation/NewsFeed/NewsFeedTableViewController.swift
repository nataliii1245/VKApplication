//
//  NewsFeedTableViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import Alamofire

final class NewsFeedTableViewController: UITableViewController  {
    
    // MARK: - Приватные свойства
    
    /// Активный запрос на получение новостей
    private var activeRequest: Request?
    /// Массив новостей
    private var news: [NewsFeedPost] = []
    /// Массив груп - источников новостей
    private var groupsSource: [Group] = []
    /// Массив пользователей - источников новостей
    private var profilesSource: [Friend] = []
    /// Ключ для получения следующего блока новостей
    private var nextFrom: String? = nil
    
}


// MARK: - UIViewController
    
extension NewsFeedTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if let refreshControl = refreshControl, !refreshControl.isRefreshing {
            tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y - refreshControl.frame.height), animated: false)
            
            refreshControl.beginRefreshing()
            refreshControl.sendActions(for: .valueChanged)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showNewPost.rawValue {
            guard let navigationController = segue.destination as? UINavigationController,
                let newPostViewController = navigationController.viewControllers.first as? NewPostViewController
                else { return }
            newPostViewController.delegate = self
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
        cell.delegate = self
        
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


// MARK: - Приватные методы

private extension NewsFeedTableViewController {
    
    func loadData() {
        self.activeRequest?.cancel()
        self.activeRequest = NewsFeedService.getNewsFeed({ news, groups, profiles, nextFrom in
            self.news = news
            self.groupsSource = groups
            self.profilesSource = profiles
            self.nextFrom = nextFrom
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }) { error in
            guard error._code != NSURLErrorCancelled else { return }
            
            let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            self.refreshControl?.endRefreshing()
            self.present(alertController, animated: true)
            }
    }
    
    @objc func refreshData() {
        loadData()
    }
    
}


// MARK: - NewsFeedTableViewCellDataSource

extension NewsFeedTableViewController: NewsFeedTableViewCellDataSource {
    
    /// Получить информацию о группе по идентификатору
    func getGroupBy(id: Int) -> Group? {
        for group in groupsSource {
            if group.id == id {
                return group
            }
        }
        
        return nil
    }
    
    /// Получить информацию о пользователе по идентификатору
    func getProfileBy(id: Int) -> Friend? {
        for profile in profilesSource {
            if profile.id == id {
                return profile
            }
        }
        
        return nil
    }
    
}


// MARK: - NewsFeedTableViewCellDelegate

extension NewsFeedTableViewController: NewsFeedTableViewCellDelegate {

    /// Открыть ссылку в браузере
    func newsFeedTableViewCell(_ newsFeedTableViewCell: NewsFeedTableViewCell, willOpen url: URL?) {
        guard let siteUrl = url, UIApplication.shared.canOpenURL(siteUrl) else {
            let alertController = UIAlertController(title: "Ошибка", message: "Невозможно открыть сайт.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)

            present(alertController, animated: true)
            return
        }
        
        UIApplication.shared.open(siteUrl, options: [:], completionHandler: nil)
    }
    
}


// MARK: - NewPostViewControllerDelegate

extension NewsFeedTableViewController: NewPostViewControllerDelegate {
    
    func newPostViewControllerDidPosted(_ newPostViewController: NewPostViewController) {
        dismiss(animated: true) {
            let alertController = UIAlertController(title: nil, message: "Запись опубликована на стене!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
}
