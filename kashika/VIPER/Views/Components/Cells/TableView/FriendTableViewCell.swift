//
//  FriendTableViewCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

final class FriendTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var kashiLabel: UILabel!
    @IBOutlet private weak var kariLabel: UILabel!
    @IBOutlet private weak var moneyLabel: UILabel!
    @IBOutlet private weak var moDebtLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
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

    func set(friend: Friend) {
        updateLayout()

        nameLabel.text = friend.name
        iconView.image = friend.icon
    }

    private func updateLayout() {
        kashiLabel.layer.cornerRadius = kashiLabel.frame.height / 2
        kariLabel.layer.cornerRadius = kariLabel.frame.height / 2
        iconView.layer.cornerRadius = iconView.frame.height / 2
    }
}
