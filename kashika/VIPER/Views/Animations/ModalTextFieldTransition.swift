//
//   ModalTextFieldTransition.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

protocol ModalTextFieldTransitionProtocol: UIViewController {
    var backgroundAlpha: CGFloat { get set }
}

//extension ModalTextFieldTransitionProtocol 

class ModalTextFieldTransition<T: UIViewController>: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresent = true

    private let duration = 0.3

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let modalTextFieldTransitionView = extractModalTextFieldTransitionProtocol(using: transitionContext),
        let callViewController = extractCallerViewController(using: transitionContext) else {
                transitionContext.completeTransition(false)
                return
        }

        let containerView = transitionContext.containerView
        containerView.insertSubview(modalTextFieldTransitionView.view, aboveSubview: callViewController.view)

        modalTextFieldTransitionView.backgroundAlpha = isPresent ? 0.0 : EditMoneyViewController.backgroundAlpha
        
        let toAlpha = isPresent ? EditMoneyViewController.backgroundAlpha : 0.0
        UIView.animate(withDuration: duration, animations: {
            modalTextFieldTransitionView.backgroundAlpha = toAlpha
        }, completion: { didCompleted in
            modalTextFieldTransitionView.backgroundAlpha = toAlpha
            transitionContext.completeTransition(didCompleted)
        })
    }

    private func extractModalTextFieldTransitionProtocol(using transitionContext: UIViewControllerContextTransitioning) -> ModalTextFieldTransitionProtocol? {
        let key = isPresent ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        return transitionContext.viewController(forKey: key) as? ModalTextFieldTransitionProtocol
    }

    private func extractCallerViewController(using transitionContext: UIViewControllerContextTransitioning) -> UIViewController? {
        let key = isPresent ? UITransitionContextViewControllerKey.from : UITransitionContextViewControllerKey.to
        return transitionContext.viewController(forKey: key)
    }
}
