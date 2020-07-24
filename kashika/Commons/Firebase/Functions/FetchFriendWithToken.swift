//
//  FetchFriendWithToken.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/24.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import Ballcap

struct FetchFriendWithToken: CallableFunctions {
    typealias Input = Request
    typealias Output = FetchedFriend

    static let name = "fetchFriend"
}

extension FetchFriendWithToken {

    struct Request: Encodable {
        let userId: String
        let friendId: String
        let token: String
    }
    
    struct FetchedFriend: Decodable {
        let id: String
        let userId: String
        let name: String
        let iconFile: File?
        let totalDebt: IncrementableInt
        let token: String?
    }
}
