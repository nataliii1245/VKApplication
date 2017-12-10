//
//  NewPostViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 02.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import CoreLocation

class NewPostViewController: UIViewController {

    // MARK: - Outlet
    
    /// Констрейнт для привязки тулбара к нижней границе view
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    /// Поле ввода текста
    @IBOutlet private weak var textView: UITextView! {
        willSet {
            newValue.delegate = self
        }
    }
    /// Тулбар для выбора вложений/геопозиции
    @IBOutlet private weak var toolbar: UIToolbar!
    
    
    // MARK: - Публичные свойства
    
    weak var delegate: NewPostViewControllerDelegate?
    
    
    // MARK: - Приватные свойства
    
    /// Жест скрытия клавиатуры
    private weak var hideKeyboardGesture: UIGestureRecognizer?
    
    /// Текущее местоположение
    private var currentLocation: CLLocation?
    /// Место
    private var place: Place?
    
}


// MARK: - Приватные свойства

private extension NewPostViewController {
    
    /// Введенный текст
    var inputText: String? {
        guard let inputText = textView.text else { return nil }
        return inputText.isEmptyOrWhitespace ? nil : inputText
    }
    
}


// MARK - UIViewController

extension NewPostViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Подписываемся на уведомление, которое приходит при появляении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        // Подписываемся на уведомление, которое приходит при исчезновении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Отписываемся от уведомления, которое приходит при появляении клавиатуры
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        // Отписываемся от уведомления, которое приходит при исчезновении клавиатуры
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showChooseUserLocation.rawValue {
            guard let navigationController = segue.destination as? UINavigationController,
                let chooseUserLocationController = navigationController.viewControllers.first as? ChooseUserLocationViewController
                else { return }
            chooseUserLocationController.delegate = self
        }
    }
    
}


// MARK: - IBAction

private extension NewPostViewController {
    
    /// Нажата кнопка готово
    @IBAction func doneButtonTapped() {
        self.textView.resignFirstResponder()
        guard let inputText = self.inputText else { showErrorAboutEmtySourceField(); return }
        
        WallService.post(message: inputText, coordinate: self.currentLocation, place: self.place, { _ in
            self.delegate?.newPostViewControllerDidPosted(self)
        }) { error in
            let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    /// Нажата кнопка отмены
    @IBAction func cancelButtonTapped() {
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
    
    /// Когда клавиатура появилась
    @objc private func keyboardWasShown(notification: Notification) {
        // Получем размер клавиатуры
        guard let info = notification.userInfo as NSDictionary?, let keyboardSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue)?.cgRectValue.size else { return }
        self.bottomConstraint.constant = keyboardSize.height
        
        if let duration = (info.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as? NSNumber)?.doubleValue, let curve = (info.value(forKey: UIKeyboardAnimationCurveUserInfoKey) as? NSNumber)?.uintValue {
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: { [weak self] in
                self?.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    /// Когда клавиатура исчезает
    @objc private func keyboardWillBeHidden(notification: Notification) {
        self.bottomConstraint.constant = 0
    }
    
    /// Скрыть клавиатуру
    @objc private func hideKeyboard() {
        if self.textView.isFirstResponder {
            self.textView.resignFirstResponder()
        }
    }

}


// MARK: - ChooseUserLocationTableViewControllerDelegate

extension NewPostViewController: ChooseUserLocationTableViewControllerDelegate {
    
    func chooseUserLocationTableViewController(_ chooseUserLocationTableViewController: ChooseUserLocationViewController, place: Place) {
        self.place = place
        
        dismiss(animated: true) {
            let alertController = UIAlertController(title: "Выбранная геопозиция", message: place.title, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true)
        }
    }
    
    func chooseUserLocationTableViewController(_ chooseUserLocationTableViewController: ChooseUserLocationViewController, location: CLLocation) {
        self.currentLocation = location
        
        dismiss(animated: true) {
            let message = "Широта: " + String(location.coordinate.latitude) + "\n" + "Долгота: " + String(location.coordinate.longitude)
            let alertController = UIAlertController(title: "Выбранная геопозиция", message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true)
        }
    }
    
}


// MARK: - UITextViewDelegate

extension NewPostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.hideKeyboardGesture = hideKeyboardGesture
        
        textView.addGestureRecognizer(hideKeyboardGesture)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let hideKeyboardGesture = self.hideKeyboardGesture else { return }
        textView.removeGestureRecognizer(hideKeyboardGesture)
        
        self.hideKeyboardGesture = nil
    }
    
}
