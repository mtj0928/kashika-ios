//
//  PrivateUserInformation.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/25.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import Ballcap
import FirebaseFirestore
import RxSwift

struct PrivateUserInformation: Codable, Modelable, ModelIdentifier {
    var id: String = ""
    var totalDebt: IncrementableInt = 0
}

extension PrivateUserInformation: UserObject {
    static let collectionName = "secure"

    var userId: String {
        return id
    }
}
