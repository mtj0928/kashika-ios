//
//  LinkPopupView.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/15.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import RxCocoa
import SDWebImage
import SFSafeSymbols
import TapticEngine

class LinkPopupView: UIView {
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var linkCircleView: UIView!
    @IBOutlet private weak var unshownButton: UIButton!

    var tappedCloseButton: ControlEvent<Void> {
        return closeButton.rx.tap
    }

    private(set) var isSelectedUnshown = false
    var friend: Friend?

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
        let view = R.nib.linkPopupView.firstView(owner: self)
        addViewWithFilling(view)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateCornerRadius()
    }

    func set(_ friend: Friend) {
        self.friend = friend
        isSelectedUnshown = false
        updateUnshownButton()

        iconImageView.sd_setImage(with: friend.iconFile?.url)
        updateCornerRadius()
    }

    @IBAction func tappedUnshowButton() {
        TapticEngine.impact.feedback(.light)
        isSelectedUnshown.toggle()
        updateUnshownButton()
    }
}

// MARK: - View

extension LinkPopupView {

    private func setupView() {
        linkCircleView.layer.masksToBounds = true
        iconImageView.layer.masksToBounds = true
    }

    private func updateCornerRadius() {
        linkCircleView.layer.cornerRadius = linkCircleView.frame.height / 2
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2

        layoutIfNeeded()
    }

    private func updateUnshownButton() {
        unshownButton.tintColor = isSelectedUnshown ? UIColor.app.green : UIColor.systemGray4
        let image = isSelectedUnshown ? UIImage(systemSymbol: .checkmarkCircleFill) : UIImage(systemSymbol: .checkmarkCircle)
        unshownButton.setImage(image, for: .normal)
    }
}
