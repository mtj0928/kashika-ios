//
//  Debt.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Ballcap
import FirebaseFirestore

struct Debt: Codable, Equatable, Modelable {
    var money = 0
    var friendRef: DocumentReference?
}
