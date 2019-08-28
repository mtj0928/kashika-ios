//
//  TableViewCell.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/25.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet private weak var label: UILabel!

    func set(text: String) {
        label.text = text
    }
}
