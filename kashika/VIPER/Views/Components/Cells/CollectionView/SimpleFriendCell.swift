//
//  SimpleFriensCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/06.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class SimnpleFriendCell: UICollectionViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        iconImageView.layer.masksToBounds = true
    }

    func setFriend() {
        updateLayout()
    }

    private func updateLayout() {
        layoutIfNeeded()
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
    }
}
