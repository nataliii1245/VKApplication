//
//  UIView+LayoutAttachAll.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Прикрепить границы ко view
    func layoutAttachAll(to view: UIView) {
        let constraints = [
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leftAnchor.constraint(equalTo: view.leftAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
