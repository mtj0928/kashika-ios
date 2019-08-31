//
//  Color.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

public extension UIColor {

    static var app: AppColor {
        return AppColor()
    }

    class AppColor {
        var systemBackground: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor.systemBackground
            }
            return UIColor.white
        }
        var secondarySystemBackground: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor.secondarySystemBackground
            }
            return UIColor.white
        }
        var label: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor.label
            }
            return UIColor.black
        }
        let themaColor = UIColor(hex: "00528E")
        let white = UIColor.white
        let positiveColor = UIColor(hex: "027AFF")
        let saveButtonColor = UIColor(hex: "007AFF")
        let nonActiveButtonColor = UIColor(hex: "BABEC4")
        let negativeColor = UIColor(hex: "D21350")
        let backgroundInImageView = UIColor.lightGray

        func systemBackground(isSecondary: Bool) -> UIColor {
            return isSecondary ? secondarySystemBackground : systemBackground
        }
    }

}
