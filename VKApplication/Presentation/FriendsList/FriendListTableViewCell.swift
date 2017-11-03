//
//  FriendListTableViewCell.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import SDWebImage

class FriendListTableViewCell: UITableViewCell {

    @IBOutlet private weak var friendName: UILabel!
    @IBOutlet weak var friendPhoto: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        friendPhoto.layer.cornerRadius = friendPhoto.bounds.width / 2
        friendPhoto.clipsToBounds = true
    }
    
    func configure(for friend: Friend) {
        friendName.text = friend.name
        
        let imageUrl = URL(string: friend.photo)
        friendPhoto.sd_setImage(with: imageUrl, placeholderImage: nil)
    }
    
    func clean() {
        friendName.text = nil
        friendPhoto.image = nil
    }
}
