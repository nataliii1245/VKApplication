//
//  PhotoCollectionViewCell.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import SDWebImage

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet weak var photoView: UIImageView!
    
    
    // MARK: - Публичные методы
    
    /// Сконфигурировать ячейку коллекции
    func configure(for photo: Photo) {
        let imageUrl = URL(string: photo.url)
        photoView.sd_setImage(with: imageUrl, placeholderImage: nil)
    }
    
}
