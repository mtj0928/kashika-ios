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
import SFSafeSymbols

final class FriendTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var kashiLabel: UILabel!
    @IBOutlet private weak var kariLabel: UILabel!
    @IBOutlet private weak var moneyLabel: UILabel!
    @IBOutlet private weak var noDebtLabel: UILabel!
    @IBOutlet private weak var linkButton: UIButton!

    var tappedLinkButton: ControlEvent<Void> {
        linkButton.rx.tap
    }

    private(set) var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateLayout()
    }

    func set(_ friend: Friend) {
        updateLayout()

        nameLabel.text = friend.name
        iconView.sd_setImage(with: friend.iconFile?.url)
        let debt = Int(friend.totalDebt.rawValue)
        moneyLabel.text = (String.convertWithComma(from: abs(debt)) ?? "0") + "円"

        let debtType = DebtType.make(money: debt)

        kashiLabel.isHidden = debtType != .kashi
        kariLabel.isHidden = debtType != .kari
        moneyLabel.isHidden = debtType == .none
        noDebtLabel.isHidden = debtType != .none
    }

    private func setup() {
        iconView.layer.masksToBounds = true

        noDebtLabel.textColor = UIColor.placeholderText

        kariLabel.backgroundColor = UIColor.app.negativeColor
        kashiLabel.backgroundColor = UIColor.app.positiveColor

        [kashiLabel, kariLabel].forEach { label in
            label?.textColor = UIColor.white
            label?.layer.masksToBounds = true
        }

        setupLinkButton()
        updateLayout()
    }

    private func setupLinkButton() {
        linkButton.layer.masksToBounds = true
        linkButton.layer.cornerRadius = 6.0
        linkButton.imageView?.contentMode = .scaleAspectFit
    }

    private func updateLayout() {
        kashiLabel.layer.cornerRadius = kashiLabel.frame.height / 2
        kariLabel.layer.cornerRadius = kariLabel.frame.height / 2
        iconView.layer.cornerRadius = iconView.frame.height / 2

        layoutIfNeeded()
    }
}
