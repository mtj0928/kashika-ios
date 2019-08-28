//
//  TitleHeaderCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/25.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class TitleHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        if #available(iOS 13.0, *) {
            titleLabel.textColor = UIColor.secondaryLabel
        }
    }

    override var reuseIdentifier: String? {
        return "TitleHeaderView"
    }

    func set(title: String) {
        titleLabel.text = title
    }
}
