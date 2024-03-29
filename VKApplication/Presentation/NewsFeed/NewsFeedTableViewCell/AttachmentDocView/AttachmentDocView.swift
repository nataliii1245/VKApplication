//
//  AttachmentDocView.swift
//  VKApplication
//
//  Created by Natalia Volkova on 03.11.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import SDWebImage

@IBDesignable
final class AttachmentDocView: UIView {
    
    // MARK: - Outlet
    
    /// Название документа и расширение
    @IBOutlet private weak var fileNameAndExtension: UILabel!
    /// Размер файла
    @IBOutlet private weak var fileSize: UILabel!
    /// Дата публикации файла
    @IBOutlet private weak var date: UILabel!
    /// Иконка файла
    @IBOutlet private weak var icon: UIImageView!
    
    
    // MARK: - Публичные свойства
    
    /// Дата поста, с которого сделан репост
    @IBInspectable
    var postDate: Int = 0 {
        willSet {
            let date = Date(timeIntervalSince1970: Double(newValue) as TimeInterval)
            self.date.text = DateTimeFormatter.completeDateShortMonthFormatter.string(from: date)
        }
    }
    
    /// Расширение файла
    @IBInspectable
    var `extension`: String = "" {
        willSet {
            switch newValue {
            case "jpg":
                if let url = url {
                    icon.sd_setImage(with: url) { image, error, type, url in
                        print()
                    }
                } else {
                    icon.image = #imageLiteral(resourceName: "file")
                }
            default:
                icon.image = #imageLiteral(resourceName: "file")
            }
        }
    }
    
    /// Ссылка на файл
    var url: URL?
    
    
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

extension AttachmentDocView {
    
    /// Название
    @IBInspectable
    var nameAndExtension: String? {
        get {
            return fileNameAndExtension.text
        }
        set {
            fileNameAndExtension.text = newValue
        }
    }
    
    /// Текст
    @IBInspectable
    var size: String? {
        get {
            return fileSize.text
        }
        set {
            fileSize.text = newValue
        }
    }
    
}


// MARK: - Приватные методы

private extension AttachmentDocView {
    
    /// Подготовка корневого view
    func setupRootView() {
        let view = fromNib()
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutAttachAll(to: self)
    }
    
}
