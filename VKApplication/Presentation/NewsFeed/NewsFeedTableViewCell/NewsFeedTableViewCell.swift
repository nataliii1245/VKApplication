//
//  NewsFeedTableViewCell.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

// TODO: - создать created_by

final class NewsFeedTableViewCell: UITableViewCell {
   
    // MARK: - Outlet
    
    /// Фото автора
    @IBOutlet weak var authorPhotoImageView: UIImageView!
    /// Имя автора
    @IBOutlet weak var authorNameLabel: UILabel!
    /// Дата
    @IBOutlet weak var dateLabel: UILabel!
    /// Текст поста
    @IBOutlet weak var postTextLabel: UILabel!
    
    /// Стек шапок репостов
    @IBOutlet weak var repostHeadersStackView: UIStackView!
    /// Стек фото/видео-вложений
    @IBOutlet weak var imagesStackView: UIStackView!
    /// Стек аудио-вложений
    @IBOutlet weak var audiosStackView: UIStackView!
    /// Стек ссылок-вложений
    @IBOutlet weak var linksStackView: UIStackView!
    /// Стек файлов-вложений
    @IBOutlet weak var docsStackView: UIStackView!
    /// Стек опросов-вложений
    @IBOutlet weak var pollStackView: UIStackView!
    
    /// Имя автор записи
    @IBOutlet weak var sourceAuthorLabel: UILabel!
    /// Аватар автора записи
    @IBOutlet weak var authorImage:UIImageView!
    
    /// Количество лайков
    @IBOutlet weak var likesCounterLabel: UILabel!
    /// Количество комментариев
    @IBOutlet weak var commentsCounterLabel: UILabel!
    /// Количество просмотров
    @IBOutlet weak var viewsCounterLabel: UILabel!
    /// Количество репостов
    @IBOutlet weak var repostCounterLabel: UILabel!
    
    
    // MARK: - Публичные свойства
    weak var dataSource: NewsFeedTableViewCellDataSource?
    weak var delegate: NewsFeedTableViewCellDelegate?
    
}


// MARK: - Публичные методы

extension NewsFeedTableViewCell {
    
    /// Настройка ячейки
    func configure(for newsItem: NewsFeedPost) {
        clean()
        
        configureAuthorInformation(for: newsItem)
        configureDatePostInformation(for: newsItem)
        configurePostInformation(for: newsItem)
        configureRepostBlock(for: newsItem)
        configureAttachments(for: newsItem)
        configurePostStatistics(for: newsItem)
        configureSigner_IdInformation(for: newsItem)
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
        authorImage.isHidden = true
    }

    /// Сконфигурировать информацию об авторе/сообществе, которое опубликовало запись
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
    
    /// Конфигурирование блока информации об исходной записи( для записей, являющихся репостом)
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
    
    /// Конфигурирование текста записи
    func configurePostInformation(for newsItem: NewsFeedPost) {
        postTextLabel.isHidden = newsItem.text.isEmpty
        postTextLabel.text = newsItem.text
    }

    // Конфигурирование подписи автора поста
    func configureSigner_IdInformation(for newsItem: NewsFeedPost) {
        sourceAuthorLabel.isHidden = newsItem.signer_id == nil
        authorImage.isHidden = newsItem.signer_id == nil
        if let signerId = newsItem.signer_id {
            if signerId < 0 {
                if let group = dataSource?.getGroupBy(id: -signerId) {
                    sourceAuthorLabel.text = group.name
                } else {
                    sourceAuthorLabel.isHidden = true
                    authorImage.isHidden = true
                }
            } else {
                if let user = dataSource?.getProfileBy(id: signerId) {
                    sourceAuthorLabel.text = user.name
                } else {
                    sourceAuthorLabel.isHidden = true
                    authorImage.isHidden = true
                }
            }
        }
    }
    
    /// Конфигурирование вложений
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
                
                attachmentDocView.size = String(docAttachment.size)
                attachmentDocView.nameAndExtension = docAttachment.title
                attachmentDocView.url = URL(string: docAttachment.url)
                attachmentDocView.extension = docAttachment.ext
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
                
                attachmentLinkView.delegate = self
                
                attachmentLinkView.url = URL(string: linkAttachment.url)
                attachmentLinkView.title = linkAttachment.title
                attachmentLinkView.caption = linkAttachment.caption
                
                if let width = linkAttachment.width, let height = linkAttachment.height {
                    let imageSize = CGSize(width: width, height: height)
                    attachmentLinkView.imageSize = imageSize
                }
                if let photoUrl = linkAttachment.photoUrl {
                    attachmentLinkView.photoUrl = URL(string: photoUrl)
                }
            }
        }
        imagesStackView.isHidden = imagesStackView.arrangedSubviews.isEmpty
        audiosStackView.isHidden = audiosStackView.arrangedSubviews.isEmpty
        linksStackView.isHidden = linksStackView.arrangedSubviews.isEmpty
        docsStackView.isHidden = docsStackView.arrangedSubviews.isEmpty
        pollStackView.isHidden = pollStackView.arrangedSubviews.isEmpty
    }
    
    /// Конфигурирование блока статистики записи
    func configurePostStatistics(for newsItem: NewsFeedPost) {
        likesCounterLabel.text = String(newsItem.likesCount ?? 0)
        commentsCounterLabel.text = String(newsItem.commentsCount ?? 0)
        repostCounterLabel.text = String(newsItem.repostsCount ?? 0)
        viewsCounterLabel.text = String(newsItem.views ?? 0)
    }
    
    /// Конфигурирование информации о дате поста
    func configureDatePostInformation(for newsItem: NewsFeedPost) {
        let date = Date(timeIntervalSince1970: Double(newsItem.date) as TimeInterval)
        dateLabel.text = DateTimeFormatter.completeDateShortMonthFormatter.string(from: date)
    }
    
}


// MARK: - AttachmentLinkViewDelegate

extension NewsFeedTableViewCell: AttachmentLinkViewDelegate {
    
    func attachmentLinkView(_ attachmentLinkView: AttachmentLinkView, didSelect url: URL?) {
        delegate?.newsFeedTableViewCell(self, willOpen: url)
    }
    
}
