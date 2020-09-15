//
//  InvitePopupView.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/26.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class InvitePopupView: UIView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var linkButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!

    var presenter: ConfirmationInvitePresenterProtocol! = nil {
        didSet {
            update()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
        setupView()
    }

    private func loadNib() {
        backgroundColor = UIColor.clear
        let view = R.nib.invitePopupView.firstView(owner: self)
        addViewWithFilling(view)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateCornerRadius()
    }

    @IBAction private func tappedDenyButton() {
        presenter.tappedDeny()
    }

    @IBAction private func tappedAcceptButton() {
        presenter.tappedAccept()
    }

    @IBAction func tappedLinkExistFriendButton(_ sender: Any) {
        presenter.tappedLink()
    }
}

// MARK: - View

extension InvitePopupView {

    private func setupView() {
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 8
        addButton.backgroundColor = UIColor.app.positiveColor
    }

    private func update() {
        updateCornerRadius()

        if presenter.friend.name.isEmpty {
            textLabel.text = "友達の招待が届いています"
        } else {
            textLabel.text = "\(presenter.friend.name)さんから友達の招待が届いています"
        }

        imageView.sd_setImage(with: presenter.friend.iconFile?.url)
    }

    private func updateCornerRadius() {
        imageView.layer.cornerRadius = imageView.layer.frame.height / 2
    }
}
