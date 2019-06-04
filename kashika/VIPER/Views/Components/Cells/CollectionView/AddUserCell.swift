//
//  AddUserCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/09.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIColor.AppColor {
    var tintColor: UIColor {
        return UIColor.gray
    }
}

class AddUserCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var mainView: UIView!

    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        mainView.layer.masksToBounds = true

        imageView.tintColor = UIColor.app.tintColor
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        layoutIfNeeded()
        mainView.layer.cornerRadius = mainView.frame.height / 2
        mainView.layer.borderWidth = 2.0
        mainView.layer.borderColor = UIColor.app.tintColor.cgColor
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let rect = mainView.bounds
        if rect.contains(point) {
            return self
        }
        return nil
    }

    func select() {
        scaleAnimate(transform: CGAffineTransform(scaleX: 0.8, y: 0.8))
    }

    func unselect() {
        scaleAnimate(transform: CGAffineTransform.identity)
    }

    private func scaleAnimate(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            self?.mainView.transform = transform
        })
    }
}
