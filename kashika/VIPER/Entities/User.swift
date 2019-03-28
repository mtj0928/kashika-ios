//
//  User.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import Pring

@objcMembers
final class User: Object {
    dynamic var name: String = ""
    dynamic var photo: UIImage?

    override func encode(_ key: String, value: Any?) -> Any? {
        if key == "photo", let data = photo?.pngData() {
            return File(data: data, mimeType: .png)
        }
        return nil
    }

    override func decode(_ key: String, value: Any?) -> Bool {
        if key == "photo", let file = value as? File, let data = file.data {
            photo = UIImage(data: data)
            return true
        }
        return false
    }
}
