//
//  AddDebtRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/05.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import UIKit

final class AddDebtRouter: NSObject, AddDebtRouterProtocol {

    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func toEditManeyView() {
        let editMoneyViewController = EditMoneyViewController.createFromStoryboard()
        editMoneyViewController.modalPresentationStyle = .overFullScreen
        editMoneyViewController.transitioningDelegate = self
        viewController?.present(editMoneyViewController, animated: true)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension AddDebtRouter: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return EditMoneyTransition()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let trasition = EditMoneyTransition()
        trasition.isPresent = false
        return trasition
    }
//
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return EditMoneyTransition()
//    }
}
