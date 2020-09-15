//
//  User.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import Ballcap

struct User: Codable, Equatable, Modelable, ModelIdentifier {
    var id: String = ""
    var name: String = ""
    var icon: File?
}
