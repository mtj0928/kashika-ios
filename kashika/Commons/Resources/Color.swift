//
//  Color.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

fileprivate extension UIColor {

    static func create(defultColor: UIColor, dynamicProvider: @escaping (UITraitCollection) -> UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: dynamicProvider)
        }
        return defultColor
    }
}

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
        let notificationColor: UIColor = UIColor.create(defultColor: UIColor.white) { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor.white
            case .dark:
                return UIColor(hex: "6f6e70")
            @unknown default:
                fatalError("No implementation for userInterfaceStyle")
            }
        }
        var label: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor.label
            }
            return UIColor.black
        }
        var placeHolderText: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor.placeholderText
            }
            return UIColor.lightGray
        }
        var cardViewBackgroundColor = UIColor.create(defultColor: UIColor.white) { (traitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return UIColor.white
            case .dark:
                return UIColor.app.secondarySystemBackground
            @unknown default:
                fatalError("No implementation for userInterfaceStyle")
            }
        }
        let themaColor = UIColor(hex: "00528E")
        let white = UIColor.white
        let positiveColor = UIColor(hex: "027AFF")
        let saveButtonColor = UIColor(hex: "007AFF")
        let nonActiveButtonColor = UIColor(hex: "BABEC4")
        let negativeColor = UIColor(hex: "D21350")
        let backgroundInImageView = UIColor.lightGray

        fileprivate init() {}

        func systemBackground(isSecondary: Bool) -> UIColor {
            return isSecondary ? secondarySystemBackground : systemBackground
        }
    }

}
