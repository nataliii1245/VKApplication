//
//  ChooseUserLocationTableViewCell.swift
//  VKApplication
//
//  Created by Natalia Volkova on 06.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import SDWebImage

class ChooseUserLocationTableViewCell: UITableViewCell {

    // MARK: - Outlet
    
    @IBOutlet private weak var placeIcon: UIImageView!
    @IBOutlet private weak var placeTitle: UILabel!
    @IBOutlet private weak var placeInfo: UILabel!
    @IBOutlet private weak var numOfCheckins: UILabel!
    
}


// MARK: - NSObject

extension ChooseUserLocationTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.placeIcon.layer.cornerRadius = placeIcon.bounds.width / 1
        self.placeIcon.clipsToBounds = true
    }
    
}


// MARK: - Публичные методы

extension ChooseUserLocationTableViewCell {

    func configure(for place: Place) {
        self.placeTitle.text = place.title
        let placeInfo = String(place.distance) + ", " + place.address
        self.placeInfo.text = placeInfo
        self.numOfCheckins.text = String(place.checkins)
        
        let imageUrl = URL(string: place.icon)
        placeIcon.sd_setImage(with: imageUrl, placeholderImage: nil)
    }
    
}
