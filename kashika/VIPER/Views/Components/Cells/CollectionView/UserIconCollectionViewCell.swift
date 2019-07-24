//
//  UserIconCollectionViewCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/18.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

fileprivate extension UIColor.AppColor {
    var tintColor: UIColor {
        return UIColor.lightGray
    }
}

class UserIconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var iconBackgrounfView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        iconBackgrounfView.layer.masksToBounds = true
        iconBackgrounfView.layer.borderWidth = 2.0
        iconBackgrounfView.layer.borderColor = UIColor.app.tintColor.cgColor
        iconImageView.tintColor = UIColor.app.tintColor
        iconImageView.image = iconImageView.image?.withRenderingMode(.alwaysTemplate)
        label.text = "友達一覧"
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        layoutIfNeeded()
        iconBackgrounfView.layer.cornerRadius = iconBackgrounfView.frame.height / 2
    }

    func select() {
        scaleAnimate(transform: CGAffineTransform(scaleX: 0.8, y: 0.8))
    }

    func unselect() {
        scaleAnimate(transform: CGAffineTransform.identity)
    }

    private func scaleAnimate(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            self?.transform = transform
        })
    }
}
