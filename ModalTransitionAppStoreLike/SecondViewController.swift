//
//  SecondViewController.swift
//  ModalTransitionAppStoreLike
//
//  Created by Franck Petriz on 15/02/2019.
//  Copyright © 2019 Franck Petriz. All rights reserved.
//

import UIKit




class SecondViewController: UIViewController {
    private var scrollView = UIScrollView()
    private var closeBtn: UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle("X", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        btn.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        let myNormalAttributedTitle =
            NSAttributedString(string: "X",  attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .black),
                NSAttributedString.Key.foregroundColor: UIColor.black])
        btn.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        return btn
    }()
   
    private (set) var cardView : CardView!
    private var cardViewModel : CardViewModel!
    
    
    var viewsAreHidden: Bool = false {
        didSet {
            closeBtn.isHidden = viewsAreHidden
            cardView?.isHidden = viewsAreHidden
            scrollView.isHidden = viewsAreHidden
            
            view.backgroundColor = viewsAreHidden ? .clear : .white
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setupDisplay()
        closeBtn.layer.cornerRadius = 15
        viewsAreHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    init(cardViewModel: CardViewModel) {
        self.cardViewModel = cardViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDisplay(){
        cardViewModel.viewMode = .full
        cardView = CardView(model: cardViewModel)
        
        view.backgroundColor = .white
       
        scrollView.addSubview(cardView!)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
       
        self.view.addConstraints(NSLayoutConstraint.pinToView(view: scrollView))

        cardView.addSubview(closeBtn)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        [NSLayoutConstraint(item: cardView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width),
         NSLayoutConstraint(item: cardView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 450)
        ].forEach{ cardView.addConstraint($0) }
        
        [NSLayoutConstraint(item: closeBtn, attribute: .top, relatedBy: .equal, toItem:cardView, attribute: .top, multiplier: 1, constant: 40),
         NSLayoutConstraint(item: closeBtn, attribute: .trailing, relatedBy: .equal, toItem: cardView, attribute: .trailing, multiplier: 1, constant: -30)
        ].forEach{  cardView.addConstraint($0) }
        
        [NSLayoutConstraint(item: closeBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30),
         NSLayoutConstraint(item: closeBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
            ].forEach{ closeBtn.addConstraint($0) }
        
        closeBtn.addTarget(self, action: #selector(close), for: .touchDown)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
