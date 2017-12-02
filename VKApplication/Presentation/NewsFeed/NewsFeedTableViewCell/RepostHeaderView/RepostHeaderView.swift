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
    
    /// Аватар источника репоста
    @IBOutlet private weak var photoImageView: UIImageView!
    /// Имя источника репоста
    @IBOutlet private weak var authorNameLabel: UILabel!
    /// Дата источника репоста
    @IBOutlet private weak var postDateLabel: UILabel!
    /// Текст источника репоста
    @IBOutlet private weak var repostTextLabel: UILabel!
    /// Иконка репоста
    @IBOutlet private weak var repostIconImageView: UIImageView!
    
    
    // MARK: - Публичные свойства
    
    /// URL изображения
    var photoUrl: URL? {
        willSet {
            photoImageView.sd_setImage(with: newValue, placeholderImage: nil, completed: nil)
        }
    }
    
    /// Дата поста с которого сделан репост
    @IBInspectable
    var postDate: Int = 0 {
        willSet {
            let date = Date(timeIntervalSince1970: Double(newValue) as TimeInterval)
            postDateLabel.text = DateTimeFormatter.completeDateShortMonthFormatter.string(from: date)
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
        setup()
    }

}


// MARK: - Вычисляемые свойства

extension RepostHeaderView {
    
    /// Аватар источника репоста
    @IBInspectable
    var image: UIImage? {
        get {
            return photoImageView.image
        }
        set {
            photoImageView.image = newValue
        }
    }
    
    /// Имя источника репоста
    @IBInspectable
    var authorName: String? {
        get {
            return authorNameLabel.text
        }
        set {
            authorNameLabel.text = newValue
        }
    }
    
    /// Текст репоста
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
    }
    
    /// Настройка отображения аватара источника репоста
    func setup() {
        photoImageView.layer.cornerRadius = photoImageView.bounds.width / 2
        photoImageView.clipsToBounds = true
        repostIconImageView.image = repostIconImageView.image?.mask(with: #colorLiteral(red: 0.5764705882, green: 0.6823529412, blue: 0.8, alpha: 1))
    }
    
}
