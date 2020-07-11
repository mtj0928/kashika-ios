//
//  WarikanRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/06/02.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

final class WarikanRouter: NSObject, WarikanRouterProtocol {

    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.dismiss(animated: true)
    }

    func toEditMoneyView(input: EditMoneyInputProtocol) -> EditMoneyOutputProtocol {
        let build = EditMoneyViewBuilder.build(input: input)
        let editMoneyViewController = build.viewController
        editMoneyViewController.modalPresentationStyle = .overFullScreen
        editMoneyViewController.transitioningDelegate = self
        viewController?.present(editMoneyViewController, animated: true)
        return build.output
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension WarikanRouter: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalTextFieldTransition()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let trasition = ModalTextFieldTransition()
        trasition.isPresent = false
        return trasition
    }
}
