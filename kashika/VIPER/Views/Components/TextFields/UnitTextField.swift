//
//  UnitTextField.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/07/13.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class UnitTextField: UITextField {

    let unitLabel = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)

        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        sharedInit()
    }

    private func sharedInit() {
        unitLabel.sizeToFit()
        
        rightView = unitLabel
        rightViewMode = .always
    }
}
