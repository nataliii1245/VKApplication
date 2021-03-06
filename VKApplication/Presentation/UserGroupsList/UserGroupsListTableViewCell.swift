//
//  UserGroupsListTableViewCell.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit
import SDWebImage

final class UserGroupsListTableViewCell: UITableViewCell {

    // MARK: - Outlet
    
    @IBOutlet weak var groupPhoto: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupTheme: UILabel!
    
    
    // MARK: - Публичные методы

    /// Сконфигурировать ячейку группы
    func configure(for group: Group) {
        groupName.text = group.name
        groupTheme.text = group.type
        
        let imageUrl = URL(string: group.photo)
        groupPhoto.sd_setImage(with: imageUrl, placeholderImage: nil)
    }
    
    /// Очистить ячейку группы
    func clean() {
        groupName.text = nil
        groupPhoto.image = nil
        groupTheme.text = nil
    }

}


// MARK: - NSObject

extension UserGroupsListTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        groupPhoto.layer.cornerRadius = groupPhoto.bounds.width / 2
        groupPhoto.clipsToBounds = true
    }
    
}
