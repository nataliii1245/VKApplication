//
//  NewsFeedTableViewCell.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {
   
    // MARK: - Outlet
    
    /// Фото автора
    @IBOutlet weak var authorPhotoImageView: UIImageView!
    /// Имя автора
    @IBOutlet weak var authorNameLabel: UILabel!
    /// Дата
    @IBOutlet weak var dateLabel: UILabel!
    
    /// Текст поста
    @IBOutlet weak var postTextLabel: UILabel!
    

    ///
    @IBOutlet weak var repostHeadersStackView: UIStackView!
    /// Стек фото/видео-вложений
    @IBOutlet weak var imagesStackView: UIStackView!
    /// Стек аудио-вложений
    @IBOutlet weak var audiosStackView: UIStackView!
    /// Стек ссылок-вложений
    @IBOutlet weak var linksStackView: UIStackView!
    @IBOutlet weak var docsStackView: UIStackView!
    @IBOutlet weak var pollStackView: UIStackView!
    
    /// Автор записи
    @IBOutlet weak var sourceAuthorLabel: UILabel!
    
    @IBOutlet weak var likesCounterLabel: UILabel!
    @IBOutlet weak var commentsCounterLabel: UILabel!
    @IBOutlet weak var viewsCounterLabel: UILabel!
    @IBOutlet weak var repostCounterLabel: UILabel!
    
    
    // MARK: - Публичные свойства
    
    weak var dataSource: NewsFeedTableViewCellDataSource?
    
}


// MARK: - Публичные методы

extension NewsFeedTableViewCell {
    
    /// Настройка
    func configure(for newsItem: NewsFeedPost) {
        clean()
        
        configureAuthorInformation(for: newsItem)
        configureDatePostInformation(for: newsItem)
        configurePostInformation(for: newsItem)
        configureRepostBlock(for: newsItem)
        configureAttachments(for: newsItem)
        configurePostStatistics(for: newsItem)
    }
    
}


// MARK: - Приватные методы

private extension NewsFeedTableViewCell {
    
    /// Очистка ячейки
    func clean() {
        repostHeadersStackView.clean()
        repostHeadersStackView.isHidden = true
        
        imagesStackView.clean()
        imagesStackView.isHidden = true
        
        audiosStackView.clean()
        audiosStackView.isHidden = true
        
        docsStackView.clean()
        docsStackView.isHidden = true
        
        linksStackView.clean()
        linksStackView.isHidden = true
        
        pollStackView.clean()
        pollStackView.isHidden = true
        
        sourceAuthorLabel.isHidden = true
    }

    func configureAuthorInformation(for newsItem: NewsFeedPost) {
        
        // Настройка ImageView
        authorPhotoImageView.layer.cornerRadius = authorPhotoImageView.bounds.width / 2
        authorPhotoImageView.clipsToBounds = true
        
        // Заполнение имени и фотографии источника записи
        if newsItem.source_id < 0 {
            if let group = dataSource?.getGroupBy(id: -newsItem.source_id) {
                authorNameLabel.text = group.name
                
                let imageUrl = URL(string: group.photo)
                authorPhotoImageView.sd_setImage(with: imageUrl, placeholderImage: nil)
            }
        } else {
            if let profile = dataSource?.getProfileBy(id: newsItem.source_id) {
                authorNameLabel.text = profile.name
                
                let imageUrl = URL(string: profile.photo)
                authorPhotoImageView.sd_setImage(with: imageUrl, placeholderImage: nil)
            }
        }
    }
    
    // Конфигурирование блока информации об исходной записи( для записей, являющихся репостом)
    func configureRepostBlock(for newsItem: NewsFeedPost) {
        if !newsItem.repostPosts.isEmpty {
            for repostItem in newsItem.repostPosts {
                let newsRepostHeaderView = RepostHeaderView(frame: .zero)
                repostHeadersStackView.addArrangedSubview(newsRepostHeaderView)

                if repostItem.owner_id < 0 {
                    if let group = dataSource?.getGroupBy(id: -repostItem.owner_id) {
                        newsRepostHeaderView.authorName = group.name
                        let imageUrl = URL(string: group.photo)
                        newsRepostHeaderView.photoUrl = imageUrl
                        newsRepostHeaderView.postDate = repostItem.date
                        newsRepostHeaderView.repostText = repostItem.text
                    }
                } else {
                    if let profile = dataSource?.getProfileBy(id: repostItem.owner_id) {
                        newsRepostHeaderView.authorName = profile.name
                        let imageUrl = URL(string: profile.photo)
                        newsRepostHeaderView.photoUrl = imageUrl
                        newsRepostHeaderView.postDate = repostItem.date
                        newsRepostHeaderView.repostText = repostItem.text
                    }
                }
                if !repostItem.attachments.isEmpty {
                    configureAttachments(for: repostItem)
            }
        }
        }
        
        repostHeadersStackView.isHidden = repostHeadersStackView.arrangedSubviews.isEmpty
    }
    
    // Конфигурирование блока контента самого поста
    func configurePostInformation(for newsItem: NewsFeedPost) {
        postTextLabel.isHidden = newsItem.text.isEmpty
        postTextLabel.text = newsItem.text
    }

    func configureAttachments(for newsItem: NewsFeedPost) {
        for attachment in newsItem.attachments {
            if let photoAttachment = attachment as? PhotoAttachment {
                let attachmentPhotoView = AttachmentPhotoView(frame: .zero)
                self.imagesStackView.addArrangedSubview(attachmentPhotoView)
                
                if let width = photoAttachment.width, let height = photoAttachment.height {
                    let imageSize = CGSize(width: width, height: height)
                    attachmentPhotoView.imageSize = imageSize
                }
                
                attachmentPhotoView.url = URL(string: photoAttachment.photoUrl)
            } else if let videoAttachment = attachment as? VideoAttachment {
                let attachmentVideoView = AttachmentVideoView(frame: .zero)
                self.imagesStackView.addArrangedSubview(attachmentVideoView)
            
                let imageSize = CGSize(width: videoAttachment.width, height: videoAttachment.height)
                attachmentVideoView.imageSize = imageSize
                
                attachmentVideoView.imageUrl = URL(string: videoAttachment.photoUrl)
            } else if let audioAttachment = attachment as? AudioAttachment {
                let attachmentAudioView = AttachmentAudioView(frame: .zero)
                self.audiosStackView.addArrangedSubview(attachmentAudioView)
                
                attachmentAudioView.author = audioAttachment.artist
                attachmentAudioView.title = audioAttachment.title
            } else if let docAttachment = attachment as? DocAttachment {
                let attachmentDocView = AttachmentDocView(frame: .zero)
                self.docsStackView.addArrangedSubview(attachmentDocView)
                
                attachmentDocView.nameAndExtension = docAttachment.title
                attachmentDocView.postDate = docAttachment.date
            } else if let pollAttachment = attachment as? PollAttachment {
                let attachmentPollView = AttachmentPollView(frame: .zero)
                self.pollStackView.addArrangedSubview(attachmentPollView)
                
                attachmentPollView.answers = pollAttachment.pollAnswerAttachments
                attachmentPollView.theme = pollAttachment.question
                attachmentPollView.info = "Общее количество голосов: (\(pollAttachment.votes))"
                
            } else if let linkAttachment = attachment as? LinkAttachment {
                let attachmentLinkView = AttachmentLinkView(frame: .zero)
                self.linksStackView.addArrangedSubview(attachmentLinkView)
                
                if let width = linkAttachment.width, let height = linkAttachment.height {
                    let imageSize = CGSize(width: width, height: height)
                    attachmentLinkView.imageSize = imageSize
                }
                if let photoUrl = linkAttachment.photoUrl {
                    attachmentLinkView.photoUrl = URL(string: photoUrl)
                }
                
                attachmentLinkView.title = linkAttachment.title
                attachmentLinkView.caption = linkAttachment.caption
            } else {
                continue
            }
        }
        
        imagesStackView.isHidden = imagesStackView.arrangedSubviews.isEmpty
        audiosStackView.isHidden = audiosStackView.arrangedSubviews.isEmpty
        linksStackView.isHidden = linksStackView.arrangedSubviews.isEmpty
        docsStackView.isHidden = docsStackView.arrangedSubviews.isEmpty
        pollStackView.isHidden = pollStackView.arrangedSubviews.isEmpty
    }
    
    // Конфигурирование блока статистики записи
    func configurePostStatistics(for newsItem: NewsFeedPost) {
        likesCounterLabel.text = String(newsItem.likesCount ?? 0)
        commentsCounterLabel.text = String(newsItem.commentsCount ?? 0)
        repostCounterLabel.text = String(newsItem.repostsCount ?? 0)
        viewsCounterLabel.text = String(newsItem.views ?? 0)
    }
    
    // Конфигурирование информации о дате поста
    func configureDatePostInformation(for newsItem: NewsFeedPost) {
        let date = Date(timeIntervalSince1970: Double(newsItem.date) as TimeInterval)
        dateLabel.text = dateFormatter.string(from: date)
    }
    
}

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "dd MMM yyyy в HH:mm"
    
    return dateFormatter
}()
