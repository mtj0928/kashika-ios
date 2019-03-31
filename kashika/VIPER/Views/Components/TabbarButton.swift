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

        self.backgroundColor = UIColor.blue
        self.imageView.backgroundColor = UIColor.red
        self.imageView.layer.borderWidth = 3.0
        self.imageView.layer.cornerRadius = 35
        self.superview?.bringSubviewToFront(self)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
