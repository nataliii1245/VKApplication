//
//  UIView+FromNib.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Загрузить view из xib
    func fromNib(withName nibName: String? = nil) -> UIView {
        let nibName = nibName ?? String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { fatalError() }
        
        return view
    }
    
}
