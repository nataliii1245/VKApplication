//
//  SearchGroupsListTableViewCell.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

class SearchGroupsListTableViewCell: UITableViewCell {

    @IBOutlet weak var groupPhoto: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupTheme: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        groupPhoto.layer.cornerRadius = groupPhoto.bounds.width / 2
        groupPhoto.clipsToBounds = true
    }
    
    func configure(for group: Group) {
        let photo = UIImage(named: group.photo)
        
        groupName.text = group.name
        groupPhoto.image = photo
        groupTheme.text = group.type
    }
}
