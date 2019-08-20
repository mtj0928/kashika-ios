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

@IBDesignable
class ModalTextField: UIView {

    static let height: CGFloat = 173.0

    var presenter: ModalTextFieldPresenterProtocol? {
        didSet {
            setupPresenter()
        }
    }

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
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
        addViewWithFilling(R.nib.modalTextField(owner: self))

        self.heightAnchor.constraint(equalToConstant: ModalTextField.height).isActive = true

        okButton.backgroundColor = UIColor.app.positiveColor
        cancelButton.backgroundColor = UIColor.app.negativeColor

        [okButton, cancelButton].forEach { button in
            button?.layer.cornerRadius = 0.0
            button?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
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

        textField.rx.text
            .subscribe(onNext: { [weak self] text in
                self?.presenter?.inputed(text: text)
            })
            .disposed(by: disposeBag)

        presenter?.title.subscribe(onNext: { [weak self] text in
            self?.titleLabel.text = text
        }).disposed(by: disposeBag)

        presenter?.unit.subscribe(onNext: { [weak self] unit in
            self?.unitLabel.text = unit
        }).disposed(by: disposeBag)

        presenter?.keyboardType.subscribe(onNext: { [weak self] type in
            self?.textField.keyboardType = type
        }).disposed(by: disposeBag)
    }
}
