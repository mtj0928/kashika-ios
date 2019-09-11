//
//  Friend.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Ballcap

struct Friend: Codable, Equatable, Modelable {
    var id: String = ""
    var name = ""
    var iconFile: File?
    var totalDebt: IncrementableInt = 0
}
