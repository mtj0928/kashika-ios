//
//  Friend.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Ballcap

struct Friend: Codable, Equatable, Modelable {
    var name = ""
    var iconFile: File?
    var totalDebt = 0
}
