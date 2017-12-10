//
//  FriendRequestsListTableViewCell.swift
//  VKApplication
//
//  Created by Natalia Volkova on 10.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import SDWebImage

class FriendRequestsListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var friendRequestUserName: UILabel!
    @IBOutlet weak var friendRequestUserPhoto: UIImageView!

}


// MARK: - Публичные методы

extension FriendRequestsListTableViewCell {
    
    /// Сконфигурировать ячейку
    func configure(for friendRequestUser: FriendRequestUser) {
        friendRequestUserName.text = friendRequestUser.name
        
        let imageUrl = URL(string: friendRequestUser.photo)
        friendRequestUserPhoto.sd_setImage(with: imageUrl, placeholderImage: nil)
    }
    
    /// Очистить ячейку
    func clean() {
        friendRequestUserName.text = nil
        friendRequestUserPhoto.image = nil
    }
    
}


// MARK: - NSObject

extension FriendRequestsListTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        friendRequestUserPhoto.layer.cornerRadius = friendRequestUserPhoto.bounds.width / 2
        friendRequestUserPhoto.clipsToBounds = true
    }
    
}
