//
//  SNSFooterButtons.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/20.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TapticEngine

fileprivate extension UIColor.AppColor {
    var greenColor: UIColor {
        return UIColor(hex: "01A564")
    }
}

@IBDesignable
class SNSFooterButtons: UIView {

    static let height: CGFloat = 46

    @IBOutlet private weak var leftSpacer: UIView!
    @IBOutlet private weak var addUserButton: EmphasisButton!
    @IBOutlet private weak var centerSapcer: UIView!
    @IBOutlet private weak var addUseromSNSButton: EmphasisButton!
    @IBOutlet private weak var rightSpacer: UIView!

    var presenter: SNSFooterPresenterProtocol? {
        didSet {
            updatePresenter()
        }
    }

    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
    }

    func loadNib() {
        addViewWithFilling(R.nib.snsFooterButtons(owner: self))
        self.heightAnchor.constraint(equalToConstant: SNSFooterButtons.height).isActive = true

        addUserButton.backgroundColor = UIColor.app.greenColor
        addUserButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)

        addUseromSNSButton.setTitle("SNSから追加", for: .normal)
        addUseromSNSButton.backgroundColor = UIColor.app.positiveColor
        addUseromSNSButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)

        updateUserInterfaceStyle()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateUserInterfaceStyle()
    }

    private func updateUserInterfaceStyle() {
        let buttons = [addUserButton, addUseromSNSButton]
        switch traitCollection.userInterfaceStyle {
        case .dark:
            buttons.forEach { button in
                button?.layer.shadowColor = UIColor.clear.cgColor
            }
        case .light:
            buttons.forEach { button in
                button?.layer.shadowColor = UIColor.black.cgColor
                button?.layer.shadowOpacity = 0.2
                button?.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
                button?.layer.shadowRadius = 4.0
            }
        default:
            return
        }
    }

    private func updatePresenter() {
        disposeBag = DisposeBag()

        addUserButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            TapticEngine.impact.feedback(.light)
            self?.presenter?.tappedAddUserButton(with: .manual)
        }).disposed(by: disposeBag)

        addUseromSNSButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            TapticEngine.impact.feedback(.light)
            self?.presenter?.tappedAddUserButton(with: .sns)
        }).disposed(by: disposeBag)

        presenter?.isSendingData.map({ $0 ? "送信中" : "手動で追加" })
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [weak self] title in
                self?.addUserButton.setTitle(title, for: .normal)
            }).disposed(by: disposeBag)

        presenter?.isSendingData
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [weak self] isSendingData in
                self?.animateButton(isSendingData)
            }).disposed(by: disposeBag)
    }

    private func animateButton(_ isSendingData: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.5, options: UIView.AnimationOptions.curveEaseOut, animations: { [weak self] in
            self?.addUseromSNSButton.isHidden = isSendingData
            self?.rightSpacer.isHidden = isSendingData
            self?.layoutIfNeeded()
        }, completion: nil)
    }
}
