//
//  FriendDetailMainTableViewCel.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/18.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class FriendDetailMainTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var kashiLabel: UILabel!
    @IBOutlet private weak var kariLabel: UILabel!
    @IBOutlet private weak var moneyLabel: UILabel!
    @IBOutlet private weak var paymentButton: UIButton!
    @IBOutlet private weak var moneyBackgroundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupImageView()
        setupMoneyBackgroundView()
        setupPaymeytButton()
        setupKashiKariLabel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateLayout()
    }

    @IBAction func tappedPaymentButton() {
    }

    func set(for friend: Friend) {
        if let reference = friend.iconFile?.storageReference {
            iconImageView.sd_setImage(with: reference)
        } else {
            iconImageView.image = nil
        }

        moneyLabel.text = String.convertWithComma(from: abs(Int(friend.totalDebt.rawValue)))

        userNameLabel.text = friend.name

        let debtType = DebtType.make(money: Int(friend.totalDebt.rawValue))
        kashiLabel.isHidden = debtType != .kashi
        kariLabel.isHidden = debtType != .kari
    }
}

// MARK: - Set Up

extension FriendDetailMainTableViewCell {

    private func setupImageView() {
        imageView?.layer.masksToBounds = true
    }

    private func setupMoneyBackgroundView() {
        moneyBackgroundView.layer.masksToBounds = true
        moneyBackgroundView.layer.cornerRadius = 10

        moneyBackgroundView.backgroundColor = UIColor.app.secondarySystemBackground
    }

    private func setupPaymeytButton() {
        paymentButton.layer.masksToBounds = true
        paymentButton.layer.cornerRadius = 10
    }

    private func setupKashiKariLabel() {
        kariLabel.backgroundColor = UIColor.app.negativeColor
        kashiLabel.backgroundColor = UIColor.app.positiveColor

        [kashiLabel, kariLabel].forEach { label in
            label?.textColor = UIColor.white
            label?.layer.masksToBounds = true
        }
    }

    private func updateLayout() {
        [iconImageView, kashiLabel, kariLabel].forEach { view in
            view?.layer.cornerRadius = (view?.frame.height ?? 0) / 2
        }
        separatorInset = UIEdgeInsets(top: 0, left: frame.width, bottom: 0, right: 0)
    }

}
