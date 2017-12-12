//
//  MessagesViewController.swift
//  VKApplicationMessage
//
//  Created by Natalia Volkova on 12.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import Messages
import Alamofire

class MessagesViewController: MSMessagesAppViewController {
    
    // MARK: - Outlet
   
    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.dataSource = self
            newValue.delegate = self
        }
    }
    
    
    // MARK: - Приватные свойства
    
    /// Массив новостей
    private var news: [NewsModelWithLink] = []
    /// Массив групп - источников новостей
    private var groupsSource: [Group] = []
    /// Массив пользователей - источников новостей
    private var profilesSource: [Friend] = []
    
    /// Прикрепленная новость
    private var attachedNews: NewsModelWithLink?
    
    /// Активный запрос
    private weak var activeRequest: Request?
    
}


// MARK: - UIViewControl

extension MessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNewsFeed { [weak self] success in
            if success {
                self?.update()
            }
        }
    }
    
}


// MARK: - MSMessagesAppViewController

extension MessagesViewController {
    
    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        
        if let message = conversation.selectedMessage {
            if let url = message.url {
                self.extensionContext?.open(url, completionHandler: { (success: Bool) in
                })
            }
        }
    }
    
}


// MARK: - Action

private extension MessagesViewController {
    
    @IBAction func sendMessageButtonTapped() {
        guard let news = attachedNews else { return }
        
        let layout = MSMessageTemplateLayout()
        layout.caption = "Пост на стене"
        if news.source_id > 0 {
            layout.subcaption = self.getProfileBy(id: news.source_id)?.name
        } else {
            layout.subcaption = self.getGroupBy(id: abs(news.source_id))?.name
        }
        
        let message = MSMessage()
        if let url = URL(string: news.postUrl) {
            message.url = url
        }
        message.summaryText = news.text.trimmingCharacters(in: .whitespacesAndNewlines)
        message.layout = layout
        
        activeConversation?.insert(message, completionHandler: nil)
    }
    
}


// MARK: - Приватные методы

private extension MessagesViewController {
    
    /// Получить новости
    func getNewsFeed(completionHandler completion: @escaping (_ success: Bool) -> Void) {
        let defaults = UserDefaults(suiteName: "group.VKApplication")
        guard let token = defaults?.string(forKey: "token") else {
            completion(false)
            tableView.isHidden = false
            return
        }
        
        self.activeRequest?.cancel()
        self.activeRequest = NewsfeedService.getNewsFeed(token: token, { [weak self] news, groups, profiles in
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


// MARK: - UITableViewDataSource

extension MessagesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Int(view.bounds.height) / 44 == 5 {
            return min(4, self.news.count)
        } else {
            return min(Int(view.bounds.height) / 44, self.news.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SmallNewsfeedForMessagesTableViewCell", for: indexPath) as! SmallNewsfeedForMessagesTableViewCell
        cell.dataSource = self
        cell.configure(with: news[indexPath.row])
        
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension MessagesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.attachedNews = news[indexPath.row]
    }
    
}


// MARK: - SmallNewsFeedTableViewCellDataSource

extension MessagesViewController: SmallNewsFeedTableViewCellDataSource {
    
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
