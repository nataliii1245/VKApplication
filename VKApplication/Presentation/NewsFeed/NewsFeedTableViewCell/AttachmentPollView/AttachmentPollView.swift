//
//  AttachmentPollView.swift
//  VKApplication
//
//  Created by Natalia Volkova on 03.11.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import SDWebImage

@IBDesignable
final class AttachmentPollView: UIView {
    
    // MARK: - Outlet
    
    /// Тема опроса
    @IBOutlet private weak var themeLabel: UILabel!
    /// Информация об опросе
    @IBOutlet private weak var informationLabel: UILabel!
    /// Стек ответов на опрос
    @IBOutlet private weak var pollAnswersStackView: UIStackView!
    
    
    // MARK: - Публичные свойства
    
    /// Массив ответов на опрос
    var answers: [PollAnswerModel] = [] {
        didSet {
            for answer in answers {
                let answerView = AttachmentPollAnswerView(frame: .zero)
                pollAnswersStackView.addArrangedSubview(answerView)
                
                answerView.name = "\(answer.text) (\(answer.votes))"
                answerView.percent = CGFloat(answer.rate / 100)
            }
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


// MARK: - Публичные свойства

extension AttachmentPollView {
    
    /// Изображение
    @IBInspectable
    var theme: String? {
        get {
            return themeLabel.text
        }
        set {
            themeLabel.text = newValue
        }
    }
    
    /// Название
    @IBInspectable
    var info: String? {
        get {
            return informationLabel.text
        }
        set {
            informationLabel.text = newValue
        }
    }
    
}


// MARK: - Приватные методы

private extension AttachmentPollView {
    
    /// Подготовка корневого view
    func setupRootView() {
        let view = fromNib()
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutAttachAll(to: self)
    }
    
    /// Настройка отображения блока опроса
    func setup() {
        layer.borderColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
    
}
