//
//  ViewController.swift
//  ModalTransitionAppStoreLike
//
//  Created by Franck Petriz on 11/02/2019.
//  Copyright © 2019 Franck Petriz. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    let transition = ModalTransition()
    
    let model : [CardViewModel] = [
    CardViewModel(backGroundImage: UIImage(named: "mediterranean.jpg")!, title: "test", subtitle: "sub", description: "desc"),
    CardViewModel(backGroundImage: UIImage(named: "mountain.jpg")!, title: "test", subtitle: "sub", description: "desc"),
    CardViewModel(backGroundImage: UIImage(named: "winter.jpg")!, title: "test", subtitle: "sub", description: "desc")]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GenericCell<CardView>.self, forCellReuseIdentifier:  String(describing: GenericCell<CardView>.self))
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        setupDisplay()
    }
   
    private func setupDisplay() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.pinToView(view: tableView))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GenericCell<CardView>.self), for: indexPath) as! GenericCell<CardView>
        cell.content = nil
        let model = self.model[indexPath.row % self.model.count]
        cell.content = CardView(model:model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count * 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! GenericCell<CardView>
        guard let cardView = cell.content else { return  }
        
        
        let model = CardViewModel(initWithCopy: cardView.cardModel)
        let secondViewController = SecondViewController(cardViewModel: model)
        
        secondViewController.transitioningDelegate = transition
        secondViewController.modalPresentationStyle = .overFullScreen
        
        present(secondViewController, animated: true, completion: nil)
    }
    
    func selectedCellCardView() -> CardView? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        
        let cell = tableView.cellForRow(at: indexPath) as! GenericCell<CardView>
        guard let cardView = cell.content else { return nil }
        
        return cardView
    }
}

extension ViewController : UIViewControllerTransitioningDelegate {
   
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.state = .present
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.state = .dismiss
        return transition
    }
    
    func getCardViewModel() -> CardViewModel? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        
        let cell = tableView.cellForRow(at: indexPath) as! GenericCell<CardView>
        guard let cardView = cell.content else { return nil }
        
        return cardView.cardModel
    }
}
