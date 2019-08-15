//
//  Friend.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import Pring

@objcMembers
final class Friend: Object {
    dynamic var name = ""
    dynamic var icon: UIImage?

    override func encode(_ key: String, value: Any?) -> Any? {
        if key == "icon", let data = icon?.pngData() {
            return File(data: data, mimeType: .png)
        }
        return nil
    }

    override func decode(_ key: String, value: Any?) -> Bool {
        if key == "icon", let file = value as? File, let data = file.data {
            icon = UIImage(data: data)
            return true
        }
        return false
    }
}
