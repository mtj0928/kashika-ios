//
//  AddUserManuallyRouter.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxCocoa

class AddUserManuallyRouter: NSObject, AddUserManuallyRouterProtocol {

    weak var viewController: UIViewController?

    func showAlbum() {
    }

    func showModalTextField() -> ModalTextFieldOutputProtocol {
        let output = ModalTextFieldOutput()
        let editUsernameViewController = EditUsernameViewBuilder.build(output: output)
        editUsernameViewController.modalPresentationStyle = .overFullScreen
        editUsernameViewController.transitioningDelegate = self
        self.viewController?.present(editUsernameViewController, animated: true)
        return output
    }

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension AddUserManuallyRouter: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalTextFieldTransition<EditUsernameViewController>()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let trasition = ModalTextFieldTransition<EditUsernameViewController>()
        trasition.isPresent = false
        return trasition
    }
}
