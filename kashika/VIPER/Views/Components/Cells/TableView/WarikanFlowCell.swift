//
//  WarikanFlowCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/06/07.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class WarikanFlowCell: UITableViewCell {
    @IBOutlet private weak var fromUserIconImageView: UIImageView!
    @IBOutlet private weak var fromUserNameLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var toUserIconImageView: UIImageView!
    @IBOutlet private weak var toUserNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        [fromUserIconImageView, toUserIconImageView].forEach {
            $0?.layer.masksToBounds = true
            $0?.backgroundColor = UIColor.lightGray
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        [fromUserIconImageView, toUserIconImageView].forEach {
            guard let height = $0?.frame.height else { return }
            $0?.layer.cornerRadius = height / 2
        }
    }

    func update(_ flow: WarikanDebtFlow) {
        if let reference = flow.from.iconFile {
            fromUserIconImageView.sd_setImage(with: reference) 
        } else {
            fromUserIconImageView.image = nil
        }
        fromUserNameLabel.text = flow.from.name

        valueLabel.text = (String.convertWithComma(from: flow.value) ?? "0") + "円"

        if let reference = flow.to.iconFile {
            toUserIconImageView.sd_setImage(with: reference)
        } else {
            toUserIconImageView.image = nil
        }
        toUserNameLabel.text = flow.to.name
    }
}

