//
//  UIApplication+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/09/05.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import UIKit

extension UIApplication {

    var topmostViewController: UIViewController? {
        delegate?.window??.rootViewController
    }
}
