//
//  CGSize+Scaled.swift
//  VKApplication
//
//  Created by Natalia Volkova on 25.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import CoreGraphics

extension CGSize {
    
    /// Размер, пропорционально измененный до указанной ширины
    func scaled(toWidth width: CGFloat) -> CGSize {
        let scale = width / self.width
        let height = self.height * scale
        
        return CGSize(width: width, height: height)
    }
    
    /// Размер, пропорционально измененный до указанной высоты
    func scaled(toHeight height: CGFloat) -> CGSize {
        let scale = height / self.height
        let width = self.width * scale
        
        return CGSize(width: width, height: height)
    }
    
    /// Размер, пропорционально измененный до указанных границ
    func scaled(toFit size: CGSize) -> CGSize {
        let scale = min(1, min(size.width / self.width, size.height / self.height))
        guard scale != 1 else { return self }
        
        let width = self.width * scale
        let height = self.height * scale
        
        return CGSize(width: width, height: height)
    }
    
}
