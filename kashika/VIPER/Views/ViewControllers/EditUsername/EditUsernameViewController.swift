//
//  EditUsernameViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

final class EditUsernameViewController: UIViewController {

    @IBOutlet private weak var modalTextField: ModalTextField!
    @IBOutlet private weak var bottomLayout: NSLayoutConstraint!
    @IBOutlet private weak var backgroundView: UIView!

    private var presenter: EditUsernamePresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackgroundView()
        setupModalTextField()

        self.view.layoutIfNeeded()
        modalTextField.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let notification = NotificationCenter.default
        notification.removeObserver(self)
        notification.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    static func createFromStoryboard(with presenter: EditUsernamePresenterProtocol) -> EditUsernameViewController {
        let viewController = EditUsernameViewController.createFromStoryboard()
        viewController.presenter = presenter
        return viewController
    }
}

// MARK: - Set Up

extension EditUsernameViewController {

    private func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.8
    }

    private func setupModalTextField() {
        modalTextField.presenter = presenter
    }
}

// MARK: - View

extension EditUsernameViewController {

    private func hideMainView() {
        bottomLayout.constant = -modalTextField.frame.height - view.safeAreaInsets.bottom
    }
}

// MARK: - Observer

extension EditUsernameViewController {

    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        guard let keyBoardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration: TimeInterval = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                return
        }
        view.layoutIfNeeded()
        let keyboardRect = keyBoardInfo.cgRectValue
        bottomLayout.constant = keyboardRect.height - view.safeAreaInsets.bottom
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        guard let duration: TimeInterval = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        view.layoutIfNeeded()
        hideMainView()
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

// MARK: - ModalTextFieldTransitionView

extension EditUsernameViewController: ModalTextFieldTransitionView {

    var backgroundAlpha: CGFloat {
        get {
            return backgroundView.alpha
        }
        set {
            backgroundView.alpha = newValue
        }
    }
}
