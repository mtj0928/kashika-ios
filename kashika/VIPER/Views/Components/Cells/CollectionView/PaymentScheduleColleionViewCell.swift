//
//  PaymentScheduleColleionViewCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/08.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

final class PaymentScheduleColleionViewCell: UICollectionViewCell {

    // swiftlint:disable:next private_outlet
    @IBOutlet weak var mainView: UIView!
    @IBOutlet private weak var friendIconImageView: UIImageView!
    @IBOutlet private weak var kashiLabel: UILabel!
    @IBOutlet private weak var kariLabel: UILabel!
    @IBOutlet private weak var scheduledDateLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var moneyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupMainView()
        setupFriendIconImageView()
        setupKashiLabel()
        setupKariLabel()
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        updateLayout()
    }

    private func setupMainView() {
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.3
        mainView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)

        mainView.layer.cornerRadius = 8.0
    }

    private func setupFriendIconImageView() {
        friendIconImageView.contentMode = .scaleAspectFill
        friendIconImageView.backgroundColor = UIColor.lightGray
    }

    private func setupKashiLabel() {
        kashiLabel.backgroundColor = UIColor.app.positiveColor
        kashiLabel.layer.masksToBounds = true
    }

    private func setupKariLabel() {
        kariLabel.backgroundColor = UIColor.app.negativeColor
        kariLabel.layer.masksToBounds = true
    }

    func set(debt: Debt, friend: Friend) {
        friendIconImageView.sd_setImage(with: friend.iconFile?.url)

        let type = DebtType.make(debt: debt)
        kashiLabel.isHidden = type == .kari
        kariLabel.isHidden = type == .kashi

        if let date = debt.paymentDate {
            scheduledDateLabel.isHidden = false
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dMMM", options: 0, locale: Locale(identifier: "ja_JP"))
            scheduledDateLabel.text = formatter.string(from: date.dateValue())
        } else {
            scheduledDateLabel.isHidden = true
        }

        userNameLabel.text = friend.name
        moneyLabel.text = String.convertWithComma(from: abs(debt.money))

        updateLayout()
    }

    private func updateLayout() {
        friendIconImageView.layer.cornerRadius = friendIconImageView.frame.height / 2
        kariLabel.layer.cornerRadius = kariLabel.frame.height / 2
        kashiLabel.layer.cornerRadius = kashiLabel.frame.height / 2
    }
}
