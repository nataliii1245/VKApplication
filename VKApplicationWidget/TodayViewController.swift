//
//  TodayViewController.swift
//  VKApplicationWidget
//
//  Created by Natalia Volkova on 11.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire

final class TodayViewController: UIViewController{
    
    // MARK: - Outlet
    
    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
        }
    }
    
    
    // MARK: - Приватные свойства
    
    /// Массив новостей
    private var news: [SmallNewsfeedModel] = []
    /// Массив групп - источников новостей
    private var groupsSource: [Group] = []
    /// Массив пользователей - источников новостей
    private var profilesSource: [Friend] = []
    
    /// Активный запрос
    private weak var activeRequest: Request?
    
}


// MARK: - UIViewController

extension TodayViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getNewsFeed { [weak self] success in
            if success {
                self?.update()
            }
        }
    }
    
}


// MARK: - Action

private extension TodayViewController {
    
    /// Нажата кнопка "Обновить"
    @IBAction func refreshButtonTapped() {
        getNewsFeed { [weak self] success in
            if success {
                self?.update()
            }
        }
    }
    
}


// MARK: - Приватные методы

private extension TodayViewController {
    
    /// Получить новости
    func getNewsFeed(completionHandler completion: @escaping (_ success: Bool) -> Void) {
        let defaults = UserDefaults(suiteName: "group.VKApplication")
        guard let token = defaults?.string(forKey: "token") else {
            completion(false)
            return
        }
        
        self.activeRequest?.cancel()
        self.activeRequest = SmallNewsfeedService.getNewsFeed(token: token, { [weak self] news, groups, profiles in
            guard let `self` = self else { return }
            
            self.news = news
            self.groupsSource = groups
            self.profilesSource = profiles
            
            completion(true)
        }) { error in
            print(error)
            completion(false)
        }
    }
    
    /// Обновить данные
    func update() {
        self.tableView.reloadData()
    }
    
}


// MARK: - NCWidgetProviding

extension TodayViewController: NCWidgetProviding {
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        getNewsFeed { [weak self] success in
            if success {
                self?.update()
                completionHandler(.newData)
            } else {
                completionHandler(.failed)
            }
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            let height = min(maxSize.height, CGFloat(5 * 44 + 22))
            preferredContentSize = CGSize(width: maxSize.width, height: height)
        } else {
            preferredContentSize = maxSize
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
            self?.update()
        }
    }
    
}


// MARK: - UITableViewDataSource

extension TodayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(Int(view.bounds.height) / 44, self.news.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SmallNewsFeedTableViewCell", for: indexPath) as! SmallNewsFeedTableViewCell
        cell.dataSource = self
        cell.configure(with: news[indexPath.row])
        
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension TodayViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: - SmallNewsFeedTableViewCellDataSource

extension TodayViewController: SmallNewsFeedTableViewCellDataSource {
    
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
