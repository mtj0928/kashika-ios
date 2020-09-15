//
//  SimpleFrierndListCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/09/06.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class SimpleFrierndListCell: UITableViewCell {
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    private func setup() {
        iconImageView.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
    }
}

extension SimpleFrierndListCell {

    func set(_ friend: Friend) {
        iconImageView.sd_setImage(with: friend.iconFile?.originalURL)
        usernameLabel.text = friend.name
    }
}
