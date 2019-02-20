//
//  Extensions+UIImage.swift
//  ModalTransitionAppStoreLike
//
//  Created by Franck Petriz on 18/02/2019.
//  Copyright © 2019 Franck Petriz. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    func imageWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size:newSize)
        let image = renderer.image {_ in
            draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
            
        }
        return image
    }
}
