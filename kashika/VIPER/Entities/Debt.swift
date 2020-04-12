//
//  Debt.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/28.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Ballcap
import FirebaseFirestore

struct Debt: Codable, Equatable, Modelable, ModelIdentifier, UserObject {
    static let collectionName = "debts"

    var id = ""
    var userId: String = ""
    var money = 0
    var friendId: String?
    var paymentDate: Timestamp?
    var memo: String?
    var isPaid = false
}
