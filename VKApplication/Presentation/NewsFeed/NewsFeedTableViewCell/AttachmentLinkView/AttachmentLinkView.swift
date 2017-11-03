//
//  AttachmentLinkView.swift
//  VKApplication
//
//  Created by Natalia Volkova on 31.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import SDWebImage

@IBDesignable
final class AttachmentLinkView: UIView {
    
    // MARK: - Outlet
    
    ///
    @IBOutlet weak var titleLabel: UILabel!
    ///
    @IBOutlet weak var captionLabel: UILabel!
    ///
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: - Публичные свойства
    
    /// Размер изображения
    var imageSize: CGSize?
    /// URL фото
    @IBInspectable
    var photoUrl: URL? {
        willSet {
            imageView.isHidden = newValue == nil
            imageView.sd_setImage(with: newValue, placeholderImage: nil) { [weak self] _, _, _, _ in
                guard self?.imageSize == nil else { return }
                
                // TODO: Сообщать ячейке что картинка загрузилась
            }
        }
    }
    
    
    // MARK: - Приватные свойства
    
    /// Соотношение сторон
    private weak var imageViewAspectRatioLayoutConstraint: NSLayoutConstraint?
    
    
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


// MARK: - Публичные свойства

extension AttachmentLinkView {
    
    /// Изображение
    @IBInspectable
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    /// Название
    @IBInspectable
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    /// Подпись ссылки
    @IBInspectable
    var caption: String? {
        get {
            return captionLabel.text
        }
        set {
            captionLabel.isHidden = newValue == nil
            captionLabel.text = newValue
        }
    }
    
}


// MARK: - Action

private extension AttachmentLinkView {
    
}


// MARK: - UIView

extension AttachmentLinkView {
    
    override func updateConstraints() {
        super.updateConstraints()
        
        imageViewAspectRatioLayoutConstraint?.isActive = false
        imageViewAspectRatioLayoutConstraint = nil
        
        guard let originalSize = imageSize ?? image?.size else { return }
        let aspectRatio = originalSize.width / originalSize.height
        
        imageViewAspectRatioLayoutConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: aspectRatio)
        imageViewAspectRatioLayoutConstraint?.isActive = true
    }
    
}


// MARK: - Приватные методы

private extension AttachmentLinkView {
    
    /// Подготовка корневого view
    func setupRootView() {
        let view = fromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(view)
        view.layoutAttachAll(to: self)
    }
    
    /// Настройка
    func setup() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
