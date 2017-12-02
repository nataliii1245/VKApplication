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
    
    /// Изображение для ссылки
    @IBOutlet private weak var imageView: UIImageView!
    /// Название страницы
    @IBOutlet private weak var titleLabel: UILabel!
    /// Название ресурса
    @IBOutlet private weak var captionLabel: UILabel!
    
    
    // MARK: - Публичные свойства
    
    weak var delegate: AttachmentLinkViewDelegate?
    /// Размер изображения
    var imageSize: CGSize?
    /// URL сайта
    var url: URL?
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
            let caption = newValue ?? url?.host
            captionLabel.isHidden = caption == nil
            captionLabel.text = caption
        }
    }
    
}


// MARK: - Action

private extension AttachmentLinkView {
    
    /// Переход по ссылке
    @IBAction func openLink() {
        delegate?.attachmentLinkView(self, didSelect: url)
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
