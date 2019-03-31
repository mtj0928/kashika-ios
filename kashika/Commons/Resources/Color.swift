//
//  Color.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

extension UIColor {

    static var app: AppColor {
        return AppColor()
    }

    class AppColor {
        let themaColor = UIColor(hex: "00528E")
    }
}
