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
    
    /// Изображение
    @IBOutlet private weak var themeLabel: UILabel!
    ///
    @IBOutlet private weak var informationLabel: UILabel!
    
    @IBOutlet private weak var pollAnswersStackView: UIStackView!
    
    
    // MARK: - Публичные свойства
    
    var answers: [PollAnswerModel] = [] {
        willSet {
            for answer in answers {
                let answerView = AttachmentPollAnswerView(frame: .zero)
                pollAnswersStackView.addArrangedSubview(answerView)
                
                answerView.name = answer.text
                print(answer.rate)
//                answerView.percent = CGFloat(answer.rate) / 100
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
            themeLabel.text = theme
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
    }
    
}


