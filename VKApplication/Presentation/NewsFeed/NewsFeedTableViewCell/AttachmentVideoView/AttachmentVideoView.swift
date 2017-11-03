//
//  AttachmentVideoView.swift
//  VKApplication
//
//  Created by Natalia Volkova on 29.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import SDWebImage

@IBDesignable
final class AttachmentVideoView: UIView {
    
    // MARK: - Outlet
    
    /// Изображение
    @IBOutlet private weak var imageView: UIImageView!
    /// Продолжительность видео
    @IBOutlet private weak var durationLabel: UILabel!
    
    @IBOutlet private weak var playIconImageView: UIImageView!
    
    
    // MARK: - Публичные свойства
    
    /// Размер изображения
    var imageSize: CGSize?
    /// URL изображения
    var imageUrl: URL? {
        willSet {
            imageView.sd_setImage(with: newValue, placeholderImage: nil) { [weak self] _, _, _, _ in
                guard self?.imageSize == nil else { return }
                
                // TODO: Сообщать ячейке что картинка загрузилась
            }
        }
    }
    
    /// Длительность
    @IBInspectable
    var duration: Int = 0 {
        willSet {
            durationLabel.text = "\(newValue)"
        }
    }
    
    
    // MARK: - Приватные свойства
    
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

extension AttachmentVideoView {
    
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
    
}


// MARK: - Action

private extension AttachmentVideoView {
    
    /// Нажата кнопка "Воспроизвести видео"
    @IBAction func playButtonTapped() {
        print("play video")
    }
    
}


// MARK: - UIView

extension AttachmentVideoView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playIconImageView.layer.cornerRadius = playIconImageView.bounds.width / 2
    }
    
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

private extension AttachmentVideoView {
    
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
        playIconImageView.clipsToBounds = true
    }
    
}
