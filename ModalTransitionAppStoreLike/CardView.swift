//
//  CardView.swift
//  ModalTransitionAppStoreLike
//
//  Created by Franck Petriz on 18/02/2019.
//  Copyright © 2019 Franck Petriz. All rights reserved.
//

import UIKit

class CardView: UIView {
    var imageView : UIImageView!
    
    
    let shadowView = UIView()
    let containerView = UIView()
    var backgroundImageView = UIImageView()
    
    var cardModel : CardViewModel!
    
    private var tableView = UITableView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let featuredTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    
    private var topConstraint : NSLayoutConstraint = NSLayoutConstraint()
    private var bottomConstraint : NSLayoutConstraint = NSLayoutConstraint()
    private var leadingConstraint : NSLayoutConstraint = NSLayoutConstraint()
    private var trailingConstraint : NSLayoutConstraint = NSLayoutConstraint()
    
    
    init(model:CardViewModel) {
        
        super.init(frame: .zero)
        self.cardModel = model
        setUpViews()
    }
    
    func setUpViews() {
        
        
        leadingConstraint = NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        trailingConstraint = NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        topConstraint = NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        bottomConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        
      
        backgroundColor = .clear
        addSubview(shadowView)
        shadowView.backgroundColor = .white
        addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        if cardModel.viewMode == .card {
            convertContainerViewToCardView()
        } else {
            convertContainerViewToFullScreen()
        }
        addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        addConstraints(NSLayoutConstraint.pinToView(view: shadowView))
        
        addBackgroundImage()
        addTopTitleLabels()
        addDescriptionLabel()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func convertContainerViewToCardView() {
        updateLayout(for: .card)
        self.layer.cornerRadius = 20
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
    }
    
    private func convertContainerViewToFullScreen() {
       
        updateLayout(for: .full)
        self.layer.cornerRadius = 0
        containerView.layer.cornerRadius = 0
        containerView.layer.masksToBounds = true
    }
    
    private func addBackgroundImage() {

        backgroundImageView.image = cardModel.backgroundImage
        
        backgroundImageView.contentMode = .center
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(backgroundImageView)
        containerView.addConstraints(NSLayoutConstraint.pinToView(view: backgroundImageView))
    }
    
    private func addTopTitleLabels() {
        
    }
    
    private func addDescriptionLabel() {
        
    }
    
    func updateLayout(for viewMode: CardViewMode) {
        switch viewMode {
        case .card:
            leadingConstraint.constant = 20
            trailingConstraint.constant = -20
            topConstraint.constant = 15
            bottomConstraint.constant = -15
            removeShadow()
            
        case .full:
            leadingConstraint.constant = 0
            trailingConstraint.constant = 0
            topConstraint.constant = 0
            bottomConstraint.constant = 0
            addShadow()
        }
    }
    
    func hide(views: [UIView]) {
        views.forEach{ $0.removeFromSuperview() }
    }
    
    func show(views: [UIView]) {
        views.forEach{ $0.isHidden = false }
    }
    
    func addShadow() {
        
        shadowView.layer.cornerRadius = 20
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOffset = CGSize(width: -1, height: 2)
    }
    
    func removeShadow() {
        
        shadowView.layer.shadowColor = UIColor.clear.cgColor
        shadowView.layer.shadowOpacity = 0
        shadowView.layer.shadowRadius = 0
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
