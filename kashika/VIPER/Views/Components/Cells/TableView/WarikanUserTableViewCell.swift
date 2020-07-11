//
//  WarikanUserTableViewCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/30.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class WarikanUserTableViewCell: UITableViewCell {
    @IBOutlet private weak var userIconImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var editButton: HighlightButton!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var effectedView: UIView!
    @IBOutlet private weak var backgroundEditButton: HighlightButton!

    private(set) lazy var tapped = ControlEvent<Void>.merge(
        [self.editButton.rx.tap.asObservable(), self.backgroundEditButton.rx.tap.asObservable()]
    )

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

    private(set) var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        userIconImage.layer.masksToBounds = true
        editButton.layer.masksToBounds = true
        backgroundEditButton.layer.masksToBounds = true
        backgroundEditButton.layer.cornerRadius = 8.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        userIconImage.layer.cornerRadius = userIconImage.frame.height / 2
        editButton.layer.cornerRadius = editButton.frame.height / 2
        editButton.highlightBackgroundColor = editButton.backgroundColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    private func updateView() {
        nameLabel.text = warikanUser?.name
        valueLabel.text = "\(warikanUser?.value ?? 0)円"

        if let reference = warikanUser?.iconFile {
            userIconImage.sd_setImage(with: reference)
        } else {
            userIconImage.image = nil
        }

        if let user = warikanUser {
            effectedView.isHidden = user.isSelected
        }
    }
}
