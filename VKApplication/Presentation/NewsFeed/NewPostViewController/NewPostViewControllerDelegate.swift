//
//  NewPostViewControllerDelegate.swift
//  VKApplication
//
//  Created by Natalia Volkova on 04.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

protocol NewPostViewControllerDelegate: class {
    
    /// Уведомление об успешном добавлении записи
    func newPostViewControllerDidPosted(_ newPostViewController: NewPostViewController)
    
}
