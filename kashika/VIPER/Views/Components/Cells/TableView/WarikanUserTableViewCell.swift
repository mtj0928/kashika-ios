//
//  WarikanUserTableViewCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/30.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

final class WarikanUserTableViewCell: UITableViewCell {
    @IBOutlet private weak var userIconImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var effectedView: UIView!

    var color: UIColor? {
        get {
            return effectedView.backgroundColor
        }
        set {
            effectedView.backgroundColor = newValue
        }
    }

    var warikanUser: WarikanUser? {
        didSet {
            updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        userIconImage.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        userIconImage.layer.cornerRadius = userIconImage.frame.height / 2
    }

    private func updateView() {
        nameLabel.text = warikanUser?.name
        valueLabel.text = "\(warikanUser?.value ?? 0)円"

        if let reference = warikanUser?.friend?.iconFile?.storageReference {
            userIconImage.sd_setImage(with: reference)
        } else {
            userIconImage.image = nil
        }

        if let user = warikanUser {
            effectedView.isHidden = user.isSelected
        }
    }
}
