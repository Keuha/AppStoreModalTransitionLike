//
//  ModalTransition.swift
//  ModalTransitionAppStoreLike
//
//  Created by Franck Petriz on 18/02/2019.
//  Copyright © 2019 Franck Petriz. All rights reserved.
//

import UIKit

class ModalTransition: NSObject {
    enum modalState {
        case present
        case dismiss
        
        var blurAlpha : CGFloat { return self == .present ? 0 : 1}
        var dimAlpha : CGFloat { return self == .present ?  0 : 0.1}
        var cornerRadius : CGFloat { return self == .present ? 20 : 0}
        var cardMode : CardViewMode { return self == .present ? .card : .full}
        var nextState : modalState { return self == .present ? .dismiss : .present }
      
    }
    var state : modalState = .present
    var startPoint : CGPoint = CGPoint.zero
    var originImgViewFrame = CGRect.zero
    var originView = UIView()
    var duration : Double  = 0.8
    let shrinkDuration: Double = 0.3
    
    func copyCardView(original :CardView) -> CardView {
        let cardViewCopy = CardView(model: original.cardModel)
        return cardViewCopy
    }
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        return UIVisualEffectView(effect: blurEffect)
    }()
    
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let whiteScrollView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private func addBackgroundViews(containerView: UIView) {
        blurEffectView.frame = containerView.frame
        blurEffectView.alpha = state.blurAlpha
        containerView.addSubview(blurEffectView)
        
        dimmingView.frame = containerView.frame
        dimmingView.alpha = state.dimAlpha
        containerView.addSubview(dimmingView)
    }
}

extension ModalTransition: UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        containerView.subviews.forEach{ $0.removeFromSuperview() }
        addBackgroundViews(containerView: containerView)
        
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        
        guard let cardView = state == .present ? (fromVC as! ViewController).selectedCellCardView() : (toVC as! ViewController).selectedCellCardView() else { return }
        
        // Hide the original cardView so that you can seamlessly scale the cardViewCopy to be smaller and add the copy
        cardView.isHidden = true
        let cardViewCopy = copyCardView(original: cardView)
        containerView.addSubview(cardViewCopy)
        
        let absoluteFrame = cardView.convert(cardView.frame, to: nil)
        cardViewCopy.frame = absoluteFrame
        
        whiteScrollView.frame = state == .present ? cardView.containerView.frame : containerView.frame
        
        cardViewCopy.insertSubview(whiteScrollView, aboveSubview: cardViewCopy.shadowView)
        
        if state == .present {
            let toVC = toVC as! SecondViewController
            containerView.addSubview(toVC.view)
            toVC.viewsAreHidden = true
            moveAndConvertCardView(cardView: cardViewCopy, containerView: containerView, yOriginToMoveTo: 0, completion: {
                cardView.isHidden = true
                toVC.viewsAreHidden = false
                cardViewCopy.removeFromSuperview()
                transitionContext.completeTransition(true)
                }
            )
        } else {
            let fromVC = fromVC as! SecondViewController
            cardViewCopy.frame = fromVC.cardView!.frame
            fromVC.viewsAreHidden = true
            moveAndConvertCardView(cardView: cardViewCopy, containerView: containerView, yOriginToMoveTo: absoluteFrame.origin.y, completion: {
                
                cardView.isHidden = false
                transitionContext.completeTransition(true)
            })
        }

    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    
    
    //MARK: Animation methods
    private func makeShrinkAnimator(forView cardView : UIView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: shrinkDuration, curve: .easeOut, animations: {
            cardView.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
            self.dimmingView.alpha = self.state.nextState.dimAlpha
            self.blurEffectView.alpha = self.state.nextState.blurAlpha
        })
    }
    
    private func makeExpandContractAnimator(forView cardView:CardView, container: UIView, yOrigin:CGFloat) -> UIViewPropertyAnimator {
        let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 4))
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: springTiming)
        
        animator.addAnimations {
            self.dimmingView.alpha = self.state.nextState.dimAlpha
            self.blurEffectView.alpha = self.state.nextState.blurAlpha
            cardView.transform = CGAffineTransform.identity
            cardView.containerView.layer.cornerRadius = self.state.nextState.cornerRadius
            cardView.frame.origin.y = yOrigin
            self.whiteScrollView.layer.cornerRadius = cardView.containerView.layer.cornerRadius
            self.whiteScrollView.frame = self.state == .present ? container.frame : cardView.containerView.frame
            container.layoutIfNeeded()
        }
        return animator
    }
    
    private func moveAndConvertCardView(cardView: CardView, containerView: UIView, yOriginToMoveTo: CGFloat, completion: @escaping () ->()) {
        let shrinkAnim = makeShrinkAnimator(forView: cardView)
        let expandAnim = makeExpandContractAnimator(forView: cardView, container: containerView, yOrigin: yOriginToMoveTo)
        expandAnim.addCompletion{(_) in
            completion()
        }
        
        if state == .present {
            shrinkAnim.addCompletion{ (_) in
                cardView.layoutIfNeeded()
                cardView.updateLayout(for: self.state.nextState.cardMode)
                
                expandAnim.startAnimation()
            }
            shrinkAnim.startAnimation()
        } else {
            cardView.layoutIfNeeded()
            cardView.updateLayout(for: self.state.nextState.cardMode)
            expandAnim.startAnimation()
        }
    }
}

extension ModalTransition:  UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        state = .present
        return self
    }
        
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        state = .dismiss
        return self
    }
}


