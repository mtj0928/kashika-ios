//
//  HomeTitleHeader.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/09/01.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class HomeTitleHeader: UITableViewHeaderFooterView {

    @IBOutlet private weak var label: UILabel!

    override var reuseIdentifier: String? {
        return "HomeTitleHeader"
    }

    func set(title: String) {
        self.label.text = title
    }
}
