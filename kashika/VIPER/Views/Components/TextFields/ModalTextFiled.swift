//
//  ModalTextFiled.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
// 

import UIKit
import RxSwift
import RxCocoa

enum ModalTextFieldKeyboardType {
    case `default`
    case calculator(enableToInsertButtonDriver: Driver<Bool>)

    func apply(textField: UITextField, parentView: UIView, disposeBag: DisposeBag) {
        switch self {
        case .default:
            textField.keyboardType = .default
        case .calculator(let driver):
            let frame = CGRect(
                x: 0,
                y: 0,
                width: parentView.frame.width,
                height: 0.75 * parentView.frame.width + parentView.safeAreaInsets.bottom
            )
            let view = CalculatorInputView(frame: frame, keyInput: textField)
            textField.inputView = view
            driver.drive(onNext: { enableToInsert in
                view.canBeInsertSymbol = enableToInsert
            }).disposed(by: disposeBag)
        }
    }
}

@IBDesignable
class ModalTextField: UIView {

    static let height: CGFloat = 173.0

    var presenter: ModalTextFieldPresenterProtocol? {
        didSet {
            setupPresenter()
        }
    }

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var separateView: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var summaryView: UIView!
    @IBOutlet private weak var summaryLabel: UILabel!
    @IBOutlet private weak var unitLabel: UILabel!
    @IBOutlet private weak var okButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!

    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
    }

    func loadNib() {
        backgroundColor = UIColor.clear
        let view = R.nib.modalTextField.firstView(owner: self)
        addViewWithFilling(view)

        okButton.backgroundColor = UIColor.app.positiveColor
        cancelButton.backgroundColor = UIColor.app.negativeColor

        [okButton, cancelButton].forEach { button in
            button?.layer.cornerRadius = 0.0
            button?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        }
        if #available(iOS 13.0, *) {
            textField.textColor = UIColor.label
            separateView.backgroundColor = UIColor.separator
        }
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder() && super.becomeFirstResponder()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder() && super.resignFirstResponder()
    }

    private func setupPresenter() {
        okButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.resignFirstResponder()
            self?.presenter?.tappedOkButton()
        }).disposed(by: disposeBag)

        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.resignFirstResponder()
            self?.presenter?.tappedCancelButton()
        }).disposed(by: disposeBag)

        presenter?.text.subscribe(onNext: { [weak self] text in
            self?.textField.text = text
        }).disposed(by: disposeBag)

        textField.rx.text.subscribe(onNext: { [weak self] text in
                self?.presenter?.inputed(text: text)
        }).disposed(by: disposeBag)

        presenter?.title.subscribe(onNext: { [weak self] text in
            self?.titleLabel.text = text
        }).disposed(by: disposeBag)

        presenter?.unit.subscribe(onNext: { [weak self] unit in
            self?.unitLabel.text = unit
        }).disposed(by: disposeBag)

        presenter?.summaryIsHidden.drive(onNext: { [weak self] isHidden in
            self?.summaryView.isHidden = isHidden
        }).disposed(by: disposeBag)

        presenter?.summaryText.drive(onNext: { [weak self] text in
            self?.summaryLabel.text = text
        }).disposed(by: disposeBag)

        presenter?.keyboardType.subscribe(onNext: { [weak self] type in
            guard let view = self,
                let textField = self?.textField,
                let disposeBag = self?.disposeBag else {
                return
            }

            type.apply(textField: textField, parentView: view, disposeBag: disposeBag)
        }).disposed(by: disposeBag)
    }
}
