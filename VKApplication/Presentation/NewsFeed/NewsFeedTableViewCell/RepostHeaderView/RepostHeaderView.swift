//
//  RepostHeaderView.swift
//  VKApplication
//
//  Created by Natalia Volkova on 31.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import SDWebImage

@IBDesignable
final class RepostHeaderView: UIView {
    
    // MARK: - Outlet
    
    /// Изображение
    @IBOutlet private weak var photoImageView: UIImageView!
    ///
    @IBOutlet private weak var authorNameLabel: UILabel!
    ///
    @IBOutlet private weak var postDateLabel: UILabel!
    
    @IBOutlet private weak var repostTextLabel: UILabel!
    
    // MARK: - Публичные свойства
    
    /// URL изображения
    var photoUrl: URL? {
        willSet {
            photoImageView.sd_setImage(with: newValue, placeholderImage: nil, completed: nil)
        }
    }
    
    /// Дата поста, с которого сделан репост
    @IBInspectable
    var postDate: Int = 0 {
        willSet {
            let date = Date(timeIntervalSince1970: Double(newValue) as TimeInterval)
            postDateLabel.text = dateFormatter.string(from: date)
        }
    }
    
    
    // MARK: - Инициализация
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initPhase2()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initPhase2()
    }
    
    /// Инициализация объекта
    private func initPhase2() {
        setupRootView()
    }
    
}


// MARK: - Публичные свойства

extension RepostHeaderView {
    
    /// Изображение
    @IBInspectable
    var image: UIImage? {
        get {
            return photoImageView.image
        }
        set {
            photoImageView.image = newValue
        }
    }
    
    /// Название
    @IBInspectable
    var authorName: String? {
        get {
            return authorNameLabel.text
        }
        set {
            authorNameLabel.text = newValue
        }
    }
    
    /// Текст
    @IBInspectable
    var repostText: String? {
        get {
            return repostTextLabel.text
        }
        set {
            repostTextLabel.text = newValue
        }
    }
    
}


// MARK: - Приватные методы

private extension RepostHeaderView {
    
    /// Подготовка корневого view
    func setupRootView() {
        let view = fromNib()
        self.addSubview(view)
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutAttachAll(to: self)
        
        photoImageView.layer.cornerRadius = photoImageView.bounds.width / 2
        photoImageView.clipsToBounds = true
    }
    
}
