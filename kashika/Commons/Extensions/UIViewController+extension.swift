//
//  UIViewController+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

extension UIViewController {

    class func createFromStoryboard() -> Self {
        // swiftlint:disable force_unwrapping
        let name = String(describing: type(of: self)).components(separatedBy: ".").first!
        // swiftlint:enable force_unwrapping
        return instantiateFromStoryboard(storyboardName: name)
    }

    private class func instantiateFromStoryboard<T>(storyboardName: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        // swiftlint:disable force_cast
        return storyboard.instantiateInitialViewController() as! T
        // swiftlint:enable force_cast
    }
}
