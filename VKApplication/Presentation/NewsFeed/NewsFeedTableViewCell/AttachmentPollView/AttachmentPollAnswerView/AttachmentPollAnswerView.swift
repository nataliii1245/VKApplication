//
//  AttachmentPollAnswerView.swift
//  VKApplication
//
//  Created by Natalia Volkova on 03.11.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import SDWebImage

@IBDesignable
final class AttachmentPollAnswerView: UIView {
    
    // MARK: - Outlet
    
    /// Подкрашенный блок
    @IBOutlet private weak var coloredView: UIView!
    /// Наименование ответа
    @IBOutlet private weak var nameLabel: UILabel!
    /// Констрейнты подкрашенного блока
    @IBOutlet private weak var coloredViewEqualWidthLayoutConstraint: NSLayoutConstraint!
    /// Фоновый блок
    @IBOutlet private weak var backgroundView: UIView!
    
    
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

extension AttachmentPollAnswerView {
    
    /// Изображение
    @IBInspectable
    var percent: CGFloat {
        get {
            return coloredViewEqualWidthLayoutConstraint.multiplier
        }
        set {
            coloredViewEqualWidthLayoutConstraint.isActive = false
            
            coloredViewEqualWidthLayoutConstraint = coloredView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: newValue)
            coloredViewEqualWidthLayoutConstraint.isActive = true
        }
    }
    
    /// Название
    @IBInspectable
    var name: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }
    
}


// MARK: - Приватные методы

private extension AttachmentPollAnswerView {
    
    /// Подготовка корневого view
    func setupRootView() {
        let view = fromNib()
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutAttachAll(to: self)
    }
    
    /// Настройка отображения блока конкретного ответа
    func setup() {
        backgroundView.layer.cornerRadius = backgroundView.frame.height / 10
        backgroundView.layer.masksToBounds = true
        
        coloredView.layer.cornerRadius = coloredView.frame.height / 10
        coloredView.layer.masksToBounds = true
    }
    
}
