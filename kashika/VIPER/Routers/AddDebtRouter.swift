//
//  AddDebtRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/05.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AddDebtRouter: NSObject, AddDebtRouterProtocol {

    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
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

extension AddDebtRouter: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalTextFieldTransition()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let trasition = ModalTextFieldTransition()
        trasition.isPresent = false
        return trasition
    }
}
