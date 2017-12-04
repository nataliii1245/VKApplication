//
//  NewPostViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 02.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    // MARK: - Outlet
    
    /// Констрейнт для привязки тулбара к нижней границе view
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    /// Поле ввода текста
    @IBOutlet private weak var textView: UITextView!
    /// Тулбар для выбора вложений/геопозиции
    @IBOutlet private weak var toolbar: UIToolbar!
    
    
    // MARK: - Публичные свойства
    
    weak var delegate: NewPostViewControllerDelegate?
    
}


// MARK: - Приватные свойства

private extension NewPostViewController {
    
    /// Введенный текст
    var inputText: String? {
        guard let inputText = textView.text else { return nil }
        return inputText.isEmptyOrWhitespace ? nil : inputText
    }
    
}


// MARK: - IBAction

extension NewPostViewController {
    
    /// Нажата кнопка готово
    @IBAction private func doneButtonTapped() {
        guard let inputText = self.inputText else { showErrorAboutEmtySourceField(); return }
        
        WallService.postNewPost(message: inputText, { _ in
            self.delegate?.newPostViewControllerDidPosted(self)
        }) { error in
            let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    /// Нажата кнопка отмены
    @IBAction private func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Приватные методы

private extension NewPostViewController {
    
    /// Отобразить ошибку о пустом поле ввода
    func showErrorAboutEmtySourceField() {
        let alertController = UIAlertController(title: "Ошибка", message: "Введите текст поста", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
