//
//  FriendTableViewCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

final class FriendTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var kashiLabel: UILabel!
    @IBOutlet private weak var kariLabel: UILabel!
    @IBOutlet private weak var moneyLabel: UILabel!
    @IBOutlet private weak var moDebtLabel: UILabel!

    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    private func setup() {
        iconView.layer.masksToBounds = true

        kariLabel.backgroundColor = UIColor.app.negativeColor
        kashiLabel.backgroundColor = UIColor.app.positiveColor

        [kashiLabel, kariLabel].forEach { label in
            label?.textColor = UIColor.white
            label?.layer.masksToBounds = true
        }
        updateLayout()
    }

    func set(presenter: FriendListCellPresenterProtocol) {
        updateLayout()

        presenter.name.asDriver(onErrorDriveWith: Driver.empty()).drive(onNext: { [weak self] name in
            self?.nameLabel.text = name
        }).disposed(by: disposeBag)

        Observable.combineLatest(presenter.iconURL, presenter.plaveHolderImage).asDriver(onErrorDriveWith: Driver.empty()).drive(onNext: { [weak self] (url, placeHolderImage) in
            self?.iconView?.sd_setImage(with: url, placeholderImage: placeHolderImage)
        }).disposed(by: disposeBag)

        presenter.debt.map { abs($0) }.asDriver(onErrorDriveWith: Driver.empty()).drive(onNext: { [weak self] debt in
            self?.moneyLabel.text = (String.convertWithComma(from: debt) ?? "0") + "円"
        }).disposed(by: disposeBag)

        presenter.isKashi.asDriver(onErrorDriveWith: Driver.empty()).drive(onNext: { [weak self] isKashi in
            self?.kashiLabel.isHidden = !isKashi
        }).disposed(by: disposeBag)

        presenter.isKari.asDriver(onErrorDriveWith: Driver.empty()).drive(onNext: { [weak self] isKari in
            self?.kariLabel.isHidden = !isKari
        }).disposed(by: disposeBag)

        presenter.hasNoDebt.asDriver(onErrorDriveWith: Driver.empty()).drive(onNext: { [weak self] noDebt in
            self?.moneyLabel.isHidden = noDebt
            self?.moDebtLabel.isHidden = !noDebt
        }).disposed(by: disposeBag)
    }

    private func updateLayout() {
        kashiLabel.layer.cornerRadius = kashiLabel.frame.height / 2
        kariLabel.layer.cornerRadius = kariLabel.frame.height / 2
        iconView.layer.cornerRadius = iconView.frame.height / 2
    }
}
