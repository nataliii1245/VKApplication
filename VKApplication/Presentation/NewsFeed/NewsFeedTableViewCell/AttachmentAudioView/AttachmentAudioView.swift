//
//  AttachmentAudioView.swift
//  VKApplication
//
//  Created by Natalia Volkova on 29.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

@IBDesignable
final class AttachmentAudioView: UIView {
    
    // MARK: - Outlet
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    
    
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

extension AttachmentAudioView {
    
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
    
    /// Автор
    @IBInspectable
    var author: String? {
        get {
            return authorLabel.text
        }
        set {
            authorLabel.text = newValue
        }
    }
    
}


// MARK: - Action

private extension AttachmentAudioView {
    
    /// Нажата кнопка "Воспроизвести аудиозапись"
    @IBAction func playButtonTapped() {
        print("play audio")
    }
    
}


// MARK: - Приватные методы

private extension AttachmentAudioView {
    
    /// Подготовка корневого view
    func setupRootView() {
        let view = fromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(view)
        view.layoutAttachAll(to: self)
    }
    
}
