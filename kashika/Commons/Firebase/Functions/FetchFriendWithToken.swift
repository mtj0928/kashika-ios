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

    static let name = "fetchFriend"

    typealias Input = Request
    typealias Output = FetchedFriend
}

extension FetchFriendWithToken {

    struct Request: Encodable {
        let userId: String
        let friendId: String
        let token: String

        static func parse(url: URL) -> Self? {
            let queries = url.queries
            guard let userId = queries["userId"],
                let friendId = queries["friendId"],
                let token = queries["token"] else {
                    return nil
            }
            return Request(userId: userId, friendId: friendId, token: token)
        }
    }
    
    struct FetchedFriend: Decodable {
        let id: String
        let name: String
        let iconFile: File?
    }
}
