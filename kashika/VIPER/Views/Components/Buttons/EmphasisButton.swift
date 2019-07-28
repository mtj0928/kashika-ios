//
//  EmphasisButton.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/05.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

@IBDesignable
class EmphasisButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        sharedInit()
    }

    private func sharedInit() {
        layer.masksToBounds = true
        layer.cornerRadius = 5.0

        setTitleColor(UIColor.app.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
    }
}
