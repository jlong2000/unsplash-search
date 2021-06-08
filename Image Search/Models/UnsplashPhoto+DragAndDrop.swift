//
//  UnsplashPhoto+DragAndDrop.swift
//  Image Search
//
//  Created by Jiang Long on 6/4/21.
//

import UIKit

extension UnsplashPhoto {
    var itemProvider: NSItemProvider {
        return NSItemProvider(object: UnsplashPhotoItemProvider(with: self))
    }

    var dragItem: UIDragItem {
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = self
        dragItem.previewProvider = {
            guard let photoView = PhotoView.view(with: self) else {
                return nil
            }

            photoView.userNameLabel.isHidden = true
            photoView.layer.cornerRadius = 12
            photoView.frame.size.width = 300
            photoView.frame.size.height = 300 * CGFloat(self.height) / CGFloat(self.width)
            photoView.layoutSubviews()

            let parameters = UIDragPreviewParameters()
            parameters.backgroundColor = .clear

            return UIDragPreview(view: photoView, parameters: parameters)
        }
        return dragItem
    }
}
