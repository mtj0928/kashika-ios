//
//  CloseButton.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/04/04.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

private extension UIColor.AppColor {
    var lightGrayInBackground: UIColor {
        return UIColor(hex: "F4F4F4")
    }
    var grayInButton: UIColor {
        return UIColor(hex: "BABABA")
    }
}

@IBDesignable
class CloseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        sharedInit()
    }

    private func sharedInit() {
        imageView?.contentMode = .scaleAspectFill
        setImage(R.image.crossWhite(), for: .normal)
        tintColor = UIColor.app.grayInButton

        layer.masksToBounds = true
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        layer.cornerRadius = rect.width / 2
    }
}
