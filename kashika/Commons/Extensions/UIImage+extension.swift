//
//  UIImage+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/20.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

extension UIImage {

    func resize(minLength: CGFloat) -> UIImage? {
        let ratio = minLength / max(size.width, size.height)
        return resize(ratio: min(1.0, ratio))
    }

    func resize(size inputedSize: CGSize) -> UIImage? {
        let widthRatio = inputedSize.width / size.width
        let heightRatio = inputedSize.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        return resize(ratio: ratio)
    }

    func resize(ratio: CGFloat) -> UIImage? {
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
