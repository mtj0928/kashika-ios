//
//  CalendarTransition.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/05.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import ViewAnimator

protocol CalendarTransitionView: UIViewController {
    var backgroundAlpha: CGFloat { get set }
    var idealBackgroundAlpha: CGFloat { get }
}

class CalendarTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresent = true

    private let duration = 0.3

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let calendarTransition = extractCalendarTransitionView(using: transitionContext),
        let callViewController = extractCallerViewController(using: transitionContext) else {
                transitionContext.completeTransition(false)
                return
        }

        let containerView = transitionContext.containerView
        containerView.insertSubview(calendarTransition.view, aboveSubview: callViewController.view)

        calendarTransition.backgroundAlpha = isPresent ? 0.0 : calendarTransition.idealBackgroundAlpha

        let toAlpha = isPresent ? calendarTransition.idealBackgroundAlpha : 0.0

        UIView.animate(withDuration: duration, animations: {
            calendarTransition.backgroundAlpha = toAlpha
        }, completion: { didCompleted in
            calendarTransition.backgroundAlpha = toAlpha
            transitionContext.completeTransition(didCompleted)
        })
    }

    private func extractCalendarTransitionView(using transitionContext: UIViewControllerContextTransitioning) -> CalendarTransitionView? {
        let key = isPresent ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        return transitionContext.viewController(forKey: key) as? CalendarTransitionView
    }

    private func extractCallerViewController(using transitionContext: UIViewControllerContextTransitioning) -> UIViewController? {
        let key = isPresent ? UITransitionContextViewControllerKey.from : UITransitionContextViewControllerKey.to
        return transitionContext.viewController(forKey: key)
    }
}
