//
//  CalendarViewCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/03.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewCell: JTAppleCell {
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var selectedView: UIView!

    override var isSelected: Bool {
        didSet {
            selectedView.isHidden = !self.isSelected
            selectedView.layer.cornerRadius = selectedView.frame.height / 2
        }
    }

    func set(_ text: String) {
        dateLabel.text = text
    }
}
