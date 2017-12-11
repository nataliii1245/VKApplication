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
import SDWebImage

final class TodayViewController: UIViewController{
    
    // MARK: - Outlet
    
//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    // MARK: - Приватные свойства
    
    /// Массив новостей
    private var news: [SmallNewsfeedModel]?
    /// Массив групп - источников новостей
    private var groupsSource: [Group]?
    /// Массив пользователей - источников новостей
    private var profilesSource: [Friend]?
    
    ///
    private weak var activeRequest: Request?
    
}


// MARK: - UIViewController

extension TodayViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sourceLabel.text = "Загрузка"
        self.newsTextLabel.text = "..."
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


// MARK: - Приватные методы

private extension TodayViewController {
    
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
    
    func update() {
        guard let news = self.news, let groups = self.groupsSource, let profiles = self.profilesSource else { return }
        for item in news {
            guard !item.text.isEmpty else { continue }
            
            if item.source_id > 0 {
                for profile in profiles {
                    if item.source_id == profile.id {
                        self.sourceLabel.text = profile.name
                        break
                    }
                }
            } else {
                for group in groups {
                    let sourceId = abs(item.source_id)
                    if sourceId == group.id {
                        self.sourceLabel.text = group.name
                        break
                    }
                }
            }
            self.newsTextLabel.text = item.text
            if let photoUrlValue = item.photoUrl, let photoUrl = URL(string: photoUrlValue) {
                self.newsImage.sd_setImage(with: photoUrl, placeholderImage: nil)
            }
            
            break
        }
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
    
}


//// MARK: - TableView
//
//extension TodayViewController: UITableViewDataSource {
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return news.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Получаем ячейку из пула
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SmallNewsFeedTableViewCell", for: indexPath) as! SmallNewsFeedTableViewCell
//        
//        cell.configure(with: news[indexPath.row], profileSources: profilesSource, groupSources: groupsSource)
//        
//        return cell
//    }
//    
//}

