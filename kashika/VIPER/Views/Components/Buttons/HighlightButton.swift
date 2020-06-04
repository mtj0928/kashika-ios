//
//  HighlightButton.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/24.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

class HighlightButton: UIButton {

    @IBInspectable var highlightBackgroundColor: UIColor? {
        didSet {
            guard let color = highlightBackgroundColor else {
                return
            }
            setBackgroundColor(color, for: .highlighted)
        }
    }

    private func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let image = color.image
        setBackgroundImage(image, for: state)
    }
}

extension UIColor {
    var image: UIImage {
        UIImage.filledImage(byColor: self)
    }
}

extension UIImage {

    static func filledImage(byColor color: UIColor) -> UIImage {
        if #available(iOS 13.0, *) { //ダークモードはiOS13からなので分岐する必要がある
            let image = UIImage()
            let appearances: [UIUserInterfaceStyle] = [.light, .dark]
            appearances.forEach {
                let traitCollection = UITraitCollection(userInterfaceStyle: $0)
                image.imageAsset?.register(UIImage.createImage(color.resolvedColor(with: traitCollection)),
                                           with: traitCollection) // ライトモードとダークモードの色を直接指定してImageを生成している
            }
            return image
        }
        return UIImage.createImage(color)
    }

    private static func createImage(_ rawColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(rawColor.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
