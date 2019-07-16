//
//  EditMoneyViewController.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/13.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        setupBackground()
        
        moneyTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notification.addObserver(self, selector: #selector(self.textFieldDidChange), name: UITextField.textDidChangeNotification, object: moneyTextField)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
        notification.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notification.removeObserver(self, name: UITextField.textDidChangeNotification, object: moneyTextField)
    }
    
    @IBAction func tappedCancelButton() {
        moneyTextField.resignFirstResponder()
        dismiss(animated: true)
    }
}

// MARK: - Set Up

extension EditMoneyViewController {
    
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
    
    func hideMainView() {
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
    
    @objc
    private func textFieldDidChange() {
        guard let text = moneyTextField.text else {
            return
        }
        let numberText = text.filter({ Int($0.description) != nil })
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let commaString = formatter.string(from: NSNumber(value: Int(numberText) ?? 0))
        moneyTextField.text = commaString
    }
}
