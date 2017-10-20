//
//  FriendListTableViewCell.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {

    @IBOutlet private weak var friendName: UILabel!
    @IBOutlet weak var friendPhoto: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        friendPhoto.layer.cornerRadius = friendPhoto.bounds.width / 2
        friendPhoto.clipsToBounds = true
    }
    
    func configure(for friend: Friend) {
        
        let image_url = URL(string: friend.photo)!
        let image_from_url_request = URLRequest(url: image_url)
        
        NSURLConnection.sendAsynchronousRequest(
            image_from_url_request as URLRequest, queue: OperationQueue.main,
            completionHandler: {(response: URLResponse!,
                data: Data!,
                error: Error!) -> Void in
                
                if error == nil && data != nil {
                    self.friendPhoto.image = UIImage(data: data)
                }
        })
        
        let photo = UIImage(named: friend.photo)

        friendName.text = friend.name
        friendPhoto.image = photo
    }
    
    func clean() {
        friendName.text = nil
        friendPhoto.image = nil
    }
}
