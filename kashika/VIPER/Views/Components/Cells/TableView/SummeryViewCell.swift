//
//  SummeryViewCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class SummeryViewCell: UITableViewCell {
    @IBOutlet private weak var mainView: SummeryView!

    override func awakeFromNib() {
        super.awakeFromNib()

        mainView.layer.cornerRadius = 8
    }

    func set(money: Int) {
        mainView.set(money)
    }
}
