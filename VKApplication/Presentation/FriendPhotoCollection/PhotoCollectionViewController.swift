//
//  PhotoCollectionViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {
    
    ///
    var friend: Friend!
    ///
    var photos: [Photo] = []
    
    // Количество элементов в строке коллекции
    let itemsPerRow: CGFloat = 1
    // Задание отступов
    let sectionInsets = UIEdgeInsets(top: 30.0, left: 15.0, bottom: 30.0, right: 15.0)
}

// MARK: - UIViewController

extension PhotoCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        photos = DatabaseManager.loadPhotos()
        
        PhotoService.getUserPhotos(ownerID: friend.id, { photos in
            self.photos = photos
            
            DatabaseManager.removePhotos()
            DatabaseManager.savePhotos(self.photos)
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }, { error in
            let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(alertController, animated: true)
            }
        })
    }
    
}

// MARK: - UICollectionView

extension PhotoCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        let friendPhoto = photos[indexPath.row]
        
        cell.configure(for: friendPhoto)
        cell.backgroundColor = .black
        cell.photoView.image = UIImage(named: friendPhoto.url)
        
        return cell
    }
    
}

// MARK: - UICollectionViewFlowLayout

extension PhotoCollectionViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

}
