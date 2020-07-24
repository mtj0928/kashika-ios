//
//  DeeplinkType.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/07/23.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum DeeplinkType: String {
    case friendInvite
}

struct FriendInvieEntity {

    let path: String
    let token: String

    static func parse(from url: URL) -> FriendInvieEntity? {
        let queries = url.queries
        guard let path = queries["path"],
            let token = queries["token"] else {
            return nil
        }
        
        return FriendInvieEntity(path: path, token: token)
    }
}
