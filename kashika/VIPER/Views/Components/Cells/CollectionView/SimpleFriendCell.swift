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
    @IBOutlet private weak var fadeView: UIView!

    var isSecondary = false {
        didSet {
            fadeView.backgroundColor = UIColor.app.systemBackground(isSecondary: isSecondary)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        iconImageView.layer.masksToBounds = true
        fadeView.isHidden = true
        fadeView.alpha = 0.8
    }

    func setFriend(status: CellStatus) {
        switch status {
        case .selected:
            addBorder()
            fadeView.isHidden = true
        case .notSelected:
            removeBorder()
            fadeView.isHidden = false
        case .none:
            removeBorder()
            fadeView.isHidden = true
        }
        updateLayout()
    }

    private func addBorder() {
        iconImageView.layer.borderColor = UIColor.app.positiveColor.cgColor
        iconImageView.layer.borderWidth = 3.0
    }

    private func removeBorder() {
        iconImageView.layer.borderWidth = 0.0
    }

    private func updateLayout() {
        layoutIfNeeded()
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
    }
}
