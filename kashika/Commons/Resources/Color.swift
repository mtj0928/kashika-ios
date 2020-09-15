//
//  Color.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/31.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

extension UIColor {

    static func create(defultColor: UIColor, dynamicProvider: @escaping (UITraitCollection) -> UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: dynamicProvider)
        }
        return defultColor
    }

    static func create(defultColor: UIColor, light lightColor: UIColor, dark darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .light:
                    return lightColor
                case .dark:
                    return darkColor
                case .unspecified:
                    return defultColor
                @unknown default:
                    return defultColor
                }
            }
        }
        return defultColor
    }

    static func create(light lightColor: UIColor, dark darkColor: UIColor) -> UIColor {
        return create(defultColor: lightColor, light: lightColor, dark: darkColor)
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
            case .light, .unspecified:
                return UIColor.white
            case .dark:
                return UIColor.app.secondarySystemBackground
            @unknown default:
                fatalError("No implementation for userInterfaceStyle")
            }
        }
        var link: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor.link
            }
            return UIColor.systemBlue
        }
        private(set) lazy var floatingPanelBackgroundColor = UIColor.app.systemBackground
        let themaColor = UIColor(hex: "00528E")
        let white = UIColor.white
        let green = UIColor(hex: "149852")
        let positiveColor = UIColor(hex: "027AFF")
        let nonActiveWarikanSwitchColor = UIColor.create(light: UIColor(hex: "F4F4F4"), dark: UIColor(hex: "313131"))
        var activeWarikanSwitchColor: UIColor {
            return UIColor.app.positiveColor
        }
        var noactiveSwitchButtonToggleColor = UIColor.create(light: UIColor.white, dark: UIColor(hex: "5E5E5E"))
        var activeSwitchButtonToggleColor = UIColor.white
        let saveButtonColor = UIColor(hex: "007AFF")
        let nonActiveButtonColor = UIColor(hex: "BABEC4")
        let negativeColor = UIColor(hex: "D21350")
        let backgroundInImageView = UIColor.lightGray

        let redCardColor = UIColor.create(light: UIColor(hex: "BD4956"), dark: UIColor(hex: "702A32"))
        let blueCardColor = UIColor.create(light: UIColor(hex: "5D78C6"), dark: UIColor(hex: "2A3C70"))
        let grayCardColor = UIColor.create(light: UIColor(hex: "F2F1F6"), dark: UIColor(hex: "1C1C1E"))

        fileprivate init() {}

        func systemBackground(isSecondary: Bool) -> UIColor {
            return isSecondary ? secondarySystemBackground : systemBackground
        }
    }
}
