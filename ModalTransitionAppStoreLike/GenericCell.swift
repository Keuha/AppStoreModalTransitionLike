//
//  PictureCell.swift
//  ModalTransitionAppStoreLike
//
//  Created by Franck Petriz on 11/02/2019.
//  Copyright © 2019 Franck Petriz. All rights reserved.
//

import Foundation
import UIKit

class GenericCell<T: UIView>: UITableViewCell {
    var content: T? {
        didSet {
            guard content != nil else { return }
            setupDisplay()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDisplay()
    }
    
    private func setupDisplay() {
        guard let content = content else { return  }
        
        addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.pinToView(view: content))
    }
    
}
