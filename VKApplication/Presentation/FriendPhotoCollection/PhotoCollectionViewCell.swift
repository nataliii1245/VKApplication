//
//  PhotoCollectionViewCell.swift
//  VKApplication
//
//  Created by Natalia Volkova on 16.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
   
    @IBOutlet weak var photoView: UIImageView!
    func configure(for photo: Photo) {
        
        var image_url: NSURL = NSURL(string: photo.url)!
        let image_from_url_request: NSURLRequest = NSURLRequest(url: image_url as URL)
        
        NSURLConnection.sendAsynchronousRequest(
            image_from_url_request as URLRequest, queue: OperationQueue.main,
            completionHandler: {(response: URLResponse!,
                data: Data!,
                error: Error!) -> Void in
                
                if error == nil && data != nil {
                    self.photoView.image = UIImage(data: data)
                }
                
        })
    }
}
