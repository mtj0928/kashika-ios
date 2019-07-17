//
//  EditMoneyViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/13.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class EditMoneyViewController: UIViewController {
    
    static let backgroundAlpha: CGFloat = 0.8
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var moneyTextField: UnitTextField!
    @IBOutlet private weak var okButton: EmphasisButton!
    @IBOutlet private weak var cancelButton: EmphasisButton!
    @IBOutlet private weak var bottomLayout: NSLayoutConstraint!
    
    var backgroundAlpha: CGFloat {
        get {
            return backgroundView.alpha
        }
        set {
            backgroundView.alpha = newValue
        }
    }

    private var presenter: EditMoneyPresenterProtocol!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        setupTextField()
        setupBackground()
        
        moneyTextField.becomeFirstResponder()
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
    
    @IBAction private func tappedOkButton() {
        moneyTextField.resignFirstResponder()
        presenter.tappedOkButton()
    }

    @IBAction private func tappedCancelButton() {
        moneyTextField.resignFirstResponder()
        presenter.tappedCancelButton()
    }

    class func createFromStoryboard(presenter: EditMoneyPresenterProtocol) -> EditMoneyViewController {
        let viewController = createFromStoryboard()
        viewController.presenter = presenter
        return viewController
    }
}

// MARK: - Set Up

extension EditMoneyViewController {

    private func setupTextField() {
        moneyTextField.text = String.convertWithComma(from: presenter.money.value)

        moneyTextField.rx.text
            .filter({ $0 != nil })
            .map({ text -> String in
                return text?.filter({ Int($0.description) != nil }) ?? "0"
            })
            .map({ Int($0) ?? 0 })
            .subscribe(onNext: { [weak self] money in
                self?.moneyTextField.text = String.convertWithComma(from: money)
                self?.presenter.money.accept(money)
            }).disposed(by: disposeBag)
    }

    private func setupBackground() {
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = EditMoneyViewController.backgroundAlpha
        
        view.backgroundColor = UIColor.clear
    }
    
    private func setupButton() {
        okButton.backgroundColor = UIColor.app.positiveColor
        cancelButton.backgroundColor = UIColor.app.negativeColor

        [okButton, cancelButton].forEach { button in
            button?.layer.cornerRadius = 0.0
            button?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        }
    }
}

// MARK: - View

extension EditMoneyViewController {
    
    private func hideMainView() {
        bottomLayout.constant = -mainView.frame.height - view.safeAreaInsets.bottom
    }
}

// MARK: - Observer

extension EditMoneyViewController {
    
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
