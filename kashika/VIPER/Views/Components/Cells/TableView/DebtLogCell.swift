//
//  DebtLogCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/28.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class DebtLogCell: UITableViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var kashiLabel: UILabel!
    @IBOutlet private weak var kariLabel: UILabel!
    @IBOutlet private weak var moneyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupKashiKariLabel()
    }

    func set(debt: Debt) {
        dateLabel.text = debt.createdAt.dateValue().ex.asString(format: "M/dd")
        kashiLabel.isHidden = debt.debtType != .kashi
        kariLabel.isHidden = debt.debtType != .kari
        moneyLabel.text = "\(String.convertWithComma(from: abs(debt.money)) ?? "0")円"
        updateLayout()
    }

    private func updateLayout() {
        kashiLabel.layer.cornerRadius = kashiLabel.frame.height / 2
        kariLabel.layer.cornerRadius = kariLabel.frame.height / 2
    }
}

// MARK: - set up

extension DebtLogCell {

    private func setupKashiKariLabel() {
        kashiLabel.layer.masksToBounds = true
        kashiLabel.backgroundColor = UIColor.app.positiveColor

        kariLabel.layer.masksToBounds = true
        kariLabel.backgroundColor = UIColor.app.negativeColor
    }
}
