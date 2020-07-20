//
//  Friend.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/08/15.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import Ballcap
import RxSwift
import Firebase

struct Friend: Codable, Equatable, Modelable, UserObject {
    static let collectionName: String = "friends"

    var id: String = ""
    var userId: String = ""
    var name = ""
    var iconFile: File?
    var totalDebt: IncrementableInt = 0
    var token: String?
}

enum FriendError: Error {
    case tokenIsNil
}
