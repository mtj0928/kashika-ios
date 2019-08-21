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

    private static let height: CGFloat = 46

    @IBOutlet private weak var addUserButton: EmphasisButton!
    @IBOutlet private weak var addUseromSNSButton: EmphasisButton!

    var presenter: SNSFooterPresenterProtocol? {
        didSet {
            update()
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
    }

    private func update() {
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
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.5, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self?.addUseromSNSButton.isHidden = isSendingData
                    self?.layoutIfNeeded()
                }, completion: nil)
            }).disposed(by: disposeBag)
    }
}
