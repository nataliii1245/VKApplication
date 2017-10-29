//
//  UIStackView+Clean.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

extension UIStackView {
    
    /// Очистить stack view
    func clean() {
        for arrangedSubview in self.arrangedSubviews {
            removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
    }
    
}
