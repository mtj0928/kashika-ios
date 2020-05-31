//
//  WarikanHeaderView.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/30.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

final class WarikanHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var devideButton: UIButton!

    var text: String? {
        didSet {
            titleLabel.text = text
        }
    }

    var color: UIColor? {
        get {
            return backView.backgroundColor
        }
        set {
            backView.backgroundColor = newValue
        }
    }
}
