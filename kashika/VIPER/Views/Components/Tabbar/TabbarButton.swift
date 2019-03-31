//
//  TabbarButton.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import ESTabBarController

class TabbarButton: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.backgroundColor = UIColor.app.themaColor

        superview?.bringSubviewToFront(self)

        textColor = .clear
        highlightTextColor = .clear
        iconColor = .white
        highlightIconColor = .white
        backdropColor = .clear
        highlightBackdropColor = .clear
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayout() {
        super.updateLayout()
        let minSide = min(frame.height, frame.width)
        imageView.frame.size = CGSize(width: minSide, height: minSide)
        imageView.center = center
        imageView.layer.cornerRadius = minSide / 2
    }
}
